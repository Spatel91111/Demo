//
//  GiftCodeTableViewCell.swift
//  UnitedPharmacy
//
//  Created by Pushkar Yadav on 14/02/2023.
//

import UIKit

class GiftCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnRemove.setTitle("Remove".localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnRemoveTap(_ sender: Any) {
        
    }
}
