//
//  CustomCreationViewController.swift
//  Motiv8me
//
//  Created by Ted Presley on 1/1/19.
//  Copyright © 2019 Ted Presley. All rights reserved.
//

import UIKit

class CustomCreationViewController: UIViewController {
  @IBOutlet private var customCreationExit: UIButton!
  
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
}
