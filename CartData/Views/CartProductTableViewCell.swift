import UIKit
import Firebase

class CartProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var lblQtyTxt: UILabel!
    @IBOutlet weak var productOptions: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    var wishListClickedclousre:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        productImage.addTapGestureRecognizer {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = self.item.productId
            nextController.productName = self.item.name
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
        
        productName.addTapGestureRecognizer {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = self.item.productId
            nextController.productName = self.item.name
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
        
        // Configure the view for the selected state
    }
    @IBAction func wishlistClicked(_ sender: Any) {
        wishListClickedclousre?()
        
        //MARK:- ADD_TO_WISHLIST Analytics

        Analytics.setScreenName("Cart", screenClass: "CartDataViewController.class")
         Analytics.logEvent("ADD_TO_WISHLIST", parameters: ["productid":self.item.productId ,"name": self.item.name])
    }
    @IBAction func removeClicked(_ sender: Any) {
        
    }
    @IBAction func editClicked(_ sender: Any) {
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = self.item.productId
        nextController.itemId = self.item.id
        nextController.parentController = "cart"
        nextController.productName = self.item.name
        self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
    }
    
    var item: CartProducts! {
        didSet {
            self.productImage.setImage(fromURL: item.image, dominantColor: item.dominantColor)
            self.productName.text = item.name
            //self.productOptions.text = item.optionString
            self.lblQtyTxt.text = "Qty".localized + ": "
            self.qtyLabel.text =  item.qty
            self.priceLabel.text = item.formattedFinalPrice1
            self.messageLabel.text = item.messages
            discountPriceLabel.attributedText = item.strikePrice
            if discountPriceLabel.text != "" {
                priceLabel.textColor = .red
            }else{
                priceLabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0)
            }
            self.subTotalLabel.text = "Subtotal".localized + ": " + item.subTotal
            //self.subTotalLabel.halfTextWithColorChange(fullText: self.subTotalLabel.text!, changeText: "Subtotal".localized + ": ", color: AppStaticColors.labelSecondaryColor)
           // self.qtyLabel.halfTextWithColorChange(fullText: self.qtyLabel.text!, changeText: "Qty".localized + ": ", color: AppStaticColors.labelSecondaryColor)
        }
    }
    
}
