//
//  ViewController.swift
//  Motiv8me
//
//  Created by Ted Presley on 8/20/16.
//  Copyright © 2016 - 2018 Ted Presley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var changingImage: UIImageView!
    @IBOutlet var quoteLabel: UIOutlinedLabel!
    @IBOutlet var appLabel: UILabel!
    
    private var changeInterval = Timer()
    private var useTimer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tap gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedMe))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleTimer))
        doubleTap.numberOfTapsRequired = 2
        
        // Delay execution on single tap to make sure the user didn't double tap
        tap.require(toFail: doubleTap)
        tap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        // Observer for when the device orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.transitionForOrientationSwitch), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Observer for preferences/settings changing
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.settingsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        // Setup app label
        appLabel = UILabel()
        appLabel.text = "Motiv8me"
        appLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        appLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        appLabel.frame = getAppLabelFrame()
        appLabel.sizeToFit()
        self.view.addSubview(appLabel)
        
        
        // Setup image view
        changingImage.addGestureRecognizer(tap)
        changingImage.addGestureRecognizer(doubleTap)
        changingImage.isUserInteractionEnabled = true
        changingImage.contentMode = .scaleAspectFill
        changingImage.image = UIImage()
        
        // Setup quote label
        quoteLabel = UIOutlinedLabel()
        quoteLabel.textColor = UIColor.white
        quoteLabel.numberOfLines = 10;
        quoteLabel.textAlignment = .center;
        quoteLabel.frame = getQuoteLabelFrame()
        quoteLabel.font = UIFont(name: "Noteworthy-Bold", size: 40)
        quoteLabel.center = self.view.center
        self.view.addSubview(quoteLabel)
        tappedMe()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set new image/quote and restart the timer
    @objc func tappedMe() {
        let currentImageQuote = ImageQuoteModel(image: self.changingImage.image ?? UIImage(), quote: self.quoteLabel.text ?? "")
        let newImageQuote = generateNewImageQuote(currentImageQuote: currentImageQuote)
        UIView.transition(with: changingImage,
                                  duration: 1,
                                  options: UIView.AnimationOptions.transitionCrossDissolve,
                                  animations: { self.changingImage.image = newImageQuote.image;
                                    self.quoteLabel.text = newImageQuote.quote;
                                    self.quoteLabel.center = self.view.center },
                                  completion: nil)
        changeInterval.invalidate()
        startTimer()
    }
    
    @objc func transitionForOrientationSwitch() {
        quoteLabel.frame = getQuoteLabelFrame()
        appLabel.frame = getAppLabelFrame()
        self.quoteLabel.center = self.view.center
    }
    
    @objc func toggleTimer() {
        if (changeInterval.isValid) {
            changeInterval.invalidate()
        } else {
            tappedMe()
        }
    }
    
    @objc func settingsChanged() {
        useTimer = UserDefaults.standard.bool(forKey: "TIMER_PREF")
        if (!useTimer) {
            changeInterval.invalidate()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        if (useTimer) {
            changeInterval = Timer.scheduledTimer(
                timeInterval: 10.0,
                target: self,
                selector: #selector(ViewController.tappedMe),
                userInfo: nil,
                repeats: false)
        }
    }
    
    func generateNewImageQuote(currentImageQuote: ImageQuoteModel) -> ImageQuoteModel {
        let quoteRand = Int(arc4random_uniform(UInt32(DataStore.quotes.count)))
        let imageRand = Int(arc4random_uniform(UInt32(DataStore.images.count)))
        let newImage = UIImage(named: DataStore.images[imageRand])
        let newQuote = DataStore.quotes[quoteRand]
        
        if (currentImageQuote.image == newImage || currentImageQuote.quote == newQuote) {
            return generateNewImageQuote(currentImageQuote: currentImageQuote)
        }
        
        // TODO: come back and enforce default image
        return ImageQuoteModel(image: newImage!, quote: newQuote)
    }
    
    func getAppLabelFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: UIScreen.main.bounds.width - 120, y: UIScreen.main.bounds.height - 40), size: CGSize(width: 100, height: 20))
    }
    
    func getQuoteLabelFrame() -> CGRect {
        return CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 50))
    }
}
