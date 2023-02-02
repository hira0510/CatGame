//
//  WhackSecendViewController.swift
//  WhacAMole
//
//  Created by  on 2020/2/25.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class WhackSecendViewController: UIViewController {

    @IBOutlet var views: WhackSecendViews!

    private var bgSongPlayer: AVPlayer?
    private var soundEffectsPlayer: AVPlayer?
    private var time321: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    override func viewWillAppear(_ animated: Bool) {
        countDown321()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        time321?.invalidate()
        time321 = nil
        bgSongPlayer = nil
        soundEffectsPlayer = nil
    }

    private func setData() {
        views.imgArray5 = [views.mImage15, views.mImage16, views.mImage17]
        views.imgArray4 = [views.mImage12, views.mImage13, views.mImage14]
        views.imgArray3 = [views.mImage9, views.mImage10, views.mImage11]
        views.imgArray2 = [views.mImage6, views.mImage7, views.mImage8]
        views.imgArray1 = [views.mImage3, views.mImage4, views.mImage5]
        views.imgArray0 = [views.mImage0, views.mImage1, views.mImage2]
        views.btnArray = [views.mButton0, views.mButton1, views.mButton2]
        views.mButton0.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        views.mButton1.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        views.mButton2.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }

    @objc private func btnClick(_ sender: UIButton) {

        let imgArray = [views.imgArray0, views.imgArray1, views.imgArray2, views.imgArray3, views.imgArray4, views.imgArray5]
        //點對
        if sender.tag == views.whichImage[views.whichRow] {
            playTheSoundEffects(forResource: "mHit")
            views.mScore += 1
            for i in 0..<imgArray.count {
                for j in 0...2 {
                    if i != 5 {
//                        imgArray[i][j].layer.add(imgAnimate(keyPath: "transform.translation.y", byValue: 1, reverses: false, duration: 0.06, counts: 1, fillMode: CAMediaTimingFillMode.removed), forKey: "true_translation.y")
                        imgArray[i][j].image = imgArray[i + 1][j].image
                    } else {
                        guard views.whichRow + 6 != 320 else { return }
                        if j == views.whichImage[views.whichRow + 6] {
                            imgArray[i][j].image = UIImage(named: "cat\(views.whichRow / 40)")
                        } else {
                            imgArray[i][j].image = UIImage(named: "")
                        }
                    }
                }
            }
            views.whichRow += 1
        } else {
            //點錯
            self.views.btnArray.forEach { (btn) in
                btn.isUserInteractionEnabled = false
            }
            playTheSoundEffects(forResource: "mError")
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                imgArray[0].forEach { (img) in
                    img.layer.add(self.imgAnimate(keyPath: "transform.translation.y", byValue: -25, reverses: true, duration: 0.15, counts: 1, fillMode: CAMediaTimingFillMode.forwards), forKey: "false_translation.y")
                }
            }
        }
    }
    @IBAction func didClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func imgReset() {
        let num = 0...2
        views.whichImage = []
        views.whichRow = 0
        var whichRow = 0
        for _ in 0...399 {
            views.whichImage.append(num.randomElement()!)
        }
        let imgArray = [views.imgArray0, views.imgArray1, views.imgArray2, views.imgArray3, views.imgArray4, views.imgArray5]
        for i in 0..<imgArray.count {
            for j in num {
                if j == views.whichImage[whichRow] {
                    imgArray[i][j].image = UIImage(named: "cat0")
                } else {
                    imgArray[i][j].image = UIImage(named: "")
                }
            }
            whichRow += 1
        }
    }

    private func imgAnimate(keyPath: String, byValue: Any, reverses: Bool, duration: TimeInterval, counts: Float, fillMode: CAMediaTimingFillMode) -> CABasicAnimation {
        let mAnimation = CABasicAnimation(keyPath: keyPath)
        mAnimation.byValue = byValue
        mAnimation.duration = duration
        mAnimation.repeatCount = counts
        mAnimation.fillMode = fillMode
        mAnimation.autoreverses = reverses
        mAnimation.delegate = self
        return mAnimation
    }

    private func playTheBgSong(forResource: String) {
        if let url = Bundle.main.url(forResource: forResource, withExtension: "mp3") {
            bgSongPlayer = AVPlayer(url: url)
            self.bgSongPlayer?.play()
        }
    }

    private func playTheSoundEffects(forResource: String) {
        if let url = Bundle.main.url(forResource: forResource, withExtension: "mp3") {
            soundEffectsPlayer = AVPlayer(url: url)
            self.soundEffectsPlayer?.play()
        }
    }

    private func countDown321() {
        var i = 0
        let imgArray = ["3", "2", "1", "start"]
        let imgArrayArray = [views.imgArray0, views.imgArray1, views.imgArray2, views.imgArray3, views.imgArray4, views.imgArray5]
        self.views.topImageView.isHidden = false
        self.views.topImageView.image = UIImage(named: "")
        
        imgArrayArray.forEach { (imgArray) in
            imgArray.forEach { (img) in
                img.image = UIImage(named: "")
            }
        }
        self.views.btnArray.forEach { (btn) in
            btn.isUserInteractionEnabled = false
        }
        
        time321 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            i += 1
            self.views.topImageView.image = UIImage(named: imgArray[i - 1])
            if i == 4 {
                self.time321?.invalidate()
                self.time321 = nil
                self.playTheSoundEffects(forResource: "mEnd")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.imgReset()
                    self.countDown()
                }
            } else {
                self.playTheSoundEffects(forResource: "mStart")
            }
        })
    }

    private func countDown() {
        playTheBgSong(forResource: UserDefaults.standard.string(forKey: "music3")!)
        views.topImageView.isHidden = true
        
        self.views.btnArray.forEach { (btn) in
            btn.isUserInteractionEnabled = true
        }
        
        var time = 30
        views.mTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            time -= 1
            self.views.timeLable.text = "Time: \(time)s"
            if time <= 0 {
                self.views.mTimer?.invalidate()
                self.views.mTimer = nil
                
                self.bgSongPlayer?.pause()
                
                self.views.mScore2.append(self.views.mScore)
                UserDefaults.standard.set(self.views.mScore2, forKey: "scores")

                let view = ShowCompleteToastView(frame: UIScreen.main.bounds, score: self.views.mScore, time: "")
                view.didClickDismissBtnHandler = { [weak self] in
                    guard let `self` = self else { return }
                    self.dismiss(animated: true, completion: nil)
                }
                view.didClickCarryOnBtnHandler = { [weak self] in
                    guard let `self` = self else { return }
                    self.countDown321()
                    self.views.timeLable.text = "Time: 30s"
                    self.views.mScore = 0
                }
                self.view.addSubview(view)
            }
        })
    }
}

extension WhackSecendViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.views.btnArray.forEach { (btn) in
            btn.isUserInteractionEnabled = true
        }
    }
}
