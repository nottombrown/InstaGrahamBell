//
//  PhotoDetailViewController.swift
//  InstaGrahamBell
//
//  Created by Tom Brown on 2/3/16.
//  Copyright © 2016 TomLee. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var photo: NSDictionary?
    @IBOutlet weak var photoView: UIImageView!
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.setImageWithURL(url!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
