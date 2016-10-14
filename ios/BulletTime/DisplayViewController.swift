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
            view.isUserInteractionEnabled = true
            product = productService.createProduct(withImages: images)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func back(_ sender: AnyObject) {
        pop()
    }

    
    @IBAction func buttonSavePressed(_ sender: AnyObject) {
        Share.shareAsVideo(product, inViewController: self)
    }
    
}

extension DisplayViewController: AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return view.subviews
    }
}
