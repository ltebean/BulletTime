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
    
    let host = Host.current
    
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        circleView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        host.startBrowsing()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func peerJoined(peer: MCPeerID) {
        circleView.insertItemAtIndex(host.allPeers.count - 1)
    }
    
    func peerLost(peer: MCPeerID, atIndex index: Int) {
        circleView.removeItemAtIndex(index)
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func buttonNextPressed(sender: AnyObject) {
        let vc = R.storyboard.shoot.central()!
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension DiscoveriesViewController: LTCircleViewDataSource {
    
    func numberOfItemsInCircleView(circleView: LTCircleView) -> Int {
        return host.allPeers.count
    }
    
    func viewAtIndex(index: Int, inCircleView circleView: LTCircleView) -> UIView {
        let bubble = BubbleView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        bubble.text = "\(index + 1)"
        bubble.color = UIColor.steppedColor(fromHex: BubbleView.startColorHex, endHex: BubbleView.endColorHex, totalCount: host.allPeers.count, index: index)
        if (index == 0) {
            bubble.showHalo()
        }
        return bubble
    }
}

extension DiscoveriesViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return buttonNext
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return nil
    }
}
