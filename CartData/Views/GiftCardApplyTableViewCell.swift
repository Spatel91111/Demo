//
//  GiftCardApplyTableViewCell.swift
//  UnitedPharmacy
//
//  Created by Pushkar Yadav on 14/02/2023.
//

import UIKit
import DropDown
class GiftCardApplyTableViewCell: UITableViewCell {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: HeaderViewGiftDelegate?
    var giftCodeDropDown = DropDown()
    var viewModel: GiftCardsViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = GiftCardsViewModel()
        
        textField.placeholder = "Enter Gift Card Code".localized
        if Defaults.language == "ar" {
            textField.semanticContentAttribute = .forceRightToLeft
            textField.textAlignment = .right
        }else{
            textField.semanticContentAttribute = .forceLeftToRight
            textField.textAlignment = .left
        }
        callAPI()
        giftCodeDropDown.anchorView = textField
        giftCodeDropDown.bottomOffset = CGPoint(x: 0, y: textField.bounds.height)
        giftCodeDropDown.selectionAction = { [weak self] (index, item) in
              self?.textField.text = item
          }
          
        giftCodeDropDown.dismissMode = .onTap
        giftCodeDropDown.direction = .bottom
        giftCodeDropDown.cornerRadius = 10
        if Defaults.language == "ar" {
            giftCodeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                // Setup your custom UI components
                cell.optionLabel.semanticContentAttribute = .forceRightToLeft
                cell.optionLabel.textAlignment = .right
            }
        }else{
            giftCodeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                // Setup your custom UI components
                cell.optionLabel.semanticContentAttribute = .forceLeftToRight
                cell.optionLabel.textAlignment = .left
            }
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func callAPI(){
        viewModel.callingHttppApi(pagetype: "cart")  { isSuccess in
            if isSuccess{
                self.giftCodeDropDown.dataSource = self.viewModel.model.giftCardData.map({$0.code})
            }
        }
    }
    @objc private func didTapHeader() {
        delegate?.toggleSectiona(view: self, section: 3)
    }
    
    @IBAction func btnDropDown(_ sender: Any) {
        textField.resignFirstResponder()
        giftCodeDropDown.show()
    }
}
protocol HeaderViewGiftDelegate: class {
    func toggleSectiona(view: UITableViewCell, section: Int)
}
