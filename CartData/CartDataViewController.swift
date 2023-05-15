import UIKit
import Firebase

class CartDataViewController: ParentVC {
    
    @IBOutlet weak var bottomClicked: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountToBePaid: UILabel!
    @IBOutlet weak var crossBtn: UIBarButtonItem!
    @IBOutlet weak var wishlistBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    
    var cartViewModalObject: CartViewModel?
    var emptyView: EmptyView!
    var producctCount = 0
    var delegate : LoginPop?
    var isFromOther = false
    override func viewDidLoad() {
        super.viewDidLoad()
       // bottomClicked.addShadow(location: .top)
        //wishlistBtn.title = "Go to wishlist".localized
       // self.setupHomeLeftNavigationbar("Cart".localized)
        
        let img = crossBtn.image?.withRenderingMode(.alwaysTemplate)
        crossBtn.image = img?.flipImage()
        
        self.setupHomeLeftNavigationbar("Cart".localized)
        
        //self.navigationController?.navigationBar.shadowBorder()
        self.navigationController?.navigationBar.addShadow(location: .bottom)
//        self.navigationController!.navigationBar.shadowColor = UIColor.blackColor.CGColor
//        self.navigationBar.shadowOffset = CGSizeMake(5, 5)
//        self.navigationBar.shadowRadius = 5
        
        cartViewModalObject = CartViewModel()
        cartViewModalObject?.priceLabel = self.priceLabel
        cartViewModalObject?.cartController = self
        cartViewModalObject?.tableView = tableView
       // self.navigationItem.title = "Cart".localized
//        tableView.register(cellType: CartActionTableViewCell.self)
        tableView.register(cellType: CartProductTableViewCell.self)
        tableView.register(cellType: CartVoucherTableViewCell.self)
        tableView.register(cellType: GiftCardApplyTableViewCell.self)
        tableView.register(cellType: GiftAddedTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        tableView.register(cellType: RelatedProductTableViewCell.self)
        
        tableView.tableFooterView = UIView()
        proceedBtn.setTitle("Proceed".localized, for: .normal)
        amountToBePaid.text = "Total Incl. Tax".localized
        bottomClicked.isHidden = true
       

        // Do any additional setup after loading the view.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.cartViewModalObject?.whichApiCall = .getCartData
        self.callRequest()
        EventManager.sharedInstance.eventTrack(token: "hywi5s", amount: 1.0, revenueCurrency: "EUR")  //Event for Cart Screen
        if emptyView == nil {
            emptyView = EmptyView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "CartFile"))
            //            emptyView.emptyImages.image = UIImage(named: "illustration-bag")
            emptyView.actionBtn.isHidden = false
            emptyView.actionBtn.setTitle("Continue Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You have no items in your cart.".localized
            emptyView.titleText.text = "Empty Cart".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                //print("Ok fsdfsdfsdfsdfdsfsdfsdfs sdfs fsfs")
                self.emptyClicked()
            }
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PickUpDateAndTime"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dateAndTimeNotification"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       
         tableView.reloadData()
    }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
    
    
    func emptyClicked() {
        self.navigationController?.popViewController(animated: true)
       // self.dismiss(animated: true, completion: nil)
    }
    
    func eventForBasket(){
        var arrInfo:Array<Dictionary<String,String>> = []
        guard let cartModel =  cartViewModalObject?.cartModel else {
            return
        }
        arrInfo.append(["Count items":"\(cartModel.cartProducts.count)"])
        arrInfo.append(["Total cart value":cartModel.cartTotal])
        EventManager.sharedInstance.eventForPartnerParameter(token: "hywi5s", amount: 1.0, revenueCurrency: "EUR", arrDictInfo: arrInfo)
    }
    
