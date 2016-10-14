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

class BroadcastViewController: UIViewController {
    
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

        guest?.onDisConnected = { [weak self] in
            self?.showEmptyView()
        }
        guest?.onPeersUpdates = { [weak self] index, totalCount in
            self?.updatePeersInfo(index, totalCount: totalCount)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showConnecting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guest?.startAdvertising()
        guest?.sendReadySignal()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
    
    
    func updatePeersInfo(_ index: Int, totalCount: Int) {
        self.totalCount = totalCount
        self.index = index
        circleView.reloadData()
        statusLabel.text = "Your position is \(index + 1)"
    }

    
    @IBAction func buttonNextPressed(_ sender: AnyObject) {
        push(R.storyboard.shoot.peripheral()!)
    }

    @IBAction func back(_ sender: AnyObject) {
        pop()
    }
    
}

extension BroadcastViewController: LTCircleViewDataSource {
    
    func numberOfItemsInCircleView(_ circleView: LTCircleView) -> Int {
        return totalCount
    }
    
    func viewAtIndex(_ index: Int, inCircleView circleView: LTCircleView) -> UIView {
        let bubble = BubbleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        bubble.color = UIColor.steppedColor(fromHex: BubbleView.startColorHex, endHex: BubbleView.endColorHex, totalCount: totalCount, index: index)
        bubble.text = "\(index + 1)"
        if (index == self.index) {
            bubble.showHalo()
        }
        return bubble
    }
}

extension BroadcastViewController: AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return [mainView, buttonNext]
    }

}
