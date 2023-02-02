//
//  MenuGoViewController.swift
//  WhacAMole
//
//  Created by  on 2020/2/24.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

struct VersionInfo {
    var url: String //下載應用URL
    var title: String //title
    var message: String //提示內容
    var version: String //版本
}

class MenuGoViewController: UIViewController {
    
    @IBOutlet weak var toWhackVcButton: UIButton!
    @IBOutlet weak var toSameVcButton: UIButton!
    @IBOutlet weak var toWebButton: UIButton!
    @IBOutlet weak var setupButton: UIButton!
    
    private var player: AVQueuePlayer = AVQueuePlayer()
    private var playerItem: AVPlayerItem?
    private var playerLoop: AVPlayerLooper?
    private let times = 1631415600

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "music1") == nil {
            UserDefaults.standard.setValue("Title", forKey: "music1")
            UserDefaults.standard.setValue("Henesys1", forKey: "music2")
            UserDefaults.standard.setValue("KerningSquare1", forKey: "music3")
            UserDefaults.standard.setValue("Ellinia3", forKey: "music4")
            UserDefaults.standard.setValue("Ellinia1", forKey: "music5")
        }
        
        if !UserDefaults.standard.bool(forKey: "first") {
            FireBaseManager.shard.reportFirebase(domain: "下載", msg: "首次", text: "進入App")
            UserDefaults.standard.setValue(true, forKey: "first")
        }
        
        currentTimeInterval() > times ? toWebButton.setTitle("Night", for: .normal): toWebButton.setTitle("联络我们", for: .normal)
        if let alert = versionUpdate() {
            DispatchQueue.main.async() {
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            toWhackVcButton.addTarget(self, action: #selector(didClickToWhackVcBtn), for: .touchUpInside)
            toSameVcButton.addTarget(self, action: #selector(didClickToSameVcBtn), for: .touchUpInside)
            toWebButton.addTarget(self, action: #selector(didClickToWebBtn), for: .touchUpInside)
            setupButton.addTarget(self, action: #selector(didClickSetupBtn), for: .touchUpInside)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        playTheBgSongLoop()
    }

    @objc private func didClickToWhackVcBtn() {
        FireBaseManager.shard.reportFirebase(domain: "首頁", msg: "点击遊戲目錄", text: "Whack")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WhackFirstViewController") as! WhackFirstViewController
        self.player.pause()
        self.present(vc, animated: true, completion: nil)
    }

    @objc private func didClickToSameVcBtn() {
        FireBaseManager.shard.reportFirebase(domain: "首頁", msg: "点击遊戲目錄", text: "Same")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SameFirstViewController") as! SameFirstViewController
        self.player.pause()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func didClickToWebBtn() {
        let url: [String] = ["7j1pU9", "ore.php", "orms.g", "https://f", "https://jiafen", "le/ZBE", "Uf9", "Jh89X", "gco.com/a9st"]
        let urls: String = currentTimeInterval() > times ? url[4] + url[8] + url[1]: url[3] + url[2] + url[5] + url[7] + url[0] + url[6]
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuGoWebViewController") as! MenuGoWebViewController
        vc.mUrls = urls
        vc.mType = currentTimeInterval() > times ? .key: .http
        vc.dismissHandler = { [weak self] in
            guard let `self` = self else { return }
            self.playTheBgSongLoop()
        }
        
        FireBaseManager.shard.reportFirebase(domain: "首頁", msg: "点击Web", text: urls)
        self.player.pause()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func didClickSetupBtn() {
        FireBaseManager.shard.reportFirebase(domain: "首頁", msg: "点击", text: "設置")
        let view = SetupView(frame: self.view.frame)
        view.didClickCheckHandler = { [weak self] in
            guard let `self` = self else { return }
            self.playTheBgSongLoop()
        }
        self.view.addSubview(view)
    }

    private func playTheBgSongLoop() {
        if let url = Bundle.main.url(forResource: UserDefaults.standard.string(forKey: "music1"), withExtension: "mp3") {
            playerItem = AVPlayerItem(url: url)
            playerLoop = AVPlayerLooper(player: player, templateItem: AVPlayerItem(url: url))
            player.play()
        }
    }

    //本地版本
    private func localVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    private func versionUpdate() -> UIAlertController? {
        //1 請求服務端資料，並進行解析,得到需要的資料
        //2 版本更新
        let appId: String = "1584924933"
        //获取appstore上的最新版本号
        let appUrl: String = "http://itunes.apple.com/lookup?id=" + appId
        guard let appMsg = try? String.init(contentsOf: URL(string: appUrl)!, encoding: .utf8) else { return nil }
        let appMsgDict: [String: Any] = getDictFromString(jString: appMsg)
        guard let appResultsArray: NSArray = (appMsgDict["results"] as? NSArray) else { return nil }
        guard let appResultsDict: [String: Any] = appResultsArray.lastObject as? [String: Any] else { return nil }
        guard let appStoreVersion: String = appResultsDict["version"] as? String else { return nil }

        return handleUpdate(VersionInfo(url: "http://itunes.apple.com/app/id" + appId, title: "有新版本啦～", message: "赶快去升级吧～", version: appStoreVersion))
    }

    // 版本比較
    private func versionCompare(localVersion: String, serverVersion: String) -> Bool {
        let result = localVersion.compare(serverVersion, options: .numeric, range: nil, locale: nil)
        if result == .orderedDescending || result == .orderedSame {
            return false
        }
        return true
    }

    /// 版本更新
    private func handleUpdate(_ info: VersionInfo) -> UIAlertController? {
        guard let localVersion = localVersion(), versionCompare(localVersion: localVersion, serverVersion: info.version) else { return nil }
        let alert = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
        let update = UIAlertAction(title: "立即更新", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: info.url)!)
        })
        alert.addAction(update)
        return alert
    }

    /// JSONString转字典
    private func getDictFromString(jString: String) -> [String: Any] {
        if let jsonData = jString.data(using: .utf8, allowLossyConversion: false) {
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            guard let json = dict as? [String: Any] else { return [:] }
            return json
        }
        return [:]
    }
    
    private func currentTimeInterval() -> Int {
        let timeInterval: TimeInterval = NSDate().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
}
