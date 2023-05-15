//
/**
 Mobikul Single App
 @Category United Pharmacy
 @author United Pharmacy <support@United Pharmacy.com>
 FileName: CartActionTableViewCell.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html ASL Licence
 @link https://store.United Pharmacy.com/license.html
 
 */

import UIKit

class CartActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var continueShoppingBtn: UIButton!
    @IBOutlet weak var emptyCartBtn: UIButton!
    @IBOutlet weak var updateCartBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        continueShoppingBtn.layer.borderWidth = 3.0
        updateCartBtn.setTitle("Update Cart".localized, for: .normal)
        emptyCartBtn.setTitle("Empty Cart".localized, for: .normal)
        continueShoppingBtn.setTitle("Continue Shopping".localized, for: .normal)
        //continueShoppingBtn.applyBorder(colours: AppStaticColors.accentColor)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
//                continueShoppingBtn.backgroundColor = UIColor.white
//                continueShoppingBtn.setTitleColor(UIColor.black, for: .normal)
                continueShoppingBtn.layer.borderColor = AppStaticColors.darkButtonBackGroundColor.cgColor

                continueShoppingBtn.backgroundColor = AppStaticColors.defaultColor
                continueShoppingBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                updateCartBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                updateCartBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                emptyCartBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                emptyCartBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                let image = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
                updateCartBtn.setImage(image, for: .normal)
                updateCartBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                let remove = UIImage(named: "cart-remove")?.withRenderingMode(.alwaysTemplate)
                emptyCartBtn.setImage(remove, for: .normal)
                emptyCartBtn.tintColor = AppStaticColors.darkButtonBackGroundColor

            } else {
                continueShoppingBtn.layer.borderColor = AppStaticColors.buttonBackGroundColor.cgColor
                continueShoppingBtn.backgroundColor = AppStaticColors.defaultColor
                continueShoppingBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                updateCartBtn.backgroundColor = AppStaticColors.buttonTextColor
                updateCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                emptyCartBtn.backgroundColor = AppStaticColors.buttonTextColor
                emptyCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                let image = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
                updateCartBtn.setImage(image, for: .normal)
                updateCartBtn.tintColor = AppStaticColors.buttonBackGroundColor
                let remove = UIImage(named: "cart-remove")?.withRenderingMode(.alwaysTemplate)
                emptyCartBtn.setImage(remove, for: .normal)
                emptyCartBtn.tintColor = AppStaticColors.buttonBackGroundColor

            }
        } else {
            continueShoppingBtn.layer.borderColor = AppStaticColors.buttonBackGroundColor.cgColor
            continueShoppingBtn.backgroundColor = AppStaticColors.defaultColor
            continueShoppingBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            updateCartBtn.backgroundColor = AppStaticColors.buttonTextColor
            updateCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            emptyCartBtn.backgroundColor = AppStaticColors.buttonTextColor
            emptyCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            let image = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
            updateCartBtn.setImage(image, for: .normal)
            updateCartBtn.tintColor = AppStaticColors.buttonBackGroundColor
            let remove = UIImage(named: "cart-remove")?.withRenderingMode(.alwaysTemplate)
            emptyCartBtn.setImage(remove, for: .normal)
            emptyCartBtn.tintColor = AppStaticColors.buttonBackGroundColor

        }

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
