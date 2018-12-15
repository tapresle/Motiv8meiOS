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
    
    let imageArray = ["Ocean", "bridge", "city", "fence", "road", "sunset", "trail", "train", "newyork", "rails", "river", "valley", "waves", "paris", "rocky", "dock", "nyc", "mountriver", "stars"]
    let quoteArray = ["Life isn\'t about getting and having, it\'s about giving and being", "You can never cross the ocean until you have the courage to lose sight of the shore", "Your time is limited, so don\'t waste it living someone else\'s life.", "Time is the most valuable thing you can spend", "Smiling is the best way to start your day", "Time spent laughing is time well spent", "Mistakes are proof you are trying", "Every accomplishment starts with the decision to try", "The longest journey always begins with one, simple step", "Time flies, but you are the pilot", "Don\'t always look backwards or you will miss your future", "When was the last time you did something for the first time?", "Every dawn brings new hope, every dusk should bring satisfaction", "Don\'t count the minutes of the day. Make the minutes of the day count.", "Stand up and say, \"I will be great today!\"", "The time is always right to do the right thing now", "The only thing we all have in common is the same hours in a day", "Sometimes good things fall apart so better things can fall together", "Brighten someone else\'s day and it will warm your soul", "By small and simple things are great things brought to pass", "Today is a new day", "Be glad life doesn\'t come with an instruction manual", "It is way more fun to wing it than to follow directions", "Your life should not be a game of follow the leader, pave your own path", "Your days are as fun as you make them", "Life goes on so keep on keeping on!", "Smile. You\'re beautiful", "Don\'t fall back on what\'s behind you, spring forward to what\'s ahead", "Do one thing every day that will make someone smile", "Dreams bloom best in a well tended garden", "When life gives you lemons ask, \"Is that ALL you\'ve got?\"", "When it\'s cloudy remember, the sun is always shining somewhere", "Life is a party, don\'t forget to bring the cake!", "Learn from yesterday, dream about tomorrow, live in the moment", "Everything happens for a reason, even if it takes time to realize it", "Strive not to be a success, but rather to be of value", "The only person you are destined to become is the person you decide to be", "Believe you can and you’re halfway there", "Life is not measured by the number of breaths we take, but by the moments that take our breath away", "Happiness is not something readymade. It comes from your own actions", "It is never too late to be what you might have been", "Dream big and dare to fail"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedMe))
        
        appLabel = UILabel()
        appLabel.text = "Motiv8me"
        appLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        appLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        appLabel.frame = CGRect(origin: CGPoint(x: 30, y: UIScreen.main.bounds.height - 30),
                                size: CGSize(width: 200, height: 100))
        appLabel.sizeToFit()
        self.view.addSubview(appLabel)
        
        
        // Setup image view
        changingImage.addGestureRecognizer(tap)
        changingImage.isUserInteractionEnabled = true
        changingImage.contentMode = .scaleAspectFill
        changingImage.image = UIImage()
        
        // Setup quote label
        quoteLabel = UIOutlinedLabel()
        quoteLabel.textColor = UIColor.white
        quoteLabel.numberOfLines = 10;
        quoteLabel.textAlignment = .center;
        quoteLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 50))
        quoteLabel.font = UIFont(name: "Noteworthy-Bold", size: 40)
        self.view.addSubview(quoteLabel)
        quoteLabel.center = self.view.center
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
                                  duration:1,
                                  options: UIView.AnimationOptions.transitionCrossDissolve,
                                  animations: { self.changingImage.image = newImageQuote.image;
                                    self.quoteLabel.text = newImageQuote.quote;
                                    self.quoteLabel.center = self.view.center },
                                  completion: nil)
        changeInterval.invalidate()
        startTimer()
    }
    
    func startTimer() {
        changeInterval = Timer.scheduledTimer(
            timeInterval: 10.0,
            target: self,
            selector: #selector(ViewController.tappedMe),
            userInfo: nil,
            repeats: false)
    }
    
    func generateNewImageQuote(currentImageQuote: ImageQuoteModel) -> ImageQuoteModel {
        let quoteRand = Int(arc4random_uniform(UInt32(quoteArray.count)))
        let imageRand = Int(arc4random_uniform(UInt32(imageArray.count)))
        let newImage = UIImage(named: imageArray[imageRand])
        let newQuote = quoteArray[quoteRand]
        
        if (currentImageQuote.image == newImage || currentImageQuote.quote == newQuote) {
            return generateNewImageQuote(currentImageQuote: currentImageQuote)
        }
        
        // TODO: come back and enforce default image
        return ImageQuoteModel(image: newImage!, quote: newQuote)
    }
}
