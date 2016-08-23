//
//  DisplayViewController.swift
//  BulletTime
//
//  Created by ltebean on 8/12/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import AssetsLibrary

class DisplayViewController: UIViewController {

    @IBOutlet weak var playerView: PlayerView!
    var productService = ProductService.sharedInstance
    var product: Product!
    
    var images: [UIImage] = [] {
        didSet {
            playerView.reload(withImages: images)
            view.userInteractionEnabled = true
            product = productService.createProduct(withImages: images)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.userInteractionEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func buttonSharePressed(sender: AnyObject) {
        Share.shareProduct(product, inViewController: self)
    }
}

extension DisplayViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return nil
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return UIColor.whiteColor()
    }
}
