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
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(CustomCreationViewController.exitView))
    customCreationExit.addGestureRecognizer(tap)
    
    let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(CustomCreationViewController.exitView))
    swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
    self.view.addGestureRecognizer(swipeDownGesture)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  } 
  
  @objc func exitView() {
    print("exiting custom creation view")
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func chooseImage() {
    if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)) {
      print("attempting to get image from library")
      imagePicker.delegate = self
      imagePicker.sourceType = .savedPhotosAlbum
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
