//
//  MyPlansViewController.swift
//  Fitness eBook Marketplace
//
//  Created by Alek Matthiessen on 1/11/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore

var myplanids = [String]()
var myplanimages = [String:UIImage]()
var mytitles = [String:String]()
var mylinks = [String:String]()
var myauthor = [String:String]()
var mytimes = [String:String]()
var uid = String()

class MyPlansViewController: UIViewController, UITableViewDataSource, UITableViewDelegate    {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myplanimages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        if let url = NSURL(string: mylinks[myplanids[indexPath.row]]!
            ) {
            UIApplication.shared.openURL(url as URL)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Posts", for: indexPath) as! PostsTableViewCell
        
        
        cell.name.text = "\(myauthor[myplanids[indexPath.row]]!) is loving"
        cell.titlelabel.text = mytitles[myplanids[indexPath.row]]
        cell.time.text = mytimes[myplanids[indexPath.row]]
        cell.pic.image = myplanimages[myplanids[indexPath.row]]
        cell.pic.layer.cornerRadius = cell.pic.frame.height/2
        cell.pic.clipsToBounds = true
        cell.selectionStyle = .none

        return cell
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapNext(_ sender: AnyObject?) {
        
        //        threebuttonuntapped()
        
        //        quotetext.slideInFromRight()
        
        
      
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    
    @IBOutlet weak var errorlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if Auth.auth().currentUser == nil {
            
            errorlabel.alpha = 1
            
        } else {
        
            
        queryforids { () -> () in
            
            self.queryforreviewinfo()
            
        }
        
        }
        // Do any additional setup after loading the view.
    }
    
    func queryforinfo() {
        
        var functioncounter = 0
        
        ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var purchased = value?["Full Name"] as? String {
                
                thisdamnname = purchased
                
            }
            
            if var profileUrl = value?["ProPic"] as? String {
                // Create a storage reference from the URL
                
                let url = URL(string: profileUrl)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                var selectedimage = UIImage(data: data!)!
                thisdamnphotourl = profileUrl
                thisdamnphoto = selectedimage
                
                
            }
            
        })
    }
    
    func queryforids(completed: @escaping (() -> ()) ) {
        
        
        var functioncounter = 0
        
        myplanids.removeAll()
        mytimes.removeAll()
        myplanimages.removeAll()
        mylinks.removeAll()
        myauthor.removeAll()
        mytitles.removeAll()
        tableView.reloadData()
        ref?.child("All Posts").queryOrdered(byChild: "Full Name").queryEqual(toValue: thisdamnname).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                    
                    myplanids.append(ids)
                    
                    functioncounter += 1
                    if functioncounter == snapDict.count {
                        
                        
                        completed()
                        
                    }

                }
                
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
            if editingStyle == .delete {
    
                ref?.child("All Posts").child(myplanids[indexPath.row]).removeValue()
    
                queryforids { () -> () in
                    
                    self.queryforreviewinfo()
                    
                }
            }
        }
    
    func queryforreviewinfo() {
        
        var functioncounter = 0
        
        for each in myplanids {
            
            
            ref?.child("All Posts").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                
                
                if var author2 = value?["Full Name"] as? String {
                    myauthor[each] = author2
                    
                }
                
                if var author2 = value?["Time"] as? String {
                    
                    let isoDate = "2016-04-14T10:44:00+0000"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                    let date = dateFormatter.date(from: author2)!
                    
                    mytimes[each] = date.timeAgoSinceDate()
                }
                
                if var author2 = value?["Product Title"] as? String {
                    mytitles[each] = author2
                    
                }
                
                if var author2 = value?["Product Links"] as? String {
                    mylinks[each] = author2
                    
                }
                
                
                if var profileUrl = value?["Image"] as? String {
                    // Create a storage reference from the URL
                    
                    let url = URL(string: profileUrl)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    var selectedimage = UIImage(data: data!)!
                    
                    myplanimages[each] = selectedimage
                    
                    functioncounter += 1
                    
                }
                
                        
                if functioncounter == myplanids.count {
                    
                    self.tableView.reloadData()
                    
                }
                
            })
            
        }
        
    }
    
}
