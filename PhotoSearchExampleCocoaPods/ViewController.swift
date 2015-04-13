//
//  ViewController.swift
//  PhotoSearchExampleCocoaPods
//
//  Created by Austin Murtha on 4/10/15.
//  Copyright (c) 2015 AustinMurtha. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchInstagramByHashtag("dogs")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchInstagramByHashtag(searchString: String){
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET("https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=c3aa502338a244ab98cfc62cff27fb87", parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            println("JSON: " + responseObject.description)
            if let dataArray = responseObject["data"] as? [AnyObject] {
                var urlArray: [String] = []
                for dataObject in dataArray {
                    if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                        urlArray.append(imageURLString)
                    }
                }
                let imageWidth = self.view.frame.width
                self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                
                for var i = 0; i < urlArray.count; i++ {
                    let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth, imageWidth))
                    imageView.setImageWithURL( NSURL(string: urlArray[i]))
                    self.scrollView.addSubview(imageView)
                    
                }
                
            } },
            
            
            failure: { ( operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Error: " + error.localizedDescription)
                
                
                
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        var searchBarString = searchBar.text
        let searchBarStringNoSpace = searchBarString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        searchBarString = join("", searchBarStringNoSpace)
        println("\(searchBarString) Search Bar Text")
        searchInstagramByHashtag(searchBarString)
        
        
    }
    
//    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        NSLog("2 %@", text)
//        return true
//    }

//let instagramURLString = "https://api.instagram.com/v1/tags/\(searchBar.text)/media/recent?client_id=YOUR_CLIENT_ID"

}

