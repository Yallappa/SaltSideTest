//
//  SSRootItemsListVC.swift
//  SaltSideAssignment
//
//  Created by Yallappa Kuntennavar on 17/10/15.
//  Copyright © 2015 Yallappa. All rights reserved.
//

import UIKit

class SSRootItemsListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var fetchingItems = false
    
    var itemsArray: Array<SSItemModel>? = nil
    var imageDownloadsInProgress: Dictionary<String, SSImageDownloader> = [:]
    
    // MARK: - View Heirarchy
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Home"
        
        fetchItems()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor(red: 241.0/255, green: 148.0/255, blue: 0.0/255, alpha: 1.0)
        refreshControl.addTarget(self, action: "fetchItems", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    func updateUI() {
        tableView.reloadData()
    }
    
    
    // MARK: - Fetch Items
    
    func fetchItems() {
        if fetchingItems {
            return
        }
        
        self.fetchingItems = true
        activityIndicator.startAnimating()
        SSWebServicesManager.sharedInstance.fetchItems {
            (operationObject, result) -> () in
            
            self.fetchingItems = false
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.itemsArray = result
            
            if let error = operationObject.error {
                SSUtility.showAlertWithTitle("Error!", alertMessage: error.localizedDescription, dismissButtonsTitle: "OK", inController: self)
                
            }else {
                if self.itemsArray?.count > 0 {
                    self.updateUI()
                    
                }else {
                    SSUtility.showAlertWithTitle("", alertMessage: "No items to show at this time. Please try again later.", dismissButtonsTitle: "OK", inController: self)
                }
            }
        }
    }
    
    
    // MARK: - UITableViewDatasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if let items =  itemsArray {
            count = items.count
        }
        
        return count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SSRootItemTableViewCell") as? SSRootItemTableViewCell
        
        let itemObject = itemsArray![indexPath.row]
        cell?.titleLabel.text = itemObject.title
        
        cell!.itemImageView.image = nil
        if (itemObject.image != nil) {
            cell!.itemImageView.image = itemObject.image
        }
        else {
            startImageDownloadFor(indexPath)
        }
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight: CGFloat = 80.0
        
        let itemObject = itemsArray![indexPath.row]
        let sizeConstriant = CGSizeMake((tableView.bounds.width - 98.0), CGFloat.infinity)
        let cellFont = UIFont.systemFontOfSize(14.0)
        
        let heightOfString = SSUtility.stringSize(itemObject.title!, withSizeConstraint: sizeConstriant, andFont: cellFont).height + 12.0
        if (heightOfString > cellHeight) {
            cellHeight = heightOfString
        }
        
        return cellHeight
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemModel = itemsArray![indexPath.row]
        let itemDetailsVC = storyboard?.instantiateViewControllerWithIdentifier("SSItemDetailsVC") as? SSItemDetailsVC
        itemDetailsVC!.itemModel = itemModel
        
        navigationController?.pushViewController(itemDetailsVC!, animated: true)
    }
    
    
    // MARK: - Download thumb images of products
    
    func startImageDownloadFor(indexPath: NSIndexPath) {
        let itemObject = itemsArray![indexPath.row]

        let imageLink = itemObject.imageLink
        var imageDownloader = imageDownloadsInProgress[imageLink!]
        
        if (imageDownloader == nil) {
            imageDownloader = SSImageDownloader()
            imageDownloader?.imageModel = itemObject
            
            imageDownloadsInProgress[itemObject.imageLink!] = imageDownloader
            weak var weakSelf = self
            
            imageDownloader?.startDownload({ () -> () in
                if let weakerMe = weakSelf {
                    if let tableCell = weakerMe.tableView.cellForRowAtIndexPath(indexPath) as? SSRootItemTableViewCell {
                        tableCell.itemImageView.alpha = 0.0
                        tableCell.itemImageView.image = itemObject.image
                        
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            tableCell.itemImageView.alpha = 1.0
                        })
                    }
                    
                    self.imageDownloadsInProgress[itemObject.imageLink!] = nil
                }
            })
        }
    }
    
    
    // MARK: - Cleanup
    
    func cleanUp() {
        for (_, imageDownloader) in imageDownloadsInProgress {
            imageDownloader.stopDownload()
        }
        imageDownloadsInProgress.removeAll(keepCapacity: false)
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        cleanUp()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
