//
//  ViewController.swift
//  AlertControllerWithAnimation
//
//  Created by macbook on 2/20/17.
//  Copyright © 2017 SolutionAnalysts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var overlayView: UIView!
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the animator
        animator = UIDynamicAnimator(referenceView: view)
        
        // Create the dark background view and the alert view
        createOverlay()
        createAlert()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: "", message: "Alert", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: {
            UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {() -> Void in
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {() -> Void in
                    alertController.view.transform = alertController.view.transform.translatedBy(x: alertController.view.frame.origin.x - 10, y: alertController.view.frame.origin.y)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {() -> Void in
                    alertController.view.transform = alertController.view.transform.translatedBy(x: alertController.view.frame.origin.x + 10, y: alertController.view.frame.origin.y)
                })
            }, completion: { _ in
                
                alertController.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    
}

extension ViewController {
    ///Action Button To Show Native Alert Controller
    @IBAction func btnShowAlertTapped(_ sender: UIButton) {
        showAlertController()
    }
    
    ///Action Button To Show Custom Alert Controller
    @IBAction func btnShowCustomAlertTapped(_ sender: UIButton) {
        self.showAlert()
    }
    
    @IBAction func btnPushAnimationTapped(_ sender: UIButton) {
        
        let view = UIView(frame: CGRect(x: self.view.frame.maxX/2, y: 40, width: 100, height: 50))
        self.view.addSubview(view)
        view.backgroundColor = UIColor.blue
        
        let pushAnimatior = UIPushBehavior(items: [view], mode: .continuous)
        pushAnimatior.setAngle(CGFloat(M_PI_2), magnitude: 0.5)
        
        animator.addBehavior(pushAnimatior)
    }
    
    @IBAction func btnCustomAlertTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let rect = CGRect(x: 10, y: 10, width: alertController.view.bounds.size.width - 130 , height: 120)
        let customView = UIView(frame: rect)
        
        customView.backgroundColor = .blue
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: "Something", style: .default, handler: {(alert: UIAlertAction!) in print("something")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
            print("cancel")
        })
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
    }
}


// MARK: - Custom Methods
extension ViewController {
    func createOverlay() {
        // Create a gray view and set its alpha to 0 so it isn't visible
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.gray
        overlayView.alpha = 0.0
        view.addSubview(overlayView)
    }
    
    func createAlert() {
        // Here the red alert view is created. It is created with rounded corners and given a shadow around it
        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 150
        let alertViewFrame: CGRect = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.red
        alertView.alpha = 0.0
        alertView.layer.cornerRadius = 10;
        alertView.layer.shadowColor = UIColor.black.cgColor;
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView.layer.shadowOpacity = 0.3;
        alertView.layer.shadowRadius = 10.0;
        
        // Create a button and set a listener on it for when it is tapped. Then the button is added to the alert view
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: UIControlState())
        button.backgroundColor = UIColor.white
        button.frame = CGRect(x: 0, y: 0, width: alertWidth, height: 40.0)
        
        button.addTarget(self, action: #selector(self.dismissAlert), for: UIControlEvents.touchUpInside)
        
        alertView.addSubview(button)
        view.addSubview(alertView)
    }
    
    func showAlert() {
        // When the alert view is dismissed, I destroy it, so I check for this condition here
        // since if the Show Alert button is tapped again after dismissing, alertView will be nil
        // and so should be created again
        if (alertView == nil) {
            createAlert()
        }
        
        // I create the pan gesture recognizer here and not in ViewDidLoad() to
        // prevent the user moving the alert view on the screen before it is shown.
        // Remember, on load, the alert view is created but invisible to user, so you
        // don't want the user moving it around when they swipe or drag on the screen.
        createGestureRecognizer()
        
        animator.removeAllBehaviors()
        
        // Animate in the overlay
        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 1.0
        })
        
        // Animate the alert view using UIKit Dynamics.
        alertView.alpha = 1.0
        
        let snapBehaviour: UISnapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
        animator.addBehavior(snapBehaviour)
    }
    
    func dismissAlert() {
        
        animator.removeAllBehaviors()
        
        let gravityBehaviour: UIGravityBehavior = UIGravityBehavior(items: [alertView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: 10.0);
        animator.addBehavior(gravityBehaviour)
        
        // This behaviour is included so that the alert view tilts when it falls, otherwise it will go straight down
        let itemBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [alertView])
        itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), for: alertView)
        animator.addBehavior(itemBehaviour)
        
        // Animate out the overlay, remove the alert view from its superview and set it to nil
        // If you don't set it to nil, it keeps falling off the screen and when Show Alert button is
        // tapped again, it will snap into view from below. It won't have the location settings we defined in createAlert()
        // And the more it 'falls' off the screen, the longer it takes to come back into view, so when the Show Alert button
        // is tapped again after a considerable time passes, the app seems unresponsive for a bit of time as the alert view
        // comes back up to the screen
        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 0.0
        }, completion: {
            (value: Bool) in
            self.alertView.removeFromSuperview()
            self.alertView = nil
        })
        
    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    func handlePan(_ sender: UIPanGestureRecognizer) {
        
        if (alertView != nil) {
            let panLocationInView = sender.location(in: view)
            let panLocationInAlertView = sender.location(in: alertView)
            
            if sender.state == UIGestureRecognizerState.began {
                animator.removeAllBehaviors()
                
                let offset = UIOffsetMake(panLocationInAlertView.x - alertView.bounds.midX, panLocationInAlertView.y - alertView.bounds.midY);
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.changed {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == UIGestureRecognizerState.ended {
                animator.removeAllBehaviors()
                
                snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
                animator.addBehavior(snapBehavior)
                
                if sender.translation(in: view).y > 100 {
                    dismissAlert()
                }
            }
        }
        
    }
}
