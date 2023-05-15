//

/*
 Mobikul_Magento2V3_App
 @Category United Pharmacy
 @author United Pharmacy
 FileName: ViewController.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html
 */

import UIKit
import RealmSwift
import SideMenu
import FirebaseAnalytics
import Adjust

var homeViewGlobleModel: HomeViewModel!

class ViewController: ParentVC, UIScrollViewDelegate {
    var homeViewModel: HomeViewModel!
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var cartBtn: BadgeBarButtonItem!
    @IBOutlet weak var notificationBtn: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var refreshingView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var refreshLbl: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    
    
    //let icons = ["Icon1", "Icon1", "Icon2", "Icon3", "Icon4","Icon5"]
    
    var refreshControl: UIRefreshControl!
    let defaults = UserDefaults.standard
    //var locationManager: CLLocationManager?
    
    var homeJsonData: JSON = ""
    var historyToolBarView: BottomMoveToTopTableView?
    var checkFotter = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var titleView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 35 )) //40
        var titleImageView = UIImageView(image: UIImage(named: "Artboard1")) //"Artboard"
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        self.navigationItem.titleView = titleView
        txtSearch.placeholder = "Search".localized
        //        var logo = UIImage(named: "Artboard")
        //        let imageView = UIImageView(image:logo)
        //        self.navigationItem.titleView = imageView
        //
        self.setView()
        self.registerToReceiveNotification()
        //self.searchView.addShadow(location: .bottom)
        setupSideMenu()
        Analytics.setScreenName("HomePage", screenClass: "HomeViewController.class")
        homeViewModel = HomeViewModel()
        homeViewGlobleModel = homeViewModel
        
        //self.appNavigationTheme()
        self.addLogoToNavigationBarItem()
        refreshingView.layer.cornerRadius = 5
        refreshingView.layer.masksToBounds = true
        refreshLbl.text = "Refreshing...".localized
        homeTableView.register(cellType: TopCategoryTableViewCell.self)
        homeTableView.register(cellType: StaticCategoryTableViewCell.self)
        homeTableView.register(cellType: OfferTextCell.self)
        homeTableView.register(cellType: BannerTableViewCell.self)
        homeTableView.register(cellType: ImageCarouselTableViewCell.self)
        homeTableView.register(cellType: ProductTableViewCell.self)
        homeTableView.register(cellType: ProductTableViewCellLayout2.self)
        homeTableView.register(cellType: ProductTableViewCellLayout3.self)
        homeTableView.register(cellType: ProductTableViewCellLayout4.self)
        homeTableView.register(cellType: RecentHorizontalTableViewCell.self)
        homeTableView.register(cellType: SliderTableViewCell.self)
        homeTableView.register(cellType: AdsSliderTableViewCell.self)
        homeTableView.register(cellType: AdsTableViewCell.self)
        homeTableView.register(cellType: BrandsTableViewCell.self)
        homeTableView.register(cellType: FlashSaleTableViewCell.self)
        homeTableView.register(cellType: BannersTableViewCell.self)
        homeTableView.register(cellType: BottomSliderTableViewCell.self)
        
        // self.hidesBottomBarWhenPushed = true
        self.setupTableFooterView()
        homeViewModel.homeTableView = homeTableView
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        homeViewModel.moveDelegate = self
        self.homeViewModel.homeViewController = self
        if Defaults.searchEnable == nil {
            Defaults.searchEnable = "1"
        }
        
        homeTableView.rowHeight = UITableView.automaticDimension
        self.homeTableView.estimatedRowHeight = 100
        self.homeTableView.separatorColor = UIColor.clear
        
        //self.navigationItem.title = applicationName
        
        //add refresh control to tableview
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Refreshing...".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            homeTableView.refreshControl = refreshControl
        } else {
            homeTableView.backgroundView = refreshControl
        }
        //self.setupTableFooterView()
        self.tabBarController?.tabBar.items?[0].title = "Prescriptions".localized
        self.tabBarController?.tabBar.items?[1].title = "Categories".localized
        self.tabBarController?.tabBar.items?[2].title = "Home".localized
        self.tabBarController?.tabBar.items?[3].title = "Offer".localized
        self.tabBarController?.tabBar.items?[4].title = "Profile".localized
        
        //        if let count = self.tabBarController?.tabBar.items?.count {
        //            for i in 0...(count-1) {
        //                if(i == 2){
        //                    self.tabBarController?.tabBar.items?[i].selectedImage = UIImage(named: "line")?.withRenderingMode(.alwaysOriginal)
        //                    self.tabBarController?.tabBar.items?[i].image = UIImage(named: "line")?.withRenderingMode(.alwaysOriginal)
        //                }
        //            }
        //        }
        
        
        self.homeViewModel.getData(jsonData: homeJsonData, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
            if data {
                self.processDataForHomeController()
                //self.appNavigationTheme()
                addLogoToNavigationBarItem()
            }
        }
        //        DispatchQueue.main.async {
        //            self.locationManager = CLLocationManager()
        //            self.fetchLocation()
        //        }
        self.setupRefreshHome()
        if LaunchHome.needAppRefresh {
            self.refreshingView.isHidden = false
            //self.callingHttppApi(showLoader: false)
            self.refreshHomePageData()
            //self.appNavigationTheme()
            addLogoToNavigationBarItem()
        }
        
        if let tabbar = self.parent?.parent {
            print(tabbar)
            tabbar.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        self.navigationController?.navigationBar.draw(CGRect(x: 0, y: 0, width: 30, height: 30))
        self.navigationItem.rightBarButtonItem?.customView?.frame.size.width = 30
        //self.initHyperLocalView()
    }
    
    func setView() {
        if Defaults.language == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
                UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            
            L102Language.setAppleLAnguageTo(lang: "en")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                UITabBar.appearance().semanticContentAttribute =  .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
                UILabel.appearance().semanticContentAttribute = .forceLeftToRight
                
            } else {
                // Fallback on earlier versions
            }
        }
        // btnHelp.cornerRadii(radii: 30)
        // btnHelp.isHidden = true
        btnHelp.setRadiusWithShadow()
        
    }
    private func setupSideMenu() {
        
        
        let objData = SideMenuNavigationController(rootViewController: MenuViewController.instantiate(fromAppStoryboard: .main))
        
        if Defaults.language == "ar"
        {
            SideMenuManager.default.rightMenuNavigationController = objData
            objData.leftSide = false
        }
        else
        {
            SideMenuManager.default.leftMenuNavigationController = objData
            objData.leftSide = true
            
        }
        
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = UIColor.red
        presentationStyle.presentingEndAlpha = 0.5
        
    }
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return modes[0]
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        if self.homeViewModel.promotionTimer != nil {
            self.homeViewModel.promotionTimer?.invalidate()
        }
        callingHttppApi()
    }
    
    @IBAction func changeButtonClick(_ sender: UIButton) {
#if HYPERLOCAL
        let viewController = AddressSuggestionController.instantiate(fromAppStoryboard: .hyperlocal)
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true)
#endif
        
    }
    
    func addLogoToNavigationBarItem() {
        //        if #available(iOS 12.0, *) {
        //            if self.traitCollection.userInterfaceStyle == .dark {
        //                titleImage.setImageHomeLogo(fromURL: homeViewModel.darkApplogo)
        //                self.navigationItem.titleView?.backgroundColor = UIColor.red
        //                self.navigationItem.titleView = titleImage
        //                self.navigationController?.navigationItem.titleView?.backgroundColor = .red
        //
        //                //AppStaticColors.darkPrimaryColor
        //                //print(titleImage, homeViewModel.darkApplogo, self.navigationItem.titleView, "ghgg")
        //            } else {
        //
        //                titleImage.setImageHomeLogo(fromURL: homeViewModel.applogo)
        //                //titleImage.image = UIImage(named: "Artboard")
        //                self.navigationItem.titleView?.backgroundColor = UIColor.clear
        //                self.navigationItem.titleView = titleImage
        //                self.navigationController?.navigationItem.titleView?.backgroundColor = AppStaticColors.accentColor
        //
        //            }
        //        } else {
        //
        //            //titleImage.image = UIImage(named: "Artboard")
        //            self.navigationItem.titleView?.backgroundColor = UIColor.red
        //            self.navigationItem.titleView = titleImage
        //            self.navigationController?.navigationItem.titleView?.backgroundColor = .red
        //           // self.navigationController?.navigationItem.titleView?.backgroundColor = AppStaticColors.primaryColor
        //        }
        //
        //titleImage.setImageHomeLogo(fromURL: homeViewModel.applogo)
        //        titleImage.image = UIImage(named: "Artboard")
        //        self.navigationItem.titleView?.backgroundColor = UIColor.clear
        //        self.navigationItem.titleView = titleImage
        //        self.navigationController?.navigationItem.titleView?.backgroundColor = AppStaticColors.primaryColor
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if UIApplication.shared.applicationState != .background {
            //self.appNavigationTheme()
            self.addLogoToNavigationBarItem()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.removeShadow()
        EventManager.sharedInstance.eventTrack(token: "872wkc", amount: 1.0, revenueCurrency: "EUR") //Event for Home Screen
        SocketChatManager.shared.socketDisconnect()
        //fatalError("Crash was triggered")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.removeShadow()
        self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }
    func appNavigationTheme() {
        //        if #available(iOS 12.0, *) {
        //            if self.traitCollection.userInterfaceStyle == .dark {
        //                self.tabBarController?.tabBar.tintColor = AppStaticColors.accentColor
        //                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.accentColor], for: .selected)
        //                UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
        //                UITabBar.appearance().tintColor =   AppStaticColors.accentColor
        //                self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
        //                self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
        //                UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
        //                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
        //                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
        //
        //            } else {
        //                self.tabBarController?.tabBar.tintColor = AppStaticColors.accentColor
        //                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.accentColor], for: .selected)
        //                UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        //                UITabBar.appearance().tintColor =   AppStaticColors.accentColor
        //                self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
        //                self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
        //                UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
        //                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        //                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        //
        //            }
        //        } else {
        //            self.tabBarController?.tabBar.tintColor = AppStaticColors.accentColor
        //            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.accentColor], for: .selected)
        //            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        //            UITabBar.appearance().tintColor =   AppStaticColors.accentColor
        //            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
        //            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
        //            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
        //            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        //            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        //
        //        }
        
        
    }
    func callingHttppApi(showLoader: Bool = true) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            var requstParams = [String: Any]()
            NetworkManager.sharedInstance.showLoader()
            if self.refreshControl.isRefreshing {
                NetworkManager.sharedInstance.dismissLoader()
            } else if !showLoader {
                NetworkManager.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
            }
            requstParams["storeId"] = Defaults.storeId
            requstParams["customerToken"] = Defaults.customerToken
            requstParams["quoteId"] = Defaults.quoteId
            requstParams["currency"] = Defaults.currency
            
            requstParams["websiteId"] = UrlParams.defaultWebsiteId
            requstParams["width"] = UrlParams.width
            requstParams["is_home_brands"] = "1"
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .loadHome, currentView: self) {success, responseObject in
                self.refreshingView.isHidden = true
                if success == 1 {
                    NetworkManager.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        
                        // self.changeIcon(iconName: self.icons[Int(jsonResponse["launcherIconType"].stringValue) ?? 0])
                        
                        if jsonResponse["storeId"] != JSON.null {
                            let storeId: String = String(format: "%@", jsonResponse["storeId"].stringValue)
                            if storeId != "0"{
                                self.defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        
                        if jsonResponse["defaultCurrency"] != JSON.null {
                            if self.defaults.object(forKey: "currency") == nil {
                                self.defaults .set(jsonResponse["defaultCurrency"].stringValue, forKey: "currency")
                            }
                        }
                        
                        let dict =  JSON(responseObject as? NSDictionary ?? [:])
                        
                        // store the data to data base
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: dict["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                        }
                        //                        if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getData(jsonData: dict, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
                            if data {
                                //save etag
                                Defaults.eTag = dict["eTag"].stringValue
                                // self.appNavigationTheme()
                                self.addLogoToNavigationBarItem()
                                self.processDataForHomeController()
                            }
                        }
                        //                        }
                        
                    } else {
                        self.showErrorSnackBar(msg: "somethingWentWrong".localized)
                    }
                } else if success == 2 {   // Retry in case of error
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                } else if success == 3 {   // No Changes
                    let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                    print(data)
                    
                    // self.changeIcon(iconName: self.icons[Int(data["launcherIconType"].stringValue) ?? 0])
                    
                    if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getDataFromDB(data: data, recentViewData: products, completion: { (data: Bool) in
                            if data {
                                self.processDataForHomeController()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func getProductDataFromDB() -> [Productcollection]? {
        if  let results: Results<Productcollection> = DBManager.sharedInstance.database?.objects(Productcollection.self) {
            return ((Array(results)).sorted(by: { $0.dateTime.compare($1.dateTime) == .orderedDescending }))
        } else {
            return nil
        }
    }
    
    func setupTableFooterView() {
        
        historyToolBarView = Bundle.main.loadNibNamed("BottomMoveToTopTableView", owner: nil, options: nil)![0] as? BottomMoveToTopTableView
        historyToolBarView?.tableView = self.homeTableView
        historyToolBarView?.translatesAutoresizingMaskIntoConstraints = false
        if historyToolBarView != nil {
            historyToolBarView?.addConstraints(
                [NSLayoutConstraint.init(item: historyToolBarView!,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 103),
                 NSLayoutConstraint.init(item: historyToolBarView!,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: UIScreen.main.bounds.size.width)])
            
            // Create a container of your footer view called footerView and set it as a tableFooterView
            let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.homeTableView.frame.width, height: 0))
            //footerView.backgroundColor = UIColor.green
            homeTableView.tableFooterView = footerView
            checkFotter = true
            // Add your footer view to the container
            // footerView.addSubview(historyToolBarView!)
        }
    }
    
    func processDataForHomeController() {
        self.refreshControl.endRefreshing()
        
        self.homeViewModel.homeTableviewheight = self.tableviewHeight
        self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
        
        self.tabBarController?.tabBar.isHidden = false
        self.view.isUserInteractionEnabled = true
        //        if NetworkManager.AddOnsEnabled.wishlistEnable {
        //            self.tabBarController?.tabBar.items?[2].isEnabled = true
        //        } else {
        //            self.tabBarController?.tabBar.items?[2].isEnabled = false
        //        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.homeTableView.contentSize.height >= (AppDimensions.screenHeight * 1.5 ) {
                self.historyToolBarView?.isHidden = false
            } else {
                self.historyToolBarView?.isHidden = true
                
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforCategoryOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforProductOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforCustomCollectionOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforasktopharmacistOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforOtherOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforOrderOnTap"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("refreshHome"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("updateRecentlyViewed"), object: nil)
    }
    
    @IBAction func btnHelpTap(_ sender: Any) {
        let viewController = HelpCenterViewController.instantiate(fromAppStoryboard: .pharmacist)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: MoveController {
    func moveController(id: String, name: String, dict: DictType, jsonData: JSON, type: String, controller: AllControllers) {
        self.navigationController?.navigationBar.isHidden = false
        switch controller {
        case .allBrandViewController :
            
            let nextController = BrandViewController.instantiate(fromAppStoryboard: .main)
            
            //            nextController.brandViewModal.brandCollectionModel  =  dict["brand"] as! [Brands]
            //
            //nextController.titleName  = "Brands".localized
            self.navigationController?.pushViewController(nextController, animated: true)
            
        case .productcategory:
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = id
            nextController.titleName = name
            nextController.categoryType = type
            self.navigationController?.pushViewController(nextController, animated: true)
        case .signInController:
            NewLoginViewController.instantiate(fromAppStoryboard: .customer)
            
            //            let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
            //            let nav = UINavigationController(rootViewController: customerLoginVC)
            //            nav.modalPresentationStyle = .fullScreen
            //            self.present(nav, animated: true, completion: nil)
        case .ArrivalOfferVC :
            tabBarController?.selectedIndex = 3
            //            let nextController = ArrivalOfferVC.instantiate(fromAppStoryboard: .main)
            ////            nextController.categoryId = id
            ////            nextController.titleName = name
            ////            nextController.categoryType = type
            //            self.navigationController?.pushViewController(nextController, animated: true)
        case .ComingSoonVC:
            tabBarController?.selectedIndex = 2
        case .allCategoriesViewController:
            
            //let nextController = CategoriesViewController.instantiate(fromAppStoryboard: .main)
            //self.hidesBottomBarWhenPushed = false
            tabBarController?.selectedIndex = 1
            //self.navigationController?.pushViewController(nextController, animated: true)
        case .webPageData:
            let nextController = WebPageData.instantiate(fromAppStoryboard: .more)
            if magazine_url != ""{
                nextController.webUrl = "\(magazine_url)=&fullscreen=1"
            }else{
                nextController.webUrl = "https://cdn.flipsnack.com/widget/v2/widget.html?hash=dni6mpnd1j=&fullscreen=1"
            }
            nextController.isFromMagazine = true
            nextController.strTitle = "Shop by Magazine".localized
            self.navigationController?.pushViewController(nextController, animated: true)
        default:
            break
        }
    }
}

// For barbutton actions

extension ViewController {
    
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        //        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        //        //viewController.modalPresentationStyle = .overCurrentContext
        //        viewController.categories = self.homeViewModel.categories
        //        self.navigationController?.pushViewController(viewController, animated: true)
        let viewController = AlgoliaSearchVC.instantiate(fromAppStoryboard: .search)
        viewController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func notificationClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = NotificationDataViewController.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    
}
extension ViewController{
    func registerToReceiveNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCategoryTap), name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedProductTap), name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCustomCollectionTap), name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedAskToPharmacistTap), name: NSNotification.Name(rawValue: "pushNotificationforasktopharmacistOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOtherTap), name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOrderTap), name: NSNotification.Name(rawValue: "pushNotificationforOrderOnTap"), object: nil)
    }
    
    @objc func pushNotificationReceivedCategoryTap(_ note: Notification) {
        let root  = note.userInfo
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = root?["categoryId"] as? String ?? ""
        nextController.titleName = root?["categoryName"] as? String ?? ""
        nextController.categoryType = ""
        //            nextController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
    
    @objc func pushNotificationReceivedProductTap(_ note: Notification) {
        let root = note.userInfo
        
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = root?["productId"] as? String ?? ""
        nextController.productName = root?["productName"] as? String ?? ""
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    @objc func pushNotificationReceivedCustomCollectionTap(_ note: Notification) {
        let root = note.userInfo;
        
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = root?["id"] as? String ?? ""
        nextController.titleName = root?["title"] as? String ?? ""
        nextController.categoryType = "custom"
        //            nextController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
    @objc func pushNotificationReceivedAskToPharmacistTap(_ note: Notification) {
        
        if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil {
            let nextController = CommunicationMethodViewController.instantiate(fromAppStoryboard: .pharmacist)
            nextController.isFromHome = true
            self.navigationController?.pushViewController(nextController, animated: true)
        } else {
            let nextController = NewLoginViewController.instantiate(fromAppStoryboard: .customer)
            nextController.isFromHome = true
            self.navigationController?.pushViewController(nextController, animated: true)
        }
        
    }
    @objc func pushNotificationReceivedOtherTap(_ note: Notification) {
        let root = note.userInfo;
        let title = root?["title"] as? String ?? ""
        let content = root?["message"] as? String ?? ""
        let AC = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.callingHttppApi();
        })
        AC.addAction(okBtn)
        self.parent!.present(AC, animated: true, completion: { })
    }
    
    @objc func pushNotificationReceivedOrderTap(_ note: Notification) {
        let root = note.userInfo;
        let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.orderId = root?["incrementId"] as? String ?? ""
        self.navigationController?.pushViewController(viewController, animated: true)
        //        let nav = UINavigationController(rootViewController: viewController)
        //        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        //        nav.modalPresentationStyle = .fullScreen
        //        self.present(nav, animated: true, completion: nil)
    }
}

extension ViewController {
    
    func setupRefreshHome() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeData), name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeApiData), name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateRecentlyViewed), name: NSNotification.Name(rawValue: "updateRecentlyViewed"), object: nil)
    }
    
    @objc func updateRecentlyViewed() {
        self.homeViewModel.updateRecentlyViewed(recentViewData: self.getProductDataFromDB()) {(section: Int?) in
            self.homeViewModel.homeTableviewheight = self.tableviewHeight
            self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
            //            if let section = section {
            //                self.homeTableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
            //            } else {
            //                self.homeTableView.reloadData()
            //            }
        }
    }
    
    @objc func refreshHomeApiData() {
        self.refreshingView.isHidden = false
        self.refreshHomePageData()
    }
    
    @objc func refreshHomeData() {
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[1] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[2] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[4] as? UINavigationController)?.popToRootViewController(animated: true)
        self.refreshingView.isHidden = false
        self.refreshHomePageData()
    }
    
    func refreshHomePageData() {
        //UITabBar.appearance().tintColor =   AppStaticColors.primaryColor
        //UITabBar.appearance().tintColor =   UIColor.red
        DispatchQueue.main.async {
            var requstParams = [String: Any]()
            requstParams["storeId"] = Defaults.storeId
            requstParams["customerToken"] = Defaults.customerToken
            requstParams["quoteId"] = Defaults.quoteId
            requstParams["currency"] = Defaults.currency
            requstParams["websiteId"] = UrlParams.defaultWebsiteId
            requstParams["width"] = UrlParams.width
            requstParams["is_home_brands"] = "1"
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .loadHome, currentView: self) {success, responseObject in
                self.refreshingView.isHidden = true
                if success == 1 {
                    self.view.isUserInteractionEnabled = true
                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        //self.changeIcon(iconName: self.icons[Int(jsonResponse["launcherIconType"].stringValue) ?? 0])
                        
                        if jsonResponse["storeId"] != JSON.null {
                            let storeId: String = String(format: "%@", jsonResponse["storeId"].stringValue)
                            if storeId != "0"{
                                self.defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        if jsonResponse["defaultCurrency"] != JSON.null {
                            if self.defaults.object(forKey: "currency") == nil {
                                self.defaults .set(jsonResponse["defaultCurrency"].stringValue, forKey: "currency")
                            }
                        }
                        let dict =  JSON(responseObject as? NSDictionary ?? [:])
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: dict["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                        }
                        self.homeViewModel.getData(jsonData: dict, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
                            if data {
                                Defaults.eTag = dict["eTag"].stringValue
                                self.refreshControl.endRefreshing()
                                self.homeViewModel.homeTableviewheight = self.tableviewHeight
                                // self.appNavigationTheme()
                                self.addLogoToNavigationBarItem()
                                self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                                if GlobalVariables.walkThroughFirstTime {
                                    GlobalVariables.walkThroughFirstTime = false
                                    Defaults.walkthroughShow = false
                                }
                                //self.processDataForHomeController()
                            }
                        }
                    } else {
                        self.showErrorSnackBar(msg: "somethingWentWrong".localized)
                    }
                } else if success == 2 {   // Retry in case of error
                    self.refreshHomePageData()
                } else if success == 3 {   // No Changes
                    let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                    print(data)
                    //self.changeIcon(iconName: self.icons[Int(data["launcherIconType"].stringValue) ?? 0])
                    if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getDataFromDB(data: data, recentViewData: products, completion: { (data: Bool) in
                            if data {
                                if GlobalVariables.walkThroughFirstTime {
                                    GlobalVariables.walkThroughFirstTime = false
                                    Defaults.walkthroughShow = false
                                }
                                self.processDataForHomeController()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func changeIcon(iconName: String) {
        
        //        if #available(iOS 10.3, *) {
        //               UIApplication.shared.setAlternateIconName(iconName)
        //            }
        
        if #available(iOS 10.3, *) {
            print(iconName)
            if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
                
                typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
                
                let selectorString = "_setAlternateIconName:completionHandler:"
                
                let selector = NSSelectorFromString(selectorString)
                let imp = UIApplication.shared.method(for: selector)
                let method = unsafeBitCast(imp, to: setAlternateIconName.self)
                method(UIApplication.shared, selector, iconName as NSString?, { _ in })
            }
        }
        
        
    }
    
}

extension  ViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}

extension UIView {
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
}
