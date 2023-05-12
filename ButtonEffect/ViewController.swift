//
//  ViewController.swift
//  ButtonEffect
//
//  Created by Subhash Kimani on 11/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnEffect1: UIButton!
    @IBOutlet weak var btnEffect2: UIButton!
    @IBOutlet weak var btnEffect3: UIButton!
    
    var aryTblList: [CheckListModel] = [CheckListModel](repeatElement(CheckListModel(name: "test", isChecked: false), count: 10))
    
    var aryColList: [CheckListModel] = [CheckListModel](repeatElement(CheckListModel(name: "test", isChecked: false), count: 10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onEffectClicked(_ sender : UIButton) {
        print("start clicked")
//        sender.showAnimation {
//            print(" ->stop clicked")
//        }
        
        // sender.shakeAnimation()
        
        sender.flashAnimation()
    }
}

struct CheckListModel {
    var name: String
    var isChecked: Bool
    
    init(name: String, isChecked: Bool) {
        self.name = name
        self.isChecked = isChecked
    }
    
    func getCheckMarkImage() -> UIImage? {
        return UIImage(systemName: isChecked ? "checkmark.circle" : "circle")
    }
}

/// extra code
extension UIView {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
}
