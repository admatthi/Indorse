//
//  BrowseViewController.swift
//  Fitness eBook Marketplace
//
//  Created by Alek Matthiessen on 1/11/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

var planids = [String]()
var names = [String:String]()
var products = [String:String]()
var productlinks = [String:String]()
var titles = [String:String]()
var reviews = [String:String]()
var authors = [String:String]()
var images = [String:UIImage]()
var times = [String:String]()

var selectedid = String()
var selectedprice = String()
var selecteddescription = String()
var selectedtitle = String()
var selectedimage = UIImage()
var selectedauthor = String()
var ref: DatabaseReference?
var selectedgenre = String()

class BrowseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var collectionView1: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
//        var screenSize = collectionView.bounds
//        var screenWidth = screenSize.width
//        var screenHeight = screenSize.height
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/1)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//
//        collectionView!.collectionViewLayout = layout
        
//        genres.append("Featured")
//        genres.append("Weight Loss")
//        genres.append("Build Muscle")
//        genres.append("Gain Strength")
//        selectedgenre = genres[0]

        queryforids { () -> () in
            
            self.queryforreviewinfo()
            
        }
        
        if thisdamnname == "" {
            
            queryforinfo()

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
        
        images.removeAll()
        authors.removeAll()
        reviews.removeAll()
        products.removeAll()
        productlinks.removeAll()
        titles.removeAll()
        times.removeAll()
        planids.removeAll()
        
        ref?.child("All Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                
                for each in snapDict {
                    
                    let ids = each.key
                
                    planids.append(ids)
                    
                    functioncounter += 1
                    
                    if functioncounter == snapDict.count {
   
                        
                        completed()
                        
                    }

                    
                    
                }
      
            }
            
        })
        
    }
    
    
    func queryforreviewinfo() {
        
        var functioncounter = 0
        
        for each in planids {
            
            
             ref?.child("All Posts").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                
                
                if var author2 = value?["Full Name"] as? String {
                    authors[each] = author2
                    
                }
                
                if var author2 = value?["Time"] as? String {
                    
                    let isoDate = "2016-04-14T10:44:00+0000"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                    let date = dateFormatter.date(from: author2)!
                    
                        times[each] = date.timeAgoSinceDate()
                }
                
                if var author2 = value?["Product Title"] as? String {
                    products[each] = author2
                    
                }
                
                if var author2 = value?["Product Links"] as? String {
                    productlinks[each] = author2
                    
                }
               
                
                if var profileUrl = value?["Image"] as? String {
                    // Create a storage reference from the URL
                    
                    let url = URL(string: profileUrl)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    var selectedimage = UIImage(data: data!)!
                    
                    images[each] = selectedimage
                    
                    functioncounter += 1
                    
                }
                
                
                if functioncounter == planids.count {
                    
                    self.activityIndicator.alpha = 0
                    self.tableView.reloadData()
                    
                }
                
            })
            
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
    }
    
    var selectedindex = Int()
    var genres = [String]()
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        if let url = NSURL(string: productlinks[planids[indexPath.row]]!
            ) {
            UIApplication.shared.openURL(url as URL)
        }

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Posts", for: indexPath) as! PostsTableViewCell
        
        cell.name.text = "\(authors[planids[indexPath.row]]!) is loving"
        cell.titlelabel.text = products[planids[indexPath.row]]
        cell.time.text = times[planids[indexPath.row]]
        cell.pic.image = images[planids[indexPath.row]]
        cell.pic.layer.cornerRadius = cell.pic.frame.height/2
        cell.pic.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
        
    }
}

extension UILabel {
    func addCharacterSpacing() {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.2, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}


extension Date {
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "y" : "\(interval)" + " " + "y"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "m" : "\(interval)" + " " + "m"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "d" : "\(interval)" + " " + "d"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "h" : "\(interval)" + " " + "h"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "m" : "\(interval)" + " " + "m"
        }
        
        return "25s"
    }
}
