//
//  ViewController.swift
//  Debug App
//
//  Created by Priyank on 18/05/16.
//  Copyright © 2016 com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let appList = [AppModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let searchString = "https://itunes.apple.com/search?term=fifa&entity=software,iPadSoftware,macSoftware"
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: searchString)!), queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error == nil) {
                do {
                    let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary as NSDictionary!
                    let arr = anyObj["results"] as! NSArray
                    for (index,gameDict) in arr.enumerate() {
                        let model = AppModel()
                        model.name = gameDict["trackCensoredName"] as! String

                        if (index < 10) {
                            model.url = gameDict["artworkUrl512"] as? String                            
                        }
                        self.appList.append(model)

                    }
                    self.tableView.reloadData()
                    
                } catch {
                    print("json error: \(error)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: TABLEVIEW METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        cell!.textLabel?.text = appList[indexPath.row].name
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? ShowImageViewController {
              let indexPath = self.tableView.indexPathForSelectedRow
            destinationVC.imageURL = appList[indexPath!.row].url
        }
        
       
    }

}

