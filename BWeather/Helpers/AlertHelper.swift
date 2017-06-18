//
//  AlertHelper.swift
//  BWeather
//
//  Created by Bence Pattogato on 31/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import UIKit

final class AlertHelper {
  
  static func showError(from: UIViewController, error: Error, retryActionHandler: ((UIAlertAction) -> Void)?) {
    showErrorWithRetry(title: "error.title".localized,
                       message: error.localizedDescription,
                       cancelTitle: "error.cancel".localized,
                       retryTitle: "error.retry".localized,
                       from: from,
                       retryActionHandler: retryActionHandler)
  }
  
  static func showNetworkAlert(from: UIViewController, retryActionHandler: ((UIAlertAction) -> Void)?) {
    showErrorWithRetry(title: "error.title".localized,
                       message: "error.network.message".localized,
                       cancelTitle: "error.cancel".localized,
                       retryTitle: "error.retry".localized,
                       from: from, retryActionHandler: retryActionHandler)
  }
  
  /**
   Shows an alert on the viewcontroller with only cancel
   
   - Parameters:
   - title: Alert's title
   - message: Alert's message
   - cancelTitle: Cancel button's title
   - from: the viewcontroller the alert should be presented from
   
   */
  static func showAlert(title: String, message: String, cancelTitle: String, from: UIViewController) {
    from.present(alert(title: title,
                       message: message,
                       cancelAction: createAction(title: cancelTitle),
                       preferredStyle: .alert,
                       actions: nil),
                 animated: true,
                 completion: nil)
  }
  
  /**
   Shows an alert on the viewcontroller with cancel and retry actions
   
   - Parameters:
   - title: Alert's title
   - message: Alert's message
   - cancelTitle: Cancel button's title
   - retryTitle: Retry button's title
   - from: The viewcontroller the alert should be presented from
   - retryActionHandler: A block to execute when the retry button is tapped
   
   */
  static func showErrorWithRetry(title: String,
                                 message: String,
                                 cancelTitle: String,
                                 retryTitle: String,
                                 from: UIViewController,
                                 retryActionHandler: ((UIAlertAction) -> Void)?) {
    
    from.present(alert(title: title,
                       message: message,
                       cancelAction: createAction(title: cancelTitle),
                       preferredStyle: .alert,
                       actions: [
                        createAction(title: retryTitle,
                                     style: .default,
                                     handler: retryActionHandler)
      ]),
                 animated: true,
                 completion: nil)
  }
  
  /**
   Creates a UIAlertAction with the given parameters
   */
  static func createAction(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    return UIAlertAction(title: title, style: style, handler: handler)
  }
  
  /**
   Creates a UIAlertController
   
   - Parameters:
   - title: alert's title
   - mesage: alert's message
   - cancelAction: UIAlertAction to execute on cancel button tap
   - preferredStyle: Alert's style
   
   - Returns: UIAlertController instance
   */
  private static func alert(title: String?, message: String?, cancelAction: UIAlertAction, preferredStyle: UIAlertControllerStyle = .alert,
                            actions: [UIAlertAction]? = nil) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    
    if let actions = actions {
      for action in actions {
        alertController.addAction(action)
      }
    }
    
    alertController.addAction(cancelAction)
    return alertController
  }
}
