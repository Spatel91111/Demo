//
//  SearchCell.swift
//  UnitedPharmacy
//
//  Created by Nipul Daki on 03/06/21.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
