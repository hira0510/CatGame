//
//  ShowCompleteToastView.swift
//
//  Created by  on 2020/2/21.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class ShowCompleteToastView: UIView {

    @IBOutlet var views: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var scoreLable: UILabel!
    
    var mScore: Int = 0
    var mTime: String = ""
    var didClickDismissBtnHandler: (() -> Void)? = { }
    var didClickCarryOnBtnHandler: (() -> Void)? = { }
    
    init(frame: CGRect, score: Int, time: String) {
        super.init(frame: frame)
        self.mScore = score
        self.mTime = time
        subviewInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        subviewInit()
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.removeSelf()
            if sender.tag == 0 {
                self.didClickCarryOnBtnHandler?()
            } else {
                self.didClickDismissBtnHandler?()
            }
        }
    }
    
    private func subviewInit() {
        Bundle.main.loadNibNamed("ShowCompleteToastView", owner: self, options: nil)
        self.addSubview(views)

        views.translatesAutoresizingMaskIntoConstraints = false
        views.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        views.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        views.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        views.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        insideView.layer.cornerRadius = 10
        if mTime == "" {
            scoreLable.text = "点数：\(mScore)点"
        } else {
            scoreLable.text = "时间：\(mTime)s"
        }
    }

    ///移除自己
    private func removeSelf() {
        UIView.animate(withDuration: 0.5, animations: {
            self.views.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
