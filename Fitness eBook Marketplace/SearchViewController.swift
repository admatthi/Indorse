//
//  SearchViewController.swift
//  Fitness eBook Marketplace
//
//  Created by Alek Matthiessen on 1/25/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        
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
                    
                    self.tableView.reloadData()
                    
                }
                
            })
            
        }
        
    }
    
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
        
        
        
        var normalText = " endorsed"
        
        var boldText  = authors[planids[indexPath.row]]!
        
        var attributedString = NSMutableAttributedString()
        
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 14)!]
        var boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        
        attributedString.append(boldString)
        attributedString.append(NSMutableAttributedString(string:normalText))
        
        cell.name.attributedText = attributedString
        cell.titlelabel.text = products[planids[indexPath.row]]
        cell.time.text = times[planids[indexPath.row]]!.replacingOccurrences(of: " ", with: "")
        cell.pic.image = images[planids[indexPath.row]]
        cell.pic.layer.cornerRadius = cell.pic.frame.height/2
        cell.pic.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
        
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
