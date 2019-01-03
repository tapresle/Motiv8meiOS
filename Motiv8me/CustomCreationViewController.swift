//
//  CustomCreationViewController.swift
//  Motiv8me
//
//  Created by Ted Presley on 1/1/19.
//  Copyright © 2019 Ted Presley. All rights reserved.
//

import UIKit

class CustomCreationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @IBOutlet private var customCreationExit: UIButton!
  @IBOutlet var chosenImage: UIImageView!
  @IBOutlet var customQuote: UITextView!
    
  var imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("loaded custom creation view")
    
    let exitTap = UITapGestureRecognizer(target: self, action: #selector(CustomCreationViewController.exitView))
    customCreationExit.addGestureRecognizer(exitTap)
    
    let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(CustomCreationViewController.exitView))
    swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
    self.view.addGestureRecognizer(swipeDownGesture)
    
    let closeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(CustomCreationViewController.closeKeyboard))
    self.view.addGestureRecognizer(closeKeyboardTap)
    
    let imageChooserTap = UITapGestureRecognizer(target: self, action: #selector(CustomCreationViewController.chooseImage))
    chosenImage.addGestureRecognizer(imageChooserTap)
    
    // Setup the custom quote text to look similar to pre-rendered text
    // TODO: Allow for custom fonts
    customQuote.attributedText = NSAttributedString(string: customQuote.text ?? "", attributes: [
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : -1 * 4,
      NSAttributedString.Key.foregroundColor : UIColor.white,
      NSAttributedString.Key.font : UIFont(name: "Noteworthy-Bold", size: 40.0)!
      ] as [NSAttributedString.Key : Any])
    customQuote.textAlignment = NSTextAlignment.center
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  } 
  
  @objc func exitView() {
    print("exiting custom creation view")
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func closeKeyboard() {
    self.view.endEditing(true)
  }
  
  @objc func chooseImage() {
    if (customQuote.isFirstResponder) {
      print("user is currently editing the text, don't open photos but close keyboard")
      closeKeyboard()
    } else if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
      print("attempting to get image from library")
      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = false
      
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  @IBAction func generateImageQuote() {
    
  }
    
  // Implements the Delegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      chosenImage.image = pickedImage
    }
    
    self.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
