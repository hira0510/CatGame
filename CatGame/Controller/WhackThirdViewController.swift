//
//  WhackThirdViewController.swift
//  WhacAMole
//
//  Created by  on 2020/2/25.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class WhackThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!

    var score: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.register(ScoreRecordTableViewCell.nib, forCellReuseIdentifier: "ScoreRecordTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        score = UserDefaults.standard.array(forKey: "scores") as? [Int] ?? []
        mTableView.reloadData()
    }

    @IBAction func dismissClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return score.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreRecordTableViewCell", for: indexPath) as! ScoreRecordTableViewCell
        cell.configCell(score: score[indexPath.row], time: "")
        return cell
    }
}
