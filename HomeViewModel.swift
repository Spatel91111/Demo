//
/**
 Mobikul Single App
 @Category United Pharmacy
 @author United Pharmacy <support@United Pharmacy.com>
 FileName: HomeViewModel.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html ASL Licence
 @link https://store.United Pharmacy.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

var magazine_url = ""
var waitingText = ""
class HomeViewModel: NSObject {
    
    var items = [HomeViewModelItem]()
    var featuredProductCollectionModel = [Products]()
    var letestProductCollectionModel = [Products]()
    var categories = [Categories]()
    var carouselObj = [Carousel]()
    var languageData = [Languages]()
    var homeViewController: ViewController!
    weak var homeTableviewheight: NSLayoutConstraint?
    weak var homeTableView: UITableView!
    var guestCheckOut: Bool!
    var brands: [Brands]!
    var categoryImage = [CategoryImages]()
    var storeData = [StoreData]()
    var cmsData = [CMSdata]()
    var websiteData = [WebsiteData]()
    var allowedCurrencies: [Currency]!
    weak var moveDelegate: MoveController?
    var themeCode = 0
    var applogo = ""
    var darkApplogo = ""
    var arrData : NSMutableArray = NSMutableArray()
    
    var promotionTimer:Timer?
    
    func getDataFromDB(data: JSON, recentViewData: [Productcollection]?, completion:(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: data) else {
            return
        }
        self.homeViewController.cartBtn.badgeNumber = Int(Defaults.cartBadge ?? "0") ?? 0
        items.removeAll()
        
        if(arrData.count > 0)
        {
            arrData.removeAllObjects()
        }
        
        arrData.add(["Title":"Upload Prescription".localized,"ActionTitle":"Upload now","Image":"ic_prescription"])
        arrData.add(["Title":"Explore Offers".localized,"ActionTitle":"Recent orders","Image":"ic_offfer"])
        arrData.add(["Title":"Shop by Magazine".localized,"ActionTitle":"Explore now","Image":"icmag"])
        
        let bannerDataCollectionItem = HomeViewModelOfferDataItem(strOffer: data.offerText.removeWhiteSpace, suffix: data.suffix_text, url: data.clickUrl)
        
        items.append(bannerDataCollectionItem)
        
        self.themeCode = data.themeCode
        self.applogo = data.applogo
        self.darkApplogo = data.darkApplogo
        
        self.homeViewController.addLogoToNavigationBarItem()
        if self.themeCode == 1 {
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                    
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if data.featuredCategories.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                }
                
            } else {
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                
                if data.featuredCategories.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                    }
                }
            }
        } else {
            
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if data.featuredCategories.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                    
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                }
            } else {
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                
                if data.featuredCategories.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                    }
                }
                
            }
        }
        
        
        let StaticCollectionItem = HomeViewModelStaticItem(categories: arrData)
        items.insert(StaticCollectionItem, at: 2)
        
        //items.append(StaticCollectionItem)
        
        if data.storeData.count > 0 {
            self.storeData = data.storeData
        }
        
        if data.websiteData.count > 0 {
            self.websiteData = data.websiteData
        }
        
        self.cmsData = data.cmsData
        
        self.allowedCurrencies = data.allowedCurrencies
        self.brands = data.brands
        if data.categories.count > 0 {
            self.categories = data.categories
        }
        
        if data.categoryImages != nil {
            self.categoryImage = data.categoryImages
        }
        
        completion(true)
        
    }
    
    func getData(jsonData: JSON, recentViewData: [Productcollection]?, completion:(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: jsonData) else {
            return
        }
        items.removeAll()
        
        if(arrData.count > 0)
        {
            arrData.removeAllObjects()
        }
        
        arrData.add(["Title":"Prescription Dispensing".localized,"ActionTitle":"Upload now","Image":"ic_prescription1"])
        arrData.add(["Title":"Exclusive Offers".localized + "!","ActionTitle":"Recent orders","Image":"ic_offfer1"])
        arrData.add(["Title":"Shop Offers Magazine".localized,"ActionTitle":"Explore now","Image":"ic_magazin1"])
        
        self.themeCode = data.themeCode
        self.applogo = data.applogo
        self.darkApplogo = data.darkApplogo
        self.homeViewController.addLogoToNavigationBarItem()
        self.homeViewController.cartBtn.badgeNumber = Int(Defaults.cartBadge ?? "0") ?? 0
        print(data.sortDatByPostion)
        
        let bannerDataCollectionItem = HomeViewModelOfferDataItem(strOffer: data.offerText.removeWhiteSpace, suffix: data.suffix_text, url: data.clickUrl)
        
        items.append(bannerDataCollectionItem)
        
        if self.themeCode == 1 {
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                    
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if data.featuredCategories.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    if data.sortDatByPostion[m].layout_id == "shopByBrand"{
                        if data.brands.count > 0 {
                            let brandsCollectionItem = HomeViewModelBrandssItem(brands: data.brands)
                            items.append(brandsCollectionItem)
                        }
                    }
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                }
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            } else {
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                
                if data.featuredCategories.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                        
                    }
                }
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            }
            print(items)
        } else {
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if data.featuredCategories.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                }
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            } else {
                
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                
                if data.featuredCategories.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                        
                    }
                }
                
                
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            }
            print(items)
        }
        
        let StaticCollectionItem = HomeViewModelStaticItem(categories: arrData)
        items.insert(StaticCollectionItem, at: 2)
        
        if data.categories != nil {
            self.categories = data.categories
        }
        if data.websiteData.count > 0 {
            self.websiteData = data.websiteData
        }
        
        self.allowedCurrencies = data.allowedCurrencies
        self.brands = data.brands
        if data.storeData.count > 0 {
            self.storeData = data.storeData
        }
        
        if data.categoryImages != nil {
            self.categoryImage = data.categoryImages
        }
        
        self.cmsData = data.cmsData
        
        completion(true)
    }
    
    func updateRecentlyViewed(recentViewData: [Productcollection]?, completion:(_ section: Int?) -> Void) {
        var haveRecentObject = false
        if let recentViewData = recentViewData, recentViewData.count > 0 {
            for item in items where item.type == .recentViewData {
                haveRecentObject = true
                if let item = item as? HomeViewModelRecentViewItem {
                    item.recentViewProductData = recentViewData
                }
                if let index = items.firstIndex(where: {$0.type == item.type}) {
                    completion(index)
                }
            }
            if !haveRecentObject {
                let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                items.append(recents)
                completion(nil)
            }
        }
    }
    
    func setWishListFlagToFeaturedProductModel(data: Bool, pos: Int) {
        featuredProductCollectionModel[pos].isInWishList = data
    }
    
    func setWishListItemIdToFeaturedProductModel(data: String, pos: Int) {
        featuredProductCollectionModel[pos].wishlistItemId = data
    }
    
    func setWishListFlagToLatestProductModel(data: Bool, pos: Int) {
        letestProductCollectionModel[pos].isInWishList = data
    }
    
    func setWishListItemIdToLatestProductModel(data: String, pos: Int) {
        letestProductCollectionModel[pos].wishlistItemId = data
    }
}

extension HomeViewModel: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 || section == items.count - 1 {
            return 0
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 6))
        headerView.backgroundColor = AppStaticColors.borderColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        switch item.type {
        case .carousel:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .banner:
            if self.themeCode == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier) as? SliderTableViewCell {
                    cell.selectionStyle = .none
                    cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
                    cell.sliderCollectionView.reloadData()
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier) as? BannerTableViewCell {
                    cell.selectionStyle = .none
                    cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
                    cell.textTitleLabel.text = "Offers for you".localized.uppercased()
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    cell.bannerCollectionView.reloadData()
                    cell.bannerCollectionViewHeight.constant = cell.bannerCollectionView.collectionViewLayout.collectionViewContentSize.height
                    return cell
                }
            }
        case .featureCategory:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier) as? TopCategoryTableViewCell {
                cell.featureCategoryCollectionModel = ((item as? HomeViewModelFeatureCategoriesItem)?.featureCategories)!
                cell.themeCode = self.themeCode
                cell.selectionStyle = .none
                cell.delegate = homeViewController
                cell.categoryCollectionView.reloadData()
                return cell
            }
        case .brand:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BrandsTableViewCell.identifier) as? BrandsTableViewCell {
                let brands = ((items[indexPath.section] as? HomeViewModelBrandssItem)?.brands)!
                print(brands)
                
                cell.brandsCollectionModel = ((item as? HomeViewModelBrandssItem)?.brands)!
                cell.themeCode = self.themeCode
                cell.selectionStyle = .none
                cell.delegate = homeViewController
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                cell.categoryCollectionView.collectionViewLayout = layout
                cell.categoryCollectionView.reloadData()
                return cell
            }
            
        case .offerData:
            if let cell = tableView.dequeueReusableCell(withIdentifier: OfferTextCell.identifier) as? OfferTextCell {
                cell.lblOffer.text = ((item as? HomeViewModelOfferDataItem)?.lblOfferData)! + ((item as? HomeViewModelOfferDataItem)?.suffixOfferData)!
                
                //            let strNumber = ((item as? HomeViewModelOfferDataItem)?.lblOfferData)!
                //
                //            let range = NSString(string: ((item as? HomeViewModelOfferDataItem)?.lblOfferData)!).range(of: ((item as? HomeViewModelOfferDataItem)?.suffixOfferData)!, options: String.CompareOptions.caseInsensitive)
                //
                //            let attribute = NSMutableAttributedString.init(string: strNumber)
                //
                //            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: AppStaticColors.threeStar, range: range)
                //
                //            cell.lblOffer.attributedText = attribute
                
                cell.lblOffer.addTapGestureRecognizer {
                    let nextController = WebPageData.instantiate(fromAppStoryboard: .more)
                    nextController.webUrl = ((item as? HomeViewModelOfferDataItem)?.clickUrlData)!
                    nextController.strTitle = ((item as? HomeViewModelOfferDataItem)?.suffixOfferData)!
                    cell.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
                }
                cell.selectionStyle = .none
                
                return cell
            }
        case .staticData:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StaticCategoryTableViewCell.identifier) as? StaticCategoryTableViewCell {
                cell.arrData = ((item as? HomeViewModelStaticItem)?.arrStaticData)!
                cell.delegate = homeViewController
                cell.selectionStyle = .none
                cell.categoryCollectionView.reloadData()
                return cell
            }
        case .recentViewData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentHorizontalTableViewCell.identifier) as? RecentHorizontalTableViewCell,
                  let carouselItem = (item as? HomeViewModelRecentViewItem) else { return UITableViewCell() }
            cell.obj = self
            cell.selectionStyle = .none
            cell.products =  carouselItem.recentViewProductData
            cell.delegate = homeViewController
            cell.productCollectionView.reloadData()
            return cell
        case .carousel:
            let carouselItem = ((item as? HomeViewModelCarouselItem)?.carouselCollectionModel)![indexPath.row]
            //            print("layoutType: ", carouselItem.layoutType as Any)
            //             print("layout==: ", carouselItem.label)
            if carouselItem.type == CarouselType.product.rawValue {
                if carouselItem.layoutType == 1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as? ProductTableViewCell else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                        cell.buttonHeight.constant = 48
                    } else {
                        cell.viewAllButton.isHidden = true
                        cell.buttonHeight.constant = 48
                    }
                    cell.delegate = homeViewController
                    cell.titleLabel.text = carouselItem.label!.capitalized
                    self.homeTableviewheight?.constant = tableView.contentSize.height
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    cell.productCollectionView.reloadData()
                    cell.collectionViewheight.constant = cell.productCollectionView.collectionViewLayout.collectionViewContentSize.height
                    cell.viewAllButton.setTitle("viewall".localized.capitalized, for: .normal)
                    return cell
                } else if carouselItem.layoutType == 2 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout2.identifier) as? ProductTableViewCellLayout2 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                    } else {
                        cell.viewAllButton.isHidden = true
                    }
                    cell.delegate = homeViewController
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    cell.productCollectionView.reloadData()
                    cell.productCollectionVwHeight.constant = cell.productCollectionView.collectionViewLayout.collectionViewContentSize.height
                    return cell
                } else if carouselItem.layoutType == 3 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout3.identifier) as? ProductTableViewCellLayout3 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                    } else {
                        cell.viewAllButton.isHidden = true
                    }
                    cell.delegate = homeViewController
                    cell.productCollectionView.reloadData()
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout4.identifier) as? ProductTableViewCellLayout4 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                    } else {
                        cell.viewAllButton.isHidden = true
                    }
                    cell.delegate = homeViewController
                    cell.productCollectionView.reloadData()
                    return cell
                }
            } else if carouselItem.type == CarouselType.image.rawValue {
                print("carouselItem",carouselItem.id,carouselItem.label)
                if carouselItem.id == "1"{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: AdsTableViewCell.identifier) as? AdsTableViewCell {
                        cell.selectionStyle = .none
                        cell.imageCarouselCollectionModel = carouselItem.banners
                        cell.layoutIfNeeded()
                        cell.productCollectionView.reloadData()
                        cell.collectionViewheight.constant = UIScreen.main.bounds.width-30
                        return cell
                    }
                }else if carouselItem.id == "5"{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: AdsTableViewCell.identifier) as? AdsTableViewCell {
                        cell.selectionStyle = .none
                        cell.imageCarouselCollectionModel = carouselItem.banners
                        cell.layoutIfNeeded()
                        cell.productCollectionView.reloadData()
                        cell.collectionViewheight.constant = UIScreen.main.bounds.width-30
                        return cell
                    }
                } else if carouselItem.id == "2" {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: AdsSliderTableViewCell.identifier) as? AdsSliderTableViewCell {
                        cell.selectionStyle = .none
                        cell.bannerCollectionModel = carouselItem.banners
                        cell.sliderCollectionView.reloadData()
                        return cell
                    }
                }  else if carouselItem.id == "8" {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: BannersTableViewCell.identifier) as? BannersTableViewCell {
                        cell.selectionStyle = .none
                        cell.screenType = .ourService
                        cell.lblName.text = carouselItem.label
                        cell.bannerCollectionModel = carouselItem.banners
                        cell.consHeight.constant = 17
                        cell.bannerCollectionView.reloadData()
                        cell.layoutIfNeeded()
                        cell.bannerCollectionViewHeight.constant = cell.bannerCollectionView.collectionViewLayout.collectionViewContentSize.height
                        return cell
                    }
                } else if carouselItem.id == "11" {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: BannersTableViewCell.identifier) as? BannersTableViewCell {
                        cell.selectionStyle = .none
                        cell.screenType = .banners
                        cell.bannerCollectionModel = carouselItem.banners
                        cell.consHeight.constant = 0
                        cell.bannerCollectionView.reloadData()
                        cell.layoutIfNeeded()
                        cell.bannerCollectionViewHeight.constant = cell.bannerCollectionView.collectionViewLayout.collectionViewContentSize.height
                        return cell
                    }
                }  else if carouselItem.id == "12" {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: BottomSliderTableViewCell.identifier) as? BottomSliderTableViewCell {
                        cell.selectionStyle = .none
                        cell.bannerCollectionModel = carouselItem.banners
                        cell.sliderCollectionView.reloadData()
                        return cell
                    }
                } else if carouselItem.id == "10" {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: FlashSaleTableViewCell.identifier) as? FlashSaleTableViewCell {
                        cell.selectionStyle = .none
                        if carouselItem.banners.count > 0 {
                            cell.imgViewSale.setImage(fromURL: carouselItem.banners[indexPath.row].url, dominantColor: carouselItem.banners[indexPath.row].dominantColor)
                            cell.timer = promotionTimer
                            // logic for timer
                            if promotionTimer != nil{
                                promotionTimer?.invalidate()
                            }
                            promotionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                                let startDate = Date()
                                //let date = self.convertToString(date: Date(), formatIn: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                let endDateString  = self.UTCToLocal(date: carouselItem.banners[indexPath.row].endDate)
                                //print("\n\nend date\n\n",endDateString)
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                let endDate  = dateFormatter.date(from: endDateString)!
                                //let startDate = dateFormatter.date(from: date) ?? Date()
                                if self.checkDate(strEndDate: carouselItem.banners[indexPath.row].endDate ) {
                                    //print("date and time is match")
                                    timer.invalidate()
                                    UIView.performWithoutAnimation {
                                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    }
                                } else {
                                    //print("date and time is not match")
                                    // New logic
                                    let calendar = Calendar.current
                                    let components = calendar.dateComponents([.day, .hour, .minute, .second], from: startDate, to: endDate)
                                    var days: [String] = []
                                    var hour: [String] = []
                                    var minute: [String] = []
                                    var seconds: [String] = []
                                    let strDay: String = (String(describing: components.day ?? 0))
                                    let strHour: String = (String(describing: components.hour ?? 0))
                                    let strMinute: String = (String(describing: components.minute ?? 0))
                                    let strSecond: String = (String(describing: components.second ?? 0))
                                    //print(String(describing: components.day))
                                    //print(String(describing: components.hour))
                                    //print(String(describing: components.minute))
                                    //print(String(describing: components.second))
                                    days = strDay.map({ String($0) })
                                    hour = strHour.map({ String($0) })
                                    minute = strMinute.map({ String($0) })
                                    seconds = strSecond.map({ String($0) })
                                    //print(days)
                                    // For day
                                    if days.count > 2 {
                                        cell.lblDay.isHidden = false
                                        if days.count <=  2 {
                                            days.insert("0", at: 0)
                                        }
                                        cell.lblDay.text = days[0]
                                        cell.lblDay1.text = days[1]
                                        cell.lblDay2.text = days[2]
                                    } else {
                                        cell.lblDay.isHidden = true
                                        if days.count <=  1 {
                                            days.insert("0", at: 0)
                                        }
                                        cell.lblDay1.text = days[0]
                                        cell.lblDay2.text = days[1]
                                    }
                                    //print(hour)
                                    // For hour
                                    if hour.count <=  1 {
                                        hour.insert("0", at: 0)
                                    }
                                    cell.lblHour1.text = hour[0]
                                    cell.lblHour2.text = hour[1]
                                    //print(minute)
                                    // For min
                                    if minute.count <= 1 {
                                        minute.insert("0", at: 0)
                                        //minute.insert(minute[0], at: 1)
                                    }
                                    cell.lblMin1.text = minute[0]
                                    cell.lblMin2.text = minute[1]
                                    //print(seconds)
                                    // For sec
                                    if seconds.count <=  1 {
                                        seconds.insert("0", at: 0)
                                    }
                                    cell.lblSec1.text = seconds[0]
                                    cell.lblSec2.text = seconds[1]
                                }
                            })
                        }
                        cell.bannerButtonPressed = {
                            if carouselItem.banners[indexPath.row].bannerType == "category"{
                                if carouselItem.banners[indexPath.row].categoryName != ""{
                                    let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
                                    nextController.categoryId = carouselItem.banners[indexPath.row].id
                                    nextController.titleName = carouselItem.banners[indexPath.row].categoryName
                                    nextController.categoryType = ""
                                    nextController.titleName = carouselItem.banners[indexPath.row].categoryName
                                    let topVC = UIApplication.topMostViewController()
                                    topVC?.navigationController?.pushViewController(nextController, animated: true)
                                }
                            } else {
                                let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
                                nextController.productId = carouselItem.banners[indexPath.row].id
                                nextController.productName = carouselItem.banners[indexPath.row].productName
                                let topVC = UIApplication.topMostViewController()
                                topVC?.navigationController?.pushViewController(nextController, animated: true)
                            }
                        }
                        return cell
                    }
                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: ImageCarouselTableViewCell.identifier) as? ImageCarouselTableViewCell {
                        cell.imageCarouselCollectionModel = carouselItem.banners
                        cell.titleTextlabel.text = carouselItem.label!.uppercased()
                        cell.selectionStyle = .none
                        cell.imageCarouselCollectionView.reloadData()
                        self.homeTableviewheight?.constant = tableView.contentSize.height
                        return cell
                    }
                }
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
        case .banner:
            //return UITableView.automaticDimension
            return AppDimensions.screenWidth*0.5
        case .featureCategory:
            return UITableView.automaticDimension
        case .brand:
            return 150
        case .staticData:
            return AppDimensions.screenWidth*0.359
        case .recentViewData:
            return UITableView.automaticDimension
        case .carousel:
            let carouselItem = ((item as? HomeViewModelCarouselItem)?.carouselCollectionModel)![indexPath.row]
            if carouselItem.type == CarouselType.product.rawValue {
                return UITableView.automaticDimension
            } else if carouselItem.type == CarouselType.image.rawValue {
                if carouselItem.id == "1"{
                    return UITableView.automaticDimension
                } else if carouselItem.id == "5"{
                    return UITableView.automaticDimension
                } else if carouselItem.id == "2" {
                    return 150
                } else if carouselItem.id == "8" {
                    return UITableView.automaticDimension
                } else if carouselItem.id == "11" {
                    return UITableView.automaticDimension
                }  else if carouselItem.id == "12" {
                    return AppDimensions.screenWidth*0.335
                } else if carouselItem.id == "10" {
                    if carouselItem.banners.count > 0 {
                        if self.checkDate(strEndDate: carouselItem.banners[indexPath.row].endDate) {
                            return 0
                        } else {
                            return 230
                        }
                    } else {
                        return 0
                    }
                } else {
                    return 2*AppDimensions.screenWidth/3 + 41
                }
                
            }
        case .offerData:
            return 45.0
        }
        return 0
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let dt = dateFormatter.date(from: date) else { return "" }
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: dt)
    }
    
    func convertToString(date: Date, formatIn : String) -> String{
        let formatter2 = DateFormatter()
        formatter2.dateFormat = formatIn
        return formatter2.string(from: date)
    }
    
    func convertDateString(dateString : String!, fromFormat sourceFormat : String!, toFormat desFormat : String!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = desFormat
        return dateFormatter.string(from: date!)
    }
    
    func  checkDate(strEndDate: String) -> Bool {
        let date = self.convertToString(date: Date(), formatIn: "yyyy-MM-dd HH:mm:ss")
        let strCurrentDate = self.convertDateString(dateString: date, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd")
        let strDate = self.convertDateString(dateString: strEndDate, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd")
        if strCurrentDate == strDate {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let newDate = f.date(from: strEndDate) ?? Date()
            let currentDate = f.date(from: date) ?? Date()
            if newDate.time > currentDate.time {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

extension HomeViewModel {
    
    func callingHttppApi(productId: String, apiType: String,productName:String, completion: @escaping (Bool, JSON) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        //        requstParams["productId"] = productId
        requstParams["customerToken"] = Defaults.customerToken
        var apiName: WhichApiCall = .addToWishList
        var verbs: HTTPMethod = .post
        if apiType == "delete" {
            verbs = .delete
            apiName = .removeFromWishList
            requstParams["itemId"] = productId
        } else {
            verbs = .post
            requstParams["productId"] = productId
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success, jsonResponse)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                    completion(false, JSON.null)
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(productId: productId, apiType: apiType, productName: productName) {success,jsonResponse  in
                    completion(success, jsonResponse)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        if data["success"].boolValue {
            let message = data["message"].stringValue.count > 0 ?  data["message"].stringValue : "Product added to wishlist".localized
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
        }
        completion(true)
    }
}

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize){
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

