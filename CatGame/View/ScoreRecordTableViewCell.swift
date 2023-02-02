//
//  ScoreRecordTableViewCell.swift
//  WhacAMole
//
//  Created by  on 2020/2/25.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class ScoreRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var catImg: UIImageView!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static var nib: UINib {
        return UINib(nibName: "ScoreRecordTableViewCell", bundle: nil)
    }
    
    func configCell(score: Int, time: String) {
        if time == "" {
            let img = score / 50
            scoreLable.text = "点数：\(score)"
            catImg.image = UIImage(named: "cat\(img)")
            bgImageView.image = UIImage(named: "gameBG_cat")
        } else {
            scoreLable.text = "时间：\(time)s"
            catImg.image = UIImage(named: "cat0")
            bgImageView.image = UIImage(named: "bg_cat")
        }
        
    }
}
