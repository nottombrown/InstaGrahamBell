//
//  ViewController.swift
//  InstaGrahamBell
//
//  Created by Tom Brown on 2/3/16.
//  Copyright © 2016 TomLee. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var photos: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        tableView.insertSubview(refreshControl, atIndex: 0)

        refreshControl.addTarget(self, action: "networkRequest:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.rowHeight = 320
        
        networkRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
    
    func networkRequest(refreshControl: UIRefreshControl? = nil) {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.photos = responseDictionary["data"] as? [NSDictionary]
                            self.tableView.reloadData()
                            if let refreshControl = refreshControl {
                                refreshControl.endRefreshing()
                            }
                    }
                }
        });
        task.resume()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true) 
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MediaCell") as! MediaCell
        let photo = self.photos![indexPath.row]
        cell.photoView.setImageWithURL(getUrlFromPhoto(photo))
        return cell
    }
    
    func getUrlFromPhoto(photo:NSDictionary) -> NSURL {
        let imageUrl = photo["images"]!["standard_resolution"]!!["url"] as! String
        //        let imageUrl = "http://a4.files.biography.com/image/upload/c_fit,cs_srgb,dpr_1.0,h_1200,q_80,w_1200/MTIwNjA4NjMzNzM5ODM4OTg4.jpg"
        
        return NSURL(string: imageUrl)!

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let detailViewController = segue.destinationViewController as! PhotoDetailViewController
        let photo = photos![indexPath!.row]
        detailViewController.photo = photo
        detailViewController.url = getUrlFromPhoto(photo)
    }

}

