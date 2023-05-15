//
//  AlgoliaSearchViewModel.swift
//  UnitedPharmacy
//
//  Created by Suraj Lalvani on 10/05/22.
//

import Foundation
import SwiftyJSON
import Kingfisher
import AlgoliaSearchClient
import UIKit

class AlgoliaSearchViewModel: NSObject {
    weak var tableView: UITableView?
    var categories = [Categories]()
    var modelData = [SearchData]()
    var totalDataCount = 0
    weak var delegate: AlgoliaSeachProtocols?
}

protocol AlgoliaSeachProtocols: AnyObject {
    func productListFromQuery(query: String)
    func productListFromCategory(id: String, name: String)
    func productFromCategory(id: String, name: String)
    func productFromSubCategory(id: String, name: String)
    func productListFromSearchQuery()
}

extension AlgoliaSearchViewModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDataCell", for: indexPath) as! SearchDataCell
        
        cell.lblPrice.text = modelData[indexPath.row].price?.sar?.defaultFormated
        cell.lblProductTitle.text = Defaults.language == "ar" ? modelData[indexPath.row].name?.ar ?? "" : modelData[indexPath.row].name?.en ?? ""
        cell.imgProduct.setImage(fromURL: modelData[indexPath.row].imageURL ?? "", placeholder: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.productFromCategory(id: modelData[indexPath.row].objectID ?? "", name: Defaults.language == "ar" ? modelData[indexPath.row].name?.ar ?? "" : modelData[indexPath.row].name?.en ?? "")
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if modelData.count > 0{
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewAllProductsFooterView.identifier) as? ViewAllProductsFooterView
            footerView?.contentView.backgroundColor = UIColor.white
            footerView?.lbl.text = "See products in all departments".localized + " (\(totalDataCount))"
            footerView?.btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFooter)))
          //  footerView?.btn.setTitle("See products in all departments".localized + "(\(totalDataCount))", for: .normal)
        return footerView
        }else{
            return nil
        }
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let containerView = UIView()
//        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFooter)))
//        containerView.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 245/255, alpha: 1)
//        if modelData.count > 0{
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40.0))
//        let attrs1 = [NSAttributedString.Key.font : UIFont.mySystemFont(ofSize: 17)]
//        let attrs2 = [NSAttributedString.Key.font : UIFont.myBoldSystemFont(ofSize: 17)]
//            let attributedString1 = NSMutableAttributedString(string:"\("See products in".localized) ", attributes:attrs1 as [NSAttributedString.Key : Any])
//
//            let attributedString2 = NSMutableAttributedString(string:"\("all departments".localized) ", attributes:attrs2 as [NSAttributedString.Key : Any])
//        print("DATA COunt ->1",totalDataCount)
//        let attributedString3 = NSMutableAttributedString(string:"(\(totalDataCount))", attributes:attrs1 as [NSAttributedString.Key : Any])
//        attributedString1.append(attributedString2)
//        attributedString1.append(attributedString3)
//        label.attributedText = attributedString1
//            containerView.addSubview(label)
//            label.textColor = .black
//            label.textAlignment = .center
//            containerView.isHidden = false
//            return containerView
//
//        }else{
//            containerView.isHidden = true
//        }
//        return nil
//
//}
    
    @objc private func didTapFooter() {
        delegate?.productListFromSearchQuery()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { modelData.count > 0 ? 64 : 0}
}
