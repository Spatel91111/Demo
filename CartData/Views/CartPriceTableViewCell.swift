//
/**
 Mobikul Single App
 @Category United Pharmacy
 @author United Pharmacy <support@United Pharmacy.com>
 FileName: CartPriceTableViewCell.swift
 Copyright (c) 2010-2018 United Pharmacy Software Private Limited (https://United Pharmacy.com)
 @license https://store.United Pharmacy.com/license.html ASL Licence
 @link https://store.United Pharmacy.com/license.html
 
 */

import UIKit

class CartPriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dropIcon: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceDetailsLabel: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: HeaderViewDelegate?
    var totalsData = [TotalsData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceDetailsLabel.text = "Order Summery".localized
       // orderTotalLabel.text = "Order Total".localized
        tableView.register(cellType: CartFormatTableViewCell.self)
        tableView.register(cellType: CartTotalPriceTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        // Initialization code
    }
    
    @objc private func didTapHeader() {
        if UserDefaults.fetch(key: Defaults.Key.customerToken.rawValue) != nil {
            delegate?.toggleSection(view: self, section: 5)
        }else{
            delegate?.toggleSection(view: self, section: 3)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: [TotalsData]! {
        didSet {
            self.totalsData = item
            tableViewHeight.constant = CGFloat(totalsData.count * 44)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
}

extension CartPriceTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == totalsData.count - 1 {
            if let cell: CartTotalPriceTableViewCell = tableView.dequeueReusableCell(with: CartTotalPriceTableViewCell.self, for: indexPath) {
                cell.item = totalsData[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if let cell: CartFormatTableViewCell = tableView.dequeueReusableCell(with: CartFormatTableViewCell.self, for: indexPath) {
                cell.item = totalsData[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        }
        
        
        return UITableViewCell()
    }
}
