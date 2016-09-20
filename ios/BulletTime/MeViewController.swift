//
//  MeViewController.swift
//  BulletTime
//
//  Created by leo on 16/8/17.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit
import LTSwiftDate

protocol ProductCellDelegate: class {
    func needsShareProduct(product: Product)
    func needsDeleteProduct(product: Product)
}

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: ProductCellDelegate?
    
    var product: Product! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        playerView.reload(withImages: product.images)
        dateLabel.text = product.timeCreated.toString(format: "MMM d, yyyy")
    }
    
    @IBAction func buttonDeletePressed(sender: AnyObject) {
        delegate?.needsDeleteProduct(product)
    }
    
    @IBAction func buttonSharePressed(sender: AnyObject) {
        delegate?.needsShareProduct(product)
    }
}



class MeViewController: HomeChildViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var productList: [Product] = []
    let productService = ProductService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func refresh() {
        productList = productService.loadAll()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func buttonAboutPressed(sender: AnyObject) {
        let vc = R.storyboard.me.settings()!
        vc.modalTransitionStyle = .FlipHorizontal
        presentViewController(vc, animated: true, completion: nil)
    }
}

extension MeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProductCell
        cell.product = productList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

extension MeViewController: ProductCellDelegate {
    
    func needsShareProduct(product: Product) {
        print("share")
        Share.shareAsVideo(product, inViewController: self)
    }
    
    func needsDeleteProduct(product: Product) {
        let alertController = UIAlertController(title: "Delete?", message: nil, preferredStyle: .Alert)
        let yes = UIAlertAction(title: "Yes", style: .Destructive) { [weak self] action in
            self?.deleteProduct(product)
        }
        let no = UIAlertAction(title: "No", style: .Cancel) { action in }
        alertController.addAction(yes)
        alertController.addAction(no)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteProduct(product: Product) {
        guard let index = productList.indexOf(product) else {
            return
        }
        productService.deleteProduct(product)
        productList.removeAtIndex(index)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection:0)], withRowAnimation: .Automatic)
    }

}

