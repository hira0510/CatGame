//
//  SetupView.swift
//  CatGame
//
//  Created by Hira on 2021/9/10.
//

import UIKit

class SetupView: UIView {
    
    @IBOutlet var mView: UIView!
    @IBOutlet weak var btmView: UIView!
        
    @IBOutlet weak var mPikerView1: UIPickerView!
    @IBOutlet weak var mPikerView2: UIPickerView!
    @IBOutlet weak var mPikerView3: UIPickerView!
    @IBOutlet weak var mPikerView4: UIPickerView!
    @IBOutlet weak var mPikerView5: UIPickerView!
    @IBOutlet weak var checkButton: UIButton!
    
    let musicStr = ["Title", "Ellinia1", "Ellinia2", "Ellinia3", "LithHarbor", "KerningCity1", "KerningCity2", "KerningSquare1", "KerningSquare2", "Ludibrium1", "Ludibrium2", "Ludibrium3", "Ludibrium4", "Orbis1", "Orbis2", "ShiningSea", "Henesys1", "Henesys2", "Henesys3", "ElNath", "Shop"]
    
    internal var didClickCheckHandler: (() -> Void)? = { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SetupView", owner: self, options: nil)
        addSubview(mView!)
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        btmView.layer.cornerRadius = 10
        checkButton.addTarget(self, action: #selector(clickCheck), for: .touchUpInside)
        setupUI()
    }
    
    private func setupUI() {
        let pikerView = [mPikerView1, mPikerView2, mPikerView3, mPikerView4, mPikerView5]
        for (i, value) in pikerView.enumerated() {
            value?.delegate = self
            value?.dataSource = self
            value?.selectRow(initSelectRow(i + 1), inComponent: 0, animated: false)
        }
    }
    
    private func initSelectRow(_ index: Int) -> Int {
        for (i, value) in musicStr.enumerated() {
            if value == UserDefaults.standard.string(forKey: "music\(index)") {
                return i
            }
        }
        return 0
    }
    
    @objc func clickCheck() {
        didClickCheckHandler?()
        self.removeFromSuperview()
    }
}

extension SetupView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return musicStr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return musicStr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case mPikerView1:
            UserDefaults.standard.setValue(musicStr[row], forKey: "music1")
        case mPikerView2:
            UserDefaults.standard.setValue(musicStr[row], forKey: "music2")
        case mPikerView3:
            UserDefaults.standard.setValue(musicStr[row], forKey: "music3")
        case mPikerView4:
            UserDefaults.standard.setValue(musicStr[row], forKey: "music4")
        default:
            UserDefaults.standard.setValue(musicStr[row], forKey: "music5")
        }
    }
}
