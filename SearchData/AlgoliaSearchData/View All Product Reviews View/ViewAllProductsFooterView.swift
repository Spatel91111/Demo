//
//  ViewAllProductsFooterView.swift
//  UnitedPharmacy
//
//  Created by Pushkar Yadav on 11/10/22.
//

import UIKit

class ViewAllProductsFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lbl: UILabel!
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        //self.applyBorder1(colours: UIColor.red)
    }
    
    func applyBorder1(colours: UIColor) {
        btn.layer.borderColor = colours.cgColor
        btn.layer.borderWidth = 1
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

}
