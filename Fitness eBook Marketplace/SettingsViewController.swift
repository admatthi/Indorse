//
//  SettingsViewController.swift
//  Fitness eBook Marketplace
//
//  Created by Alek Matthiessen on 1/11/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore

class SettingsViewController: UIViewController {

    
    

    @IBOutlet weak var paypal: UILabel!
    
    @IBOutlet weak var payout: UILabel!
    @IBOutlet weak var wlabel: UILabel!
    @IBOutlet weak var tlabel: UILabel!
    @IBOutlet weak var mlabel: UILabel!
    @IBAction func tapLogout(_ sender: Any) {
    
    try! Auth.auth().signOut()
    
    self.performSegue(withIdentifier: "SettingsToOverview", sender: self)
}

    @IBAction func tapLogin(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToLogin", sender: self)
    }


    @IBAction func tapPaypal(_ sender: Any) {
    }
    @IBOutlet weak var changeoradd: UIButton!
    @IBOutlet weak var taplogout: UIButton!
    @IBOutlet weak var taplogin: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        
        queryforinfo()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    
        
        if Auth.auth().currentUser == nil {

            taplogin.alpha = 1
            taplogout.alpha = 0
        } else {
            
            taplogin.alpha = 0
            taplogout.alpha = 1
        }
    }
    
    func queryforinfo() {
        
        var functioncounter = 0
        
        ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var purchased = value?["Monthly"] as? String {
                
                self.mlabel.text = purchased
                
            }
            
            if var purchased = value?["Today"] as? String {
                
                self.tlabel.text = purchased
                
            }
            
            if var purchased = value?["Weekly"] as? String {
                
               self.wlabel.text = purchased
                
            }
            
            if var purchased = value?["Payout"] as? String {
                
                self.payout.text = purchased
                
            }
            
            if var purchased = value?["PayPal"] as? String {
                
                if purchased == "-" {
                    
                    self.changeoradd.setTitle("Add Paypal Address", for: .normal)

                    
                } else {
                    
                    self.changeoradd.setTitle("Change Paypal Address", for: .normal)
                }
                self.paypal.text = purchased
                
            }
            
       
            
        })
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
