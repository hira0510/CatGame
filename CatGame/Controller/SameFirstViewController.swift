//
//  SameFirstViewController.swift
//  SameCard
//
//  Created by  on 2020/3/3.
//

import UIKit
import AVFoundation
import MediaPlayer

class SameFirstViewController: UIViewController {

    private var player: AVQueuePlayer = AVQueuePlayer()
    private var playerItem: AVPlayerItem?
    private var playerLoop: AVPlayerLooper?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if player.status == .unknown {
            playTheBgSong()
        } else {
            player.play()
        }
    }

    @IBAction func didClickDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.player.pause()
    }

    @IBAction func gogoClick(_ sender: UIButton) {
        var vc = UIViewController()
        if sender.tag == 0 {
            FireBaseManager.shard.reportFirebase(domain: "Same", msg: "点击", text: "遊戲")
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SameSecendViewController") as! SameSecendViewController
            player.pause()
        } else {
            FireBaseManager.shard.reportFirebase(domain: "Same", msg: "点击", text: "紀錄")
            vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SameThirdViewController") as! SameThirdViewController
        }
        self.present(vc, animated: true, completion: nil)
    }

    func playTheBgSong() {
        if let url = Bundle.main.url(forResource: UserDefaults.standard.string(forKey: "music4"), withExtension: "mp3") {
            playerItem = AVPlayerItem(url: url)
            playerLoop = AVPlayerLooper(player: player, templateItem: AVPlayerItem(url: url))
            player.play()
        }
    }
}

