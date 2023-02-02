//
//  SameSecendViews.swift
//  SameCard
//
//  Created by  on 2020/3/3.
//

import UIKit

class SameSecendViews: NSObject {

    @IBOutlet weak var mButton0: UIButton!
    @IBOutlet weak var mButton1: UIButton!
    @IBOutlet weak var mButton2: UIButton!
    @IBOutlet weak var mButton3: UIButton!
    @IBOutlet weak var mButton4: UIButton!
    @IBOutlet weak var mButton5: UIButton!
    @IBOutlet weak var mButton6: UIButton!
    @IBOutlet weak var mButton7: UIButton!
    @IBOutlet weak var mButton8: UIButton!
    @IBOutlet weak var mButton9: UIButton!
    @IBOutlet weak var mButton10: UIButton!
    @IBOutlet weak var mButton11: UIButton!
    @IBOutlet weak var mButton12: UIButton!
    @IBOutlet weak var mButton13: UIButton!
    @IBOutlet weak var mButton14: UIButton!
    @IBOutlet weak var mButton15: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maskView: UIView!
    
    var cardRandomNum: [String] = ["cat0", "cat0", "cat1", "cat1", "cat2", "cat2", "cat3", "cat3", "cat4", "cat4", "cat5", "cat5", "cat6", "cat6", "cat7", "cat7"]
    var btnArray: [UIButton] = []
    var mTimer: Timer?
    var mTimes: Int = 0
    var isOpenCard: Bool = false
    var previousNum: Int = 0
}
