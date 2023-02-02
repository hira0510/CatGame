//
//  AppearSameView.swift
//  SameCard
//
//  Created by  on 2020/3/3.
//

import UIKit

class AppearSameView: UIView {

    @IBOutlet var views: UIView!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var bestRecord: UILabel!
    
    var clickDismissBtn: (() -> Void)? = { }
    var clickCarryOnBtn: (() -> Void)? = { }
    
    init(frame: CGRect, time: String) {
        super.init(frame: frame)
        setInit()
        timeLable.text = "花費時間：\n\(time)s"
        bestRecord.text = "最佳紀錄：\(UserDefaults.standard.integer(forKey: "bestTime"))s"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInit()
    }
    @IBAction func clickBtn(_ sender: UIButton) {
        if sender.tag == 0 {
            self.removeFromSuperview()
            clickCarryOnBtn?()
        } else {
            clickDismissBtn?()
        }
    }
    
    private func setInit() {
        Bundle.main.loadNibNamed("AppearSameView", owner: self, options: nil)
        self.addSubview(views)
        views.translatesAutoresizingMaskIntoConstraints = false
        views.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        views.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        views.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        views.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
