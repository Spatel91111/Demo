//
/**
 Mobikul Single App
 @Category United Pharmacy
 @author United Pharmacy <support@United Pharmacy.com>
 FileName: CartFormatTableViewCell.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html ASL Licence
 @link https://store.United Pharmacy.com/license.html
 
 */

import UIKit

class CartFormatTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: TotalsData! {
        didSet {
            titleLabel.text = item.title
            valueLabel.text = item.formattedValue
        }
    }
    
    var options: CartOptions! {
        didSet {
            titleLabel.text = options.label
            valueLabel.text = options.stringValues
        }
    }
    
    
    #if MARKETPLACE || BTOB || HYPERLOCAL
    // Mark: Seller Order details Data
    var sellerOrderDetailsTotals:Totals?{
        didSet{
            titleLabel.text = sellerOrderDetailsTotals?.label
            valueLabel.text = sellerOrderDetailsTotals?.formattedValue
        }
    }
    #endif
}
