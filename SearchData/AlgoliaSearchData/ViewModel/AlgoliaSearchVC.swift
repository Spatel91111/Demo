//
//  AlgoliaSearchVC.swift
//  UnitedPharmacy
//
//  Created by Suraj Lalvani on 10/05/22.
//

import UIKit
import SwiftyJSON
import Kingfisher
import AlgoliaSearchClient

class AlgoliaSearchVC: UIViewController {

    @IBOutlet weak var tblAlgoliaSearch: UITableView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let algoliaSingleton = AlgoliaManager.sharedInstance
    var dataSearch : [[String:Any]] = [[String:Any]]()
    var modelData = [SearchData]()
    var AlgoliasearchViewModel: AlgoliaSearchViewModel?
    var categories = [Categories]()
    var searchQuery = ""
    var totalCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.textFieldDataChanges()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        self.tblAlgoliaSearch.register(ViewAllProductsFooterView.nib, forHeaderFooterViewReuseIdentifier: ViewAllProductsFooterView.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        searchBar.becomeFirstResponder()
    }
    
    func setupView() {
        searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
    }
    
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                backBtn.tintColor = AppStaticColors.darkItemTintColor
                
            } else {
                backBtn.tintColor = AppStaticColors.itemTintColor
            }
        } else {
            backBtn.tintColor = AppStaticColors.itemTintColor
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.theme()
        self.textFieldDataChanges()
    }
    
    func textFieldDataChanges() {
        searchBar.placeholder = "Search For Products".localized
        self.navigationItem.titleView = self.searchBar
        searchBar.delegate = self
        searchBar.textField?.backgroundColor = .clear
        
        
        
        AlgoliasearchViewModel = AlgoliaSearchViewModel()
        AlgoliasearchViewModel?.categories = self.categories
        AlgoliasearchViewModel?.delegate = self
        tblAlgoliaSearch.delegate = AlgoliasearchViewModel
        tblAlgoliaSearch.dataSource = AlgoliasearchViewModel
        AlgoliasearchViewModel?.tableView = tblAlgoliaSearch
    }

    func textFrom(_ Search:String) {
        var query = Query(Search)
        query.attributesToRetrieve = ["image_url", "price", "categories","name"]

        algoliaSingleton.getDataFrom(query) { [self] result in
            
            let data = result.hits.map {$0.object}.prefix(10)
            print("DATA COunt ->", result.nbHits ?? 0, "count->",result.hits.count)
            modelData.removeAll()
            for (_, searchValue) in data.enumerated() {
                let objet = searchValue.object()
                let searchData = SearchData(objet as? [String : Any] ?? [:])
                modelData.append(searchData)
        
            }
            DispatchQueue.main.async {
                AlgoliasearchViewModel?.totalDataCount = result.nbHits ?? 0
                self.AlgoliasearchViewModel?.modelData = self.modelData
                self.tblAlgoliaSearch.reloadData()
            }
        }
       
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tblAlgoliaSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - 35 , right: 0)
//            UIView.animate(withDuration: 0.0) {
//                self.tblAlgoliaSearch.layoutIfNeeded()
//                self.view.layoutIfNeeded()
//            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        self.tblAlgoliaSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        UIView.animate(withDuration: 0.0) {
//            self.tblAlgoliaSearch.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//        }
    }
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        
        self.backPress()
    }
    
    @IBAction func micClicked(_ sender: Any) {
        let viewController = AudioDetectionViewController.instantiate(fromAppStoryboard: .search)
        viewController.delegateAlgolia = self
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension AlgoliaSearchVC : AlgoliaSeachProtocols {
    func productListFromSearchQuery() {
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = searchQuery
        nextController.titleName = searchQuery
        nextController.searchText = searchQuery
        nextController.categoryType = "search"
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func productListFromQuery(query: String) {
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = ""
        nextController.titleName = query
        nextController.categoryId = query
        nextController.searchText = query
        nextController.categoryType = "search"
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func productListFromCategory(id: String, name: String) {
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = id
        nextController.titleName = name
        nextController.categoryType = "category"
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func productFromCategory(id: String, name: String) {
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = id
        nextController.productName = name
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func productFromSubCategory(id: String, name: String) {
        let viewController = SubCategoriesViewController.instantiate(fromAppStoryboard: .product)
        viewController.categoryId = id
        viewController.categoryName = name
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AlgoliaSearchVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText22 \(self.searchQuery)")
        self.textFrom(self.searchQuery)
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
//        self.searchQuery = text
      //  AlgoliasearchViewModel?.modelData = modelData
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            print("searchText11 \(self.searchQuery)")
            self.textFrom(self.searchQuery)
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        self.searchQuery = searchText
       // self.AlgoliasearchViewModel?.modelData = self.modelData
   //     DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.textFrom(searchText)
    //    }
        
    }
    
}

class SearchDataCell : UITableViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductTitle: UILabel!
}


