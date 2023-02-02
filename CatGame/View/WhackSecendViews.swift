//
//  WhackSecendViews.swift
//  WhacAMole
//
//  Created by  on 2020/2/25.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class WhackSecendViews: NSObject {

    @IBOutlet weak var mImage0: UIImageView!
    @IBOutlet weak var mImage1: UIImageView!
    @IBOutlet weak var mImage2: UIImageView!
    @IBOutlet weak var mImage3: UIImageView!
    @IBOutlet weak var mImage4: UIImageView!
    @IBOutlet weak var mImage5: UIImageView!
    @IBOutlet weak var mImage6: UIImageView!
    @IBOutlet weak var mImage7: UIImageView!
    @IBOutlet weak var mImage8: UIImageView!
    @IBOutlet weak var mImage9: UIImageView!
    @IBOutlet weak var mImage10: UIImageView!
    @IBOutlet weak var mImage11: UIImageView!
    @IBOutlet weak var mImage12: UIImageView!
    @IBOutlet weak var mImage13: UIImageView!
    @IBOutlet weak var mImage14: UIImageView!
    @IBOutlet weak var mImage15: UIImageView!
    @IBOutlet weak var mImage16: UIImageView!
    @IBOutlet weak var mImage17: UIImageView!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var mButton0: UIButton!
    @IBOutlet weak var mButton1: UIButton!
    @IBOutlet weak var mButton2: UIButton!
    
    var btnArray: [UIButton] = []
    var imgArray0: [UIImageView] = []
    var imgArray1: [UIImageView] = []
    var imgArray2: [UIImageView] = []
    var imgArray3: [UIImageView] = []
    var imgArray4: [UIImageView] = []
    var imgArray5: [UIImageView] = []
    var whichImage: [Int] = []
    var whichRow: Int = 0
    var mScore: Int = 0
    var mTimer: Timer?
    var mScore2: [Int] = UserDefaults.standard.array(forKey: "scores") as? [Int] ?? []
}
