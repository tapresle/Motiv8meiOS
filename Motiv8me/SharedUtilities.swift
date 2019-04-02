//
//  SharedUtilities.swift
//  Motiv8me
//
//  Created by Ted Presley on 4/1/19.
//  Copyright © 2019 Ted Presley. All rights reserved.
//

import UIKit

func generateSavedPrompt(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) -> UIAlertController {
  var title = "Success!"
  var message = IMAGE_SAVE_SUCCESS_MESSAGE
  
  if (error != nil) {
    title = "Uh oh!"
    message = IMAGE_SAVE_ERROR_MESSAGE
  }
  
  let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
  alertController.addAction(UIAlertAction(title: "OK", style: .default))
  return alertController
}
