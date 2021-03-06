//
//  SignInViewController.swift
//  Fitness eBook Marketplace
//
//  Created by Alek Matthiessen on 1/11/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FBSDKCoreKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBAction func tapBack(_ sender: Any) {
        
//        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapSignIn(_ sender: Any) {
        
        login()
    }
    
    func login() {
        
        var email = "\(emailtf.text!)"
        var password = "\(passwordtf.text!)"
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                
                
                self.errorlabel.alpha = 1
                self.errorlabel.text = error.localizedDescription
                
                
                
                return
                
            } else {
                
                uid = (Auth.auth().currentUser?.uid)!
                
                let date = Date()
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yy"
                var todaysdate =  dateFormatter.string(from: date)
                
                self.performSegue(withIdentifier: "SigninToExplore", sender: self)
                
                
            }
            
        }
        
    }
    

    
    @IBOutlet weak var header: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    @IBOutlet weak var errorlabel: UILabel!
    @IBOutlet weak var passwordtf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.addCharacterSpacing()
        // Do any additional setup after loading the view.
        
        
        
        //        emailtf.layer.borderColor = UIColor.gray.cgColor
        //        emailtf.layer.borderWidth = 0.5
        //        passwordtf.layer.borderColor = UIColor.gray.cgColor
        //        passwordtf.layer.borderWidth = 0.5
        //
        ref = Database.database().reference()
        
        emailtf.delegate = self
        passwordtf.delegate = self
        emailtf.becomeFirstResponder()
        //        tapcreate.layer.cornerRadius = 22.0
        //        tapcreate.layer.masksToBounds = true
        
        errorlabel.alpha = 0
        
        self.addLineToView(view: emailtf, position:.LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.5)
        
        self.addLineToView(view: passwordtf, position:.LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.5)
        
        
        
    }
    
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }
    
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }

        // Do any additional setup after loading the view.
}
