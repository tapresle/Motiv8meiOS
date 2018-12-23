//
//  ViewController.swift
//  Motiv8me
//
//  Created by Ted Presley on 8/20/16.
//  Copyright © 2016 - 2018 Ted Presley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  @IBOutlet private var changingImage: UIImageView!
  @IBOutlet private var quoteLabel: UIOutlinedLabel!
  @IBOutlet private var appLabel: UILabel!
  
  private var changeInterval = Timer()
  private var useTimer = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Fix to assign the default correctly if user doesn't open Settings before opening the app
    if (UserDefaults.standard.value(forKey: "TIMER_PREF") == nil) {
      UserDefaults.standard.set(true, forKey: "TIMER_PREF")
    }
    
    setupTapGestures()
    setupNotifications()
    setupAppLabel()
    setupImageView()
    setupQuoteLabel()
    
    // Do the thing
    tappedMe()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Set new image/quote and restart the timer
  @objc private func tappedMe() {
    let currentImageQuote = ImageQuoteModel(image: self.changingImage.image ?? UIImage(), quote: self.quoteLabel.text ?? "", font: self.quoteLabel.font ?? UIFont())
    let newImageQuote = generateNewImageQuote(currentImageQuote: currentImageQuote)
    UIView.transition(with: changingImage,
                      duration: 1,
                      options: UIView.AnimationOptions.transitionCrossDissolve,
                      animations: { self.changingImage.image = newImageQuote.image;
                        self.quoteLabel.text = newImageQuote.quote;
                        self.quoteLabel.center = self.view.center;
                        self.quoteLabel.font = newImageQuote.font },
                      completion: nil)
    stopTimer()
    startTimer()
  }
  
  @objc private func transitionForOrientationSwitch() {
    quoteLabel.frame = getQuoteLabelFrame()
    appLabel.frame = getAppLabelFrame()
    self.quoteLabel.center = self.view.center
  }
  
  @objc private func toggleTimer() {
    if (changeInterval.isValid) {
      stopTimer()
    } else {
      tappedMe()
    }
  }
  
  @objc private func settingsChanged() {
    useTimer = UserDefaults.standard.bool(forKey: "TIMER_PREF")
    print("Settings Changed...")
    print("useTimer: " + useTimer.description)
    
    if (!useTimer) {
      stopTimer()
    } else {
      startTimer()
    }
  }
  
  @objc private func startTimer() {
    if (useTimer && !changeInterval.isValid) {
      changeInterval = Timer.scheduledTimer(
        timeInterval: 10.0,
        target: self,
        selector: #selector(ViewController.tappedMe),
        userInfo: nil,
        repeats: false)
      
      print("Starting timer")
    }
  }
  
  @objc private func stopTimer() {
    changeInterval.invalidate()
    
    print("Stopped timer")
  }
  
  private func setupTapGestures() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedMe))
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleTimer))
    doubleTap.numberOfTapsRequired = 2
    
    // Delay execution on single tap to make sure the user didn't double tap
    tap.require(toFail: doubleTap)
    tap.delaysTouchesBegan = true
    doubleTap.delaysTouchesBegan = true
    
    changingImage.addGestureRecognizer(tap)
    changingImage.addGestureRecognizer(doubleTap)
  }
  
  private func setupNotifications() {
    // Observer for when the device orientation changes
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.transitionForOrientationSwitch), name: UIDevice.orientationDidChangeNotification, object: nil)
    
    // Observer for preferences/settings changing
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.settingsChanged), name: UserDefaults.didChangeNotification, object: nil)
    
    // Observers to stop and start timers depending on app's context
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.stopTimer), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.startTimer), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  private func setupAppLabel() {
    appLabel = UILabel()
    appLabel.text = "Motiv8me"
    appLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
    appLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    appLabel.frame = getAppLabelFrame()
    appLabel.sizeToFit()
    self.view.addSubview(appLabel)
  }
  
  private func setupImageView() {
    changingImage.isUserInteractionEnabled = true
    changingImage.contentMode = .scaleAspectFill
    changingImage.image = UIImage()
  }
  
  private func setupQuoteLabel() {
    quoteLabel = UIOutlinedLabel()
    quoteLabel.textColor = UIColor.white
    quoteLabel.numberOfLines = 10;
    quoteLabel.textAlignment = .center;
    quoteLabel.frame = getQuoteLabelFrame()
    quoteLabel.center = self.view.center
    self.view.addSubview(quoteLabel)
  }
  
  private func generateNewImageQuote(currentImageQuote: ImageQuoteModel) -> ImageQuoteModel {
    let quoteRand = Int(arc4random_uniform(UInt32(DataStore.quotes.count)))
    let imageRand = Int(arc4random_uniform(UInt32(DataStore.images.count)))
    let fontRand = Int(arc4random_uniform(UInt32(DataStore.fonts.count)))
    let newImage = UIImage(named: DataStore.images[imageRand])
    let newQuote = DataStore.quotes[quoteRand]
    let newFont = UIFont(name: DataStore.fonts[fontRand], size: 40)
    
    if (currentImageQuote.image == newImage || currentImageQuote.quote == newQuote) {
      return generateNewImageQuote(currentImageQuote: currentImageQuote)
    }

    return ImageQuoteModel(image: newImage ?? currentImageQuote.image, quote: newQuote, font: newFont ?? currentImageQuote.font)
  }
  
  private func getAppLabelFrame() -> CGRect {
    return CGRect(origin: CGPoint(x: UIScreen.main.bounds.width - 120, y: UIScreen.main.bounds.height - 40), size: CGSize(width: 100, height: 20))
  }
  
  private func getQuoteLabelFrame() -> CGRect {
    return CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 50))
  }
}
