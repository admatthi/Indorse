//
//  PostViewController.swift
//  Fitness eBook Marketplace
//
//  Created by Alek Matthiessen on 1/16/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManager
import SwiftLinkPreview

var thisdamnphoto = UIImage()
var thisdamnid = String()
var thisdamnname = String()
var thisdamnphotourl = String()

class PostViewController: UIViewController, UITextViewDelegate {
    
    var thisdamndate = String()
    var damnurl = String()
    var damntitle = String()

    let slp = SwiftLinkPreview()
    
    typealias JSONDictionary = [String:Any]

    @IBAction func tapShare(_ sender: Any) {
        if tv.text != "" {
            
      
            slp.preview(
                tv.text!,
                onSuccess: { result in
                    print("\(result)")

//                    var results: <# Type #> = result.values as? [JSONDictionary] {
//                        for result in results! {
//                            if let geometry = result["image"] as? String {
//
//                                print("fuck yeah")
//
//                                }
//
//                            }
//                        }
                    
//                    if var author2 = value!["SwiftLinkPreview.SwiftLinkResponseKey.url"] as? String {
//
//                        print("Fuck yeah")
//
//                    }
            },
                onError: { error in
                    print("\(error)")
            }
            )
            
            
//            let textFieldText = tv?.text ?? String()
//
//            if let url = self.slp.extractURL(text: textFieldText),
//                let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString) {
//                
//                //            self.result = cached
//
////                            printResult(result)
//
//            } else {
//                self.slp.preview(
//                    textFieldText,
//                    onSuccess: { result in
//
//                        //                    printResult(result)
//
//                        //                    self.result = result
//
////                        printResult(result)
////
//                        var value = result.values as? NSDictionary
//
//
//
//                        if var author2 = value?.description {
//
//                            print("fuck yeah")
////                            authors[each] = author2
//
//                        }
//
//                        if var author2 = self.result.image {
//
//                            let url = URL(string: author2)
//                            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                            var selectedimage = UIImage(data: data!)!
//                            self.previewImage.image = selectedimage
//                        }
////                        result["finalUrl"]
////                        var result = Response()
////                        result2 = result
//
//
////                        if let value = result.image {
////                                                            // Create a storage reference from the URL
////
////
////
////
////                            }
////
//
//                            //                        previewImage.image = self.result.image
//
//
//                        if let value: String = self.result.title {
//
//                            self.previewTitle?.text = value.isEmpty ? "No title" : value
//
//                        } else {
//
//                            //            self.previewTitle?.text = "No title"
//
//                        }
//
//                        if let value: String = self.result.canonicalUrl {
//
//                            self.previewurl?.text = value
//
//                        }
//                },
//                    onError: { error in
//
//                        print(error)
//
//                }
//                )
//            }
//
            
        }
//        if tv.text != "" {
//
//            let text = tv.text!
//            let types: NSTextCheckingResult.CheckingType = .link
//
//            do {
//                let detector = try NSDataDetector(types: types.rawValue)
//                let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.characters.count))
//                if matches.count > 0 {
//                    let durl = matches[0].url!
//                    damnurl = durl.absoluteString
//
//
//                    var token = text.components(separatedBy: damnurl)
//
//                   damntitle = token[0]
//
//
//
//                }
//
//            } catch {
//                // none found or some other issue
//                print ("error in findAndOpenURL detector")
//            }
//
//            let isoDate = "2016-04-14T10:44:00+0000"
//
//            let date = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            let thisdamndate = dateFormatter.string(from: date)
//
//            ref!.child("All Posts").childByAutoId().updateChildValues(   ["Full Name" : thisdamnname, "Image" : thisdamnphotourl, "Product Title" : damntitle, "Product Links" : damnurl, "Time" : thisdamndate])
//
//
//            self.performSegue(withIdentifier: "PostToDiscover", sender: self)
//        }
    }
    
    @IBOutlet weak var propic: UIImageView!
    @IBOutlet weak var tv: UITextView!
//    private let slp = SwiftLinkPreview(cache: InMemoryCache())

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        

        
        return true
    }
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var previewurl: UILabel!
    
    @IBOutlet weak var previewTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tv.delegate = self
        propic.image = thisdamnphoto

        queryforinfo()
        propic.layer.cornerRadius = propic.frame.height/2
        propic.clipsToBounds = true
        tv.layer.cornerRadius = 2.0
        tv.layer.masksToBounds = true
        tv.text = "What are you endorsing?"
        tv.textColor = UIColor.lightGray
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
                self.propic.image = thisdamnphoto

                
            }
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What are you endorsing?"
            textView.textColor = UIColor.lightGray
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
//    struct Response {
//
//        public internal(set) var url: URL?
//        public internal(set) var finalUrl: URL?
//        public internal(set) var canonicalUrl: String?
//        public internal(set) var title: String?
//        public internal(set) var description: String?
//        public internal(set) var images: [String]?
//        public internal(set) var image: String?
//        public internal(set) var icon: String?
//        public internal(set) var video: String?
//    }
}

//
//public struct Response: Decodable {
//
//    public internal(set) var url: URL?
//    public internal(set) var finalUrl: URL?
//    public internal(set) var canonicalUrl: String?
//    public internal(set) var title: String?
//    public internal(set) var description: String?
//    public internal(set) var images: [String]?
//    public internal(set) var image: String?
//    public internal(set) var icon: String?
//    public internal(set) var video: String?
//
//    public init() { }
//
//}
//public enum SwiftLinkResponseKey: String {
//    case url
//    case finalUrl
//    case canonicalUrl
//    case title
//    case description
//    case image
//    case images
//    case icon
//    case video
//}
