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
  @IBOutlet var imageChooserButton: UIButton!
  @IBOutlet var chosenImage: UIImageView!
  @IBOutlet var customQuote: UITextView!
  @IBOutlet var createdImage: UIImageView!
    
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
    createdImage.image = textToImage(drawText: customQuote.text, inImage: chosenImage.image!, atPoint: CGPoint(x: 0, y: 0))
  }
  
  func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
    let textColor = UIColor.white
    let textFont = UIFont(name: "MarkerFelt-Wide", size: 140)!
    
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
    
    let textFontAttributes = [
      NSAttributedString.Key.font: textFont,
      NSAttributedString.Key.foregroundColor: textColor,
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : -1 * 4,
      ] as [NSAttributedString.Key : Any]
    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    
    let rect = CGRect(origin: point, size: CGSize(width: image.size.width - 50, height: image.size.height - 50))
    text.draw(in: rect, withAttributes: textFontAttributes)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
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
