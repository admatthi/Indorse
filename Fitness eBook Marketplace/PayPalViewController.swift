//
//  PayPalViewController.swift
//  Fitness eBook Marketplace
//
//  Created by Alek Matthiessen on 1/16/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Firebase
class PayPalViewController: UIViewController, UITextFieldDelegate  {
    
    @IBAction func tapBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var emailtf: UITextField!
    
    @IBAction func tapContinue(_ sender: Any) {
        
        if emailtf.text != "" {
            
            ref!.child("Users").child(uid).updateChildValues(["PayPal" : emailtf.text!])
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
