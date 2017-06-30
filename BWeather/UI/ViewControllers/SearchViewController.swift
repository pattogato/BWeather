//
//  SearchViewController.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import CountryPicker
import SnapKit

protocol SearchDataProviderProtocol {
  func search(for text: String) -> Observable<CurrentWeatherViewModelProtocol>
  func searchFor(zip: String, country: String) -> Observable<CurrentWeatherViewModelProtocol>
  func searchForLocation() -> Observable<CurrentWeatherViewModelProtocol>
  func loadMostRecentLocation() -> Observable<CurrentWeatherViewModelProtocol>
}

protocol CurrentWeatherViewModelProtocol {
  var city: String { get }
  var country: String { get }
  var shortDescription: String { get }
  var currentTemperature: String { get }
  var imageUrl: URL? { get }
  var moreInfo: [(title: String, info: String)] { get }
}

class SearchViewController: UIViewController {
  
  // MARK: - Constants
  fileprivate struct Constants {
    static let collectionViewCellId = "WeatherInfoTableViewCell"
    static let countrySelectorHeight: CGFloat = 150.0
  }
  
  // MARK: - Dependencies
  
  var dataProvider: SearchDataProviderProtocol!
  
  // MARK: - Properties
  
  fileprivate var disposeBag = DisposeBag()
  fileprivate var viewModel: CurrentWeatherViewModelProtocol?
  private var countryPickerContainerView: UIView?
  fileprivate var zipSearchText: String?
  fileprivate var viewTapGestureRecognizer: UITapGestureRecognizer?
  fileprivate var firstAppearance: Bool = true
  fileprivate var selectedCountryCode: String? {
    didSet {
      print(selectedCountryCode!)
    }
  }
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var weatherShortDescriptionLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noRecentsLabel: UILabel!
  
  // MARK: - Lifecycle methods
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if firstAppearance {
      firstAppearance = false
      searchMostRecent()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let pickerVC = segue.destination as? CountryPickerViewController {
      pickerVC.delegate = self
    } else if let recentVC = segue.destination as? RecentSearchListTableViewController {
      recentVC.delegate = self
    }
  }
  
}

// MARK: - Business logic & content related functions

extension SearchViewController {
  
  fileprivate func setupUI(viewModel: CurrentWeatherViewModelProtocol?) {
    showNoRecentsLabel(viewModel == nil)
    
    cityLabel.text = viewModel?.city ?? ""
    weatherShortDescriptionLabel.text = viewModel?.shortDescription ?? ""
    countryLabel.text = viewModel?.country ?? ""
    currentTemperatureLabel.text = viewModel?.currentTemperature ?? ""
    if let imageUrl = viewModel?.imageUrl {
      iconImageView.kf.setImage(with: ImageResource(downloadURL: imageUrl))
    } else {
      iconImageView.image = nil
    }
    
    self.viewModel = viewModel
    self.tableView.reloadData()
  }
  
  fileprivate func searchCity(text: String) {
    LoaderHelper.showLoader()
    _ = dataProvider.search(for: text).subscribe { event in
      LoaderHelper.dismissLoader()
      switch event {
      case .next(let viewModel):
        self.setupUI(viewModel: viewModel)
      case .error(let error):
        AlertHelper.showError(from: self, error: error, retryActionHandler: { _ in
          self.searchCity(text: text)
        })
      default:
        break
      }
    }
  }
  
  fileprivate func searchZip(text: String) {
    zipSearchText = text
    showCountryPicker()
  }
  
  fileprivate func showCountryPicker() {
    self.performSegue(withIdentifier: "CountryPickerSegue", sender: nil)
  }
  
  fileprivate func searchForLocation() {
    LoaderHelper.showLoader(title: "Getting location information & loading weather")
    dataProvider.searchForLocation().subscribe { (event) in
      LoaderHelper.dismissLoader()
      switch event {
      case .next(let weatherViewModel):
        self.setupUI(viewModel: weatherViewModel)
        if let cityName = self.viewModel?.city {
          self.searchBar.text = cityName
        }
      case .error(let error):
        AlertHelper.showError(from: self, error: error, retryActionHandler: { (_) in
          self.searchForLocation()
        })
      default:
        break
      }
    }.addDisposableTo(disposeBag)
  }
  
  fileprivate func enableViewGestureRecognizer(_ enable: Bool) {
    if enable && viewTapGestureRecognizer == nil {
      viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
      self.view.addGestureRecognizer(viewTapGestureRecognizer!)
    }
    viewTapGestureRecognizer?.isEnabled = true
  }
  
  fileprivate func searchMostRecent() {
    dataProvider.loadMostRecentLocation().subscribe { (weatherEvent) in
      switch weatherEvent {
      case .next(let weathViewModel):
        self.setupUI(viewModel: weathViewModel)
      case .error:
        self.setupUI(viewModel: nil)
      default:
        break
      }
      }.addDisposableTo(disposeBag)
  }
  
  fileprivate func showNoRecentsLabel(_ show: Bool) {
    noRecentsLabel.isHidden = !show
  }
  
  func viewDidTap() {
    searchBar.resignFirstResponder()
    enableViewGestureRecognizer(false)
  }
}

// MARK: - IBActions
extension SearchViewController {
  
  @IBAction func locationBarButtonItemDidTap(_ sender: Any) {
    searchForLocation()
  }
  
}

// MARK: - UISearchBarDelegate methods

extension SearchViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text,
      !text.isEmpty else {
        return
    }
    self.searchBar.resignFirstResponder()
    if text.isNumeric {
      searchZip(text: text)
    } else {
      searchCity(text: text)
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    enableViewGestureRecognizer(true)
  }
  
  
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource methods

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.moreInfo.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: Constants.collectionViewCellId, for: indexPath)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let item = viewModel?.moreInfo[indexPath.row] else {
      assertionFailure("ViewModel should be set")
      return
    }
    cell.textLabel?.text = item.title
    cell.detailTextLabel?.text = item.info
  }
  
}

// MARK: - CountryPickerDelegate methods

extension SearchViewController: CountryPickerControllerDelegate {
  
  func countryPickerControllerDismissed(selectedCountry: String) {
    LoaderHelper.showLoader()
    if let text = self.zipSearchText {
      _ = dataProvider.searchFor(zip: text, country: selectedCountry).subscribe { event in
        LoaderHelper.dismissLoader()
        switch event {
        case .next(let viewModel):
          self.setupUI(viewModel: viewModel)
        case .error(let error):
          AlertHelper.showError(from: self, error: error, retryActionHandler: { _ in
            self.searchZip(text: text)
          })
        default:
          break
        }
      }
    }
  }
  
}

// MARK: - RecentSearchListDelegate methods

extension SearchViewController: RecentSearchListDelegate {
  
  func itemTouched(text city: String) {
    searchCity(text: city)
    searchBar.text = city
  }
  
}

