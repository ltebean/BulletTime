//
//  BroadcastViewController.swift
//  BulletTime
//
//  Created by ltebean on 8/13/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SwiftyJSON

class BroadcastViewController: AnimatableViewController {
    
    let guest = Guest.current
    var totalCount = 0
    var index = 0
    
    @IBOutlet weak var circleView: LTCircleView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.dataSource = self

        guest.onDisConnected = { [weak self] in
            self?.showEmptyView()
        }
        guest.onPeersUpdates = { [weak self] index, totalCount in
            self?.updatePeersInfo(index, totalCount: totalCount)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showConnecting()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guest.startAdvertising()
        guest.sendReadySignal()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func showConnecting() {
        totalCount = 0
        circleView.reloadData()
        statusLabel.text = "Connecting..."
    }
    
    func showEmptyView() {
        totalCount = 0
        circleView.reloadData()
        statusLabel.text = "Disconnected"
    }
    
    
    func updatePeersInfo(index: Int, totalCount: Int) {
        self.totalCount = totalCount
        self.index = index
        circleView.reloadData()
        statusLabel.text = "Your position is \(index + 1)"
    }

    
    @IBAction func buttonNextPressed(sender: AnyObject) {
        push(R.storyboard.shoot.peripheral()!)
    }

    @IBAction func back(sender: AnyObject) {
        pop()
    }
    
    override func viewsToAnimate() -> [UIView] {
        return [mainView, buttonNext]
    }
}

extension BroadcastViewController: LTCircleViewDataSource {
    
    func numberOfItemsInCircleView(circleView: LTCircleView) -> Int {
        return totalCount
    }
    
    func viewAtIndex(index: Int, inCircleView circleView: LTCircleView) -> UIView {
        let bubble = BubbleView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        bubble.color = UIColor.steppedColor(fromHex: BubbleView.startColorHex, endHex: BubbleView.endColorHex, totalCount: totalCount, index: index)
        bubble.text = "\(index + 1)"
        if (index == self.index) {
            bubble.showHalo()
        }
        return bubble
    }
}
