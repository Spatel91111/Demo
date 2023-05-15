//
/**
 Mobikul Single App
 @Category United Pharmacy
 @author United Pharmacy <support@United Pharmacy.com>
 FileName: CartVoucherTableViewCell.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html ASL Licence
 @link https://store.United Pharmacy.com/license.html
 
 */

import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
//import MaterialComponents.MaterialTextFields_TypographyThemer

class CartVoucherTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var applyDiscountCodeLbl: UILabel!
    //@IBOutlet weak var arrowBtn: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    //@IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var applyBtn: UIButton!
    //@IBOutlet weak var topView: UIView!
    @IBOutlet weak var textField: UITextField!
    weak var delegate: HeaderViewDelegate?
    var discountController: MDCTextInputControllerOutlined!
    override func awakeFromNib() {
        super.awakeFromNib()

        textField.placeholder = "Enter Discount Code".localized
        if Defaults.language == "ar" {
            textField.semanticContentAttribute = .forceRightToLeft
            textField.textAlignment = .right
        }else{
            textField.semanticContentAttribute = .forceLeftToRight
            textField.textAlignment = .left
        }

    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(view: self, section: 1)
    }
    
    @IBAction func applyclicked(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

protocol HeaderViewDelegate: class {
    func toggleSection(view: UITableViewCell, section: Int)
}