    @IBAction func crossClicked(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func wishlistClicked(_ sender: Any) {
        if Defaults.customerToken == nil {
            let customerLoginVC = NewLoginViewController.instantiate(fromAppStoryboard: .customer)
            customerLoginVC.isFromOtherPage = true
            customerLoginVC.delegate = self
            self.navigationController?.pushViewController(customerLoginVC, animated: true)
        } else {
            let viewController = WishlistDataViewController.instantiate(fromAppStoryboard: .main)
            viewController.isFromCart = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        
        guard let cartModel =  cartViewModalObject?.cartModel else {
            return
        }
        
        if  cartModel.minimumAmount > cartModel.unformattedCartTotal {
            ShowNotificationMessages.sharedInstance.warningView(message: cartModel.descriptionMessage)
        } else if  !cartModel.isCheckoutAllowed {
            ShowNotificationMessages.sharedInstance.warningView(message: "You are not allowed to checkout".localized)
        } else  {
            if Defaults.customerToken != nil {
                let viewController = CheckoutDataViewController.instantiate(fromAppStoryboard: .checkout)
               // let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                viewController.isVirtual = self.cartViewModalObject?.cartModel.isVirtual
                
                //nav.modalPresentationStyle = .fullScreen
                
                //MARK:- BEGIN_CHECKOUT Analytics

                Analytics.setScreenName("Cart", screenClass: "CartDataViewController.class")
                Analytics.logEvent("BEGIN_CHECKOUT", parameters: ["id":Defaults.customerToken ?? ""])
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                Analytics.setScreenName("Cart", screenClass: "CartDataViewController.class")
                Analytics.logEvent("BEGIN_CHECKOUT", parameters: ["id":"Guset"])

                self.showAlert()
            }
        }
        
    }
    
    func callRequest() {
        cartViewModalObject?.callingHttppApi { [weak self] success,_  in
            guard let self = self else { return }
            if success {
                self.eventForBasket()
                self.priceLabel.text = self.cartViewModalObject?.cartModel.cartTotal
                self.producctCount = self.cartViewModalObject?.cartModel.cartProducts.count ?? 0
                if self.producctCount > 0 {
                    self.label.text = "Cart".localized + " (\(self.producctCount) " + "Items".localized + ")"
                } else {
                    self.label.text = "Cart".localized
                }
               
            } else {
                
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Checkout as new Customer".localized, style: .default, handler: new)
        let upload = UIAlertAction(title: "Checkout as existing Customer".localized, style: .default, handler: existing)
        let guestAction = UIAlertAction(title: "Checkout as guest Customer".localized, style: .default, handler: guest)
        let CancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: cancel)
        
        alert.addAction(upload)
        if let cartModel =  cartViewModalObject?.cartModel, cartModel.isAllowedGuestCheckout  {
            alert.addAction(guestAction)
        }
        alert.addAction(takeAction)
        alert.addAction(CancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height - 60, width : 1.0, height : 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func new(alertAction: UIAlertAction!) {
        let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
        customerCreateAccountVC.delegate = self
        isFromOther = true
        customerCreateAccountVC.isfromSocail = true
        self.navigationController?.pushViewController(customerCreateAccountVC, animated: true)
    }
    
    func existing(alertAction: UIAlertAction!) {
        LaunchHome.needAppRefresh = false
        let customerLoginVC = NewLoginViewController.instantiate(fromAppStoryboard: .customer)
        customerLoginVC.isFromOtherPage = true
        customerLoginVC.delegate = self
        self.navigationController?.pushViewController(customerLoginVC, animated: true)
//        let nav = UINavigationController(rootViewController: customerLoginVC)
//        //nav.navigationBar.tintColor = AppStaticColors.accentColor
//        self.present(nav, animated: true, completion: nil)
        
        
    }
    
    func cancel(alertAction: UIAlertAction!) {
        
    }
    
    func guest(alertAction: UIAlertAction!) {
        let viewController = CheckoutDataViewController.instantiate(fromAppStoryboard: .checkout)
        viewController.isVirtual = self.cartViewModalObject?.cartModel.isVirtual
        self.navigationController?.pushViewController(viewController, animated: true)
//        let nav = UINavigationController(rootViewController: viewController)
//        //nav.navigationBar.tintColor = AppStaticColors.accentColor
//        viewController.isVirtual = self.cartViewModalObject?.cartModel.isVirtual
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
    }
    
}
extension CartDataViewController : LoginPop {
    func loginPop() {
        self.navigationController?.navigationBar.isHidden = false
        if isFromOther == false || isFromOther == true {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
