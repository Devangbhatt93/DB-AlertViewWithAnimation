//
//  ViewController.swift
//  DisplayName
//
//  Created by macbook on 2/19/17.
//  Copyright © 2017 SolutionAnalysts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lblDisplayName: UILabel!
    @IBOutlet var txtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    /// Submit Button Action
    ///
    /// - Parameter sender: object of UIButton
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        if txtField.text != "" {
            lblDisplayName.isHidden = false
            lblDisplayName.text = txtField.text
        } else {
            lblDisplayName.isHidden = true
            let alertController = UIAlertController(title: "", message: "Please Enter Text", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {Void in
                self.txtField.becomeFirstResponder()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

