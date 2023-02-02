//
//  SameSecendViewController.swift
//  SameCard
//
//  Created by  on 2020/3/3.
//

import UIKit
import AVFoundation
import MediaPlayer

class SameSecendViewController: UIViewController {

    @IBOutlet var mView: SameSecendViews!

    private var player: AVQueuePlayer = AVQueuePlayer()
    private var effectsPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerLoop: AVPlayerLooper?
    private var isDismiss: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    override func viewDidAppear(_ animated: Bool) {
        resetGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isDismiss = true
        player.pause()
    }

    private func setData() {
        mView.btnArray = [mView.mButton0, mView.mButton1, mView.mButton2, mView.mButton3, mView.mButton4, mView.mButton5, mView.mButton6, mView.mButton7, mView.mButton8, mView.mButton9, mView.mButton10, mView.mButton11, mView.mButton12, mView.mButton13, mView.mButton14, mView.mButton15]
    }

    @IBAction func didClickBact(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cardBtnDidClick(_ sender: UIButton) {
        UIView.transition(with: sender, duration: 0.2, options: [.transitionFlipFromLeft], animations: {
                sender.setImage(UIImage(named: self.mView.cardRandomNum[sender.tag]), for: .normal)
            }, completion: nil)
        playTheSoundEffects(forResource: "mHit")
        sender.isUserInteractionEnabled = false

        guard mView.isOpenCard else { //如果沒有牌是翻開的->就翻開
            mView.isOpenCard = true
            mView.previousNum = sender.tag
            return
        }

        //如果有牌是翻開的
        if mView.btnArray[mView.previousNum].image(for: .normal) == sender.image(for: .normal) && mView.previousNum != sender.tag {
            //如果上次翻的牌等於現在翻的牌&&牌面上的那張牌不等於現在翻的牌->達對
            mView.isOpenCard = false
            var count = 0
            mView.btnArray.forEach { (btn) in
                if btn.image(for: .normal) != UIImage(named: "card_cat_bg") {
                    count += 1
                    if count == 16 {
                        player.pause()
                        self.mView.mTimer?.invalidate()
                        self.mView.mTimer = nil
                        var time = UserDefaults.standard.array(forKey: "times") ?? []
                        time.append("\(mView.mTimes)")
                        UserDefaults.standard.set(time, forKey: "times")
                        let view = ShowCompleteToastView(frame: UIScreen.main.bounds, score: 0, time: "\(mView.mTimes)")
                        view.didClickDismissBtnHandler = { [weak self] in
                            guard let `self` = self else { return }
                            self.dismiss(animated: true, completion: nil)
                        }
                        view.didClickCarryOnBtnHandler = { [weak self] in
                            guard let `self` = self else { return }
                            self.resetGame()
                        }
                        self.view.addSubview(view)
                    }
                }
            }
        } else {
            //->答錯
            mView.maskView.isHidden = false
            mView.isOpenCard = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.transition(with: sender, duration: 0.2, options: [.transitionFlipFromRight], animations: {
                        sender.setImage(UIImage(named: "card_cat_bg"), for: .normal)
                        self.mView.btnArray[self.mView.previousNum].setImage(UIImage(named: "card_cat_bg"), for: .normal)
                    }, completion: nil)
                self.mView.btnArray[self.mView.previousNum].isUserInteractionEnabled = true
                sender.isUserInteractionEnabled = true
                self.mView.maskView.isHidden = true
            }
        }
    }

    func playTheBgSong() {
        if let url = Bundle.main.url(forResource: UserDefaults.standard.string(forKey: "music5"), withExtension: "mp3"), !isDismiss {
            playerItem = AVPlayerItem(url: url)
            playerLoop = AVPlayerLooper(player: player, templateItem: AVPlayerItem(url: url))
            player.play()
        }
    }

    func playTheSoundEffects(forResource: String) {
        if let url = Bundle.main.url(forResource: forResource, withExtension: "mp3") {
            effectsPlayer = AVPlayer(url: url)
            self.effectsPlayer?.play()
        }
    }

    func gameStart() {
        mView.timeLabel.text = "時間：\(self.mView.mTimes)s"
        mView.mTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            self.mView.mTimes += 1
            self.mView.timeLabel.text = "時間：\(self.mView.mTimes)s"
        })
    }

    func resetGame() {
        mView.mTimes = 0
        mView.timeLabel.text = "Time： s"
        mView.cardRandomNum.shuffle()
        mView.maskView.isHidden = false
        for i in 0..<mView.btnArray.count {
            UIView.transition(with: mView.btnArray[i], duration: 0.2, options: [.transitionFlipFromLeft], animations: {
                    self.mView.btnArray[i].setImage(UIImage(named: self.mView.cardRandomNum[i]), for: .normal)
                }, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.playTheBgSong()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.mView.btnArray.forEach { (btn) in
                btn.isUserInteractionEnabled = true
                for i in 0..<self.mView.btnArray.count {
                    UIView.transition(with: self.mView.btnArray[i], duration: 0.2, options: [.transitionFlipFromRight], animations: {
                            self.mView.btnArray[i].setImage(UIImage(named: "card_cat_bg"), for: .normal)
                        }, completion: nil)
                }
            }
            
            self.mView.maskView.isHidden = true
            self.gameStart()
        }
    }
}
