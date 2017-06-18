//
//  CountryPickerViewController.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 09..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import UIKit
import CountryPicker

protocol CountryPickerControllerDelegate: class {
  
  func countryPickerControllerDismissed(selectedCountry: String)
  
}

class CountryPickerViewController: UIViewController, CountryPickerDelegate {

  weak var delegate: CountryPickerControllerDelegate?
  
  private var selectedCountry: String = ""
  
  func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
    selectedCountry = code
  }
  
  @IBAction func doneButtonTouched(_ sender: Any) {
    self.dismiss(animated: true, completion: { [weak self] in
      if let strongSelf = self {
        strongSelf.delegate?.countryPickerControllerDismissed(selectedCountry: strongSelf.selectedCountry)
      }
    })
  }

}
