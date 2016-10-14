//
//  PeripheralListViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/30/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SwiftyJSON

class DiscoveriesViewController: UIViewController {

    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var circleView: LTCircleView!
    @IBOutlet weak var mainView: UIView!
    
    let host = Host.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.dataSource = self

        host.onPeerJoin = { [weak self] peer in
            self?.peerJoined(peer)
        }
        host.onPeerLost = { [weak self] peer, index in
            self?.peerLost(peer, atIndex: index)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        circleView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        host.startBrowsing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func peerJoined(_ peer: MCPeerID) {
        circleView.insertItemAtIndex(host.allPeers.count - 1)
    }
    
    func peerLost(_ peer: MCPeerID, atIndex index: Int) {
        circleView.removeItemAtIndex(index)
    }
    
    @IBAction func back(_ sender: AnyObject) {
        pop()
    }

    @IBAction func buttonNextPressed(_ sender: AnyObject) {
        push(R.storyboard.shoot.central()!)
    }
    
    
}


extension DiscoveriesViewController: LTCircleViewDataSource {
    
    func numberOfItemsInCircleView(_ circleView: LTCircleView) -> Int {
        return host.allPeers.count
    }
    
    func viewAtIndex(_ index: Int, inCircleView circleView: LTCircleView) -> UIView {
        let bubble = BubbleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        bubble.text = "\(index + 1)"
        bubble.color = UIColor.steppedColor(fromHex: BubbleView.startColorHex, endHex: BubbleView.endColorHex, totalCount: host.allPeers.count, index: index)
        if (index == 0) {
            bubble.showHalo()
        }
        return bubble
    }
}

extension DiscoveriesViewController: AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return [mainView, buttonNext]
    }
    
}
