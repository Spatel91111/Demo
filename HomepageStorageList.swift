//
/**
 Mobikul Single App
 @Category United Pharmacy
 @author United Pharmacy <support@United Pharmacy.com>
 FileName: HomepageStorageList.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html ASL Licence
 @link https://store.United Pharmacy.com/license.html
 
 */

import Foundation
import UIKit

enum HomeViewModelItemType {
    case banner
    case brand
    case featureCategory
    case recentViewData
    case carousel
    case staticData
    case offerData
}

protocol HomeViewModelItem {
    var type: HomeViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class HomeViewModelBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .banner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return bannerCollectionModel.count
    }
    
    var bannerCollectionModel = [BannerImages]()
    
    init(categories: [BannerImages]) {
        self.bannerCollectionModel = categories
    }
}

class HomeViewModelCarouselItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .carousel
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return carouselCollectionModel.count
    }
    
    var carouselCollectionModel = [Carousel]()
    
    init(categories: [Carousel]) {
        self.carouselCollectionModel = categories
    }
}

class HomeViewModelCategoriesItem : HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .featureCategory
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return categories.count
    }
    
    var categories = [Categories]()
    
    init(categories: [Categories]) {
        self.categories = categories
    }
}

class HomeViewModelFeatureCategoriesItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .featureCategory
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return featureCategories.count
    }
    
    var featureCategories = [FeaturedCategories]()
    
    init(categories: [FeaturedCategories]) {
        self.featureCategories = categories
    }
}

class HomeViewModelBrandssItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .brand
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return brands.count
    }
    
    var brands = [Brands]()
    
    init(brands: [Brands]) {
        self.brands = brands
    }
}

class HomeViewModelRecentViewItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .recentViewData
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return recentViewProductData.count
    }
    
    var recentViewProductData = [Productcollection]()
    
    init(categories: [Productcollection]) {
        self.recentViewProductData = categories
    }
    
}

class HomeViewModelStaticItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .staticData
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return arrStaticData.count
    }
    
    var arrStaticData : NSMutableArray = NSMutableArray()
    
    init(categories: NSMutableArray) {
        self.arrStaticData = categories
    }
}

class HomeViewModelOfferDataItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .offerData
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 0
    }
    
    var lblOfferData : String = ""
    var suffixOfferData : String = ""
    var clickUrlData : String = ""
    
    init(strOffer: String,suffix: String,url: String) {
        self.lblOfferData = strOffer
        self.suffixOfferData = suffix
        self.clickUrlData = url
    }
}

