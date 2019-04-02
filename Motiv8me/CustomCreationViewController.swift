//
//  CustomCreationViewController.swift
//  Motiv8me
//
//  Created by Ted Presley on 1/1/19.
//  Copyright © 2019 Ted Presley. All rights reserved.
//

import UIKit

class CustomCreationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    UITextViewDelegate {
  @IBOutlet private var customCreationExit: UIButton!
  @IBOutlet var chosenImage: UIImageView!
  @IBOutlet var customQuote: UITextView!
    
  var imagePicker = UIImagePickerController()
  
  override open var shouldAutorotate: Bool {
    return false
  }
  
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
    
    customQuote.delegate = self
    
    // Setup observers to move the screen when the keyboard shows up and goes away
    NotificationCenter.default.addObserver(self, selector: #selector(CustomCreationViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(CustomCreationViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Setup the custom quote text to look similar to pre-rendered text
    // TODO: Allow for custom fonts
    customQuote.attributedText = NSAttributedString(string: customQuote.text ?? "", attributes: [
      NSAttributedString.Key.strokeColor : UIColor.black,
      NSAttributedString.Key.strokeWidth : -1 * 4,
      NSAttributedString.Key.foregroundColor : UIColor.white,
      NSAttributedString.Key.font : UIFont(name: "Noteworthy-Bold", size: 40.0)!
      ] as [NSAttributedString.Key : Any])
    customQuote.textAlignment = NSTextAlignment.center
    customQuote.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: chosenImage.frame.size.width - 50, height: chosenImage.frame.size.height - 50))
    customQuote.sizeToFit()
    customQuote.center = chosenImage.center
    
    if (UserDefaults.standard.value(forKey: CUSTOM_CREATION_PROMPT_VERSION) == nil) {
      showInitialPrompt()
    }
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
  
  @objc func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {return}
    guard let kbSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    let kbFrame = kbSize.cgRectValue
    if (self.view.frame.origin.y == 0) {
      self.view.frame.origin.y -= kbFrame.height
    }
  }
  
  @objc func keyboardWillHide() {
    self.view.frame.origin.y = 0
  }
  
  @objc func showSavedPrompt(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    let alertController = generateSavedPrompt(image, didFinishSavingWithError: error, contextInfo: contextInfo)
    present(alertController, animated: true)
  }
  
  @IBAction func generateImageQuote() {
    let imageFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: chosenImage.frame.width, height: chosenImage.frame.height))
    let imageView = UIImageView(frame: imageFrame)
    imageView.contentMode = .scaleAspectFill
    imageView.image = chosenImage.image!
    
    let quoteFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: imageView.frame.size.width - 50, height: imageView.frame.size.height - 50))
    let quoteLabel = UIOutlinedLabel(frame: quoteFrame)
    quoteLabel.text = customQuote.text
    quoteLabel.textColor = UIColor.white
    quoteLabel.numberOfLines = 10;
    quoteLabel.textAlignment = .center;
    quoteLabel.center = imageView.center
    quoteLabel.font = UIFont(name: "Noteworthy-Bold", size: 40)
    
    let appLabel = UILabel()
    appLabel.text = "Made with Motiv8me"
    appLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
    appLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    appLabel.frame = CGRect(origin: CGPoint(x: imageView.frame.size.width - 130, y: imageView.frame.size.height - 60), size: CGSize(width: 100, height: 20))
    appLabel.numberOfLines = 2
    appLabel.textAlignment = .center
    appLabel.sizeToFit()
    
    imageView.addSubview(quoteLabel)
    imageView.addSubview(appLabel)
    
    UIGraphicsBeginImageContextWithOptions(imageFrame.size, true, 0.0)
    let currentGraphicsContext = UIGraphicsGetCurrentContext()
    imageView.layer.render(in: currentGraphicsContext!)
    
    let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    UIImageWriteToSavedPhotosAlbum(generatedImage!, self, #selector(CustomCreationViewController.showSavedPrompt(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
  func showInitialPrompt() {
    let alert = UIAlertController(title: "Create your own image!", message: CUSTOM_CREATION_MESSAGE, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      UserDefaults.standard.set(true, forKey: CUSTOM_CREATION_PROMPT_VERSION)
    }))
    self.present(alert, animated: true, completion: nil)
  }
    
  // Implements the Image Picker Delegate functions
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      chosenImage.image = pickedImage
    }
    
    self.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let newFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: chosenImage.frame.size.width - 50, height: chosenImage.frame.size.height - 50))
    textView.frame = newFrame
    textView.sizeToFit()
    textView.center = chosenImage.center
  }
}
