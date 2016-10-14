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
    func needsShareProduct(_ product: Product)
    func needsDeleteProduct(_ product: Product)
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
    
    @IBAction func buttonDeletePressed(_ sender: AnyObject) {
        delegate?.needsDeleteProduct(product)
    }
    
    @IBAction func buttonSharePressed(_ sender: AnyObject) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func buttonAboutPressed(_ sender: AnyObject) {
        let vc = R.storyboard.me.settings()!
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }
}

extension MeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        cell.product = productList[(indexPath as NSIndexPath).row]
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension MeViewController: ProductCellDelegate {
    
    func needsShareProduct(_ product: Product) {
        print("share")
        Share.shareAsVideo(product, inViewController: self)
    }
    
    func needsDeleteProduct(_ product: Product) {
        let alertController = UIAlertController(title: "Delete?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
            self?.deleteProduct(product)
        }
        let no = UIAlertAction(title: "No", style: .cancel) { action in }
        alertController.addAction(yes)
        alertController.addAction(no)
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteProduct(_ product: Product) {
        guard let index = productList.index(of: product) else {
            return
        }
        productService.deleteProduct(product)
        productList.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section:0)], with: .automatic)
    }

}

