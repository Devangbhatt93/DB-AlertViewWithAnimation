//
//  ViewController.swift
//  AlertControllerWithAnimation
//
//  Created by macbook on 2/20/17.
//  Copyright © 2017 SolutionAnalysts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAlertController() {
        
        let alertController = UIAlertController(title: "", message: "Alert", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: { Void in
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: {
                            self.view.transform = CGAffineTransform.identity
            },
                           completion: { Void in()  }
            )
            
        })
        
    }
    
    ///Mark:- Action Button To Show Alert Controller
    @IBAction func btnShowAlertTapped(_ sender: UIButton) {
        
        showAlertController()
    }
}

