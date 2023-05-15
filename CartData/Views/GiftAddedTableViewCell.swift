//
//  GiftAddedTableViewCell.swift
//  UnitedPharmacy
//
//  Created by Pushkar Yadav on 14/02/2023.
//

import UIKit

class GiftAddedTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var delegate:SendRemoveCodeDelegate?
    var giftCardList = [GiftData](){
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            tableViewHeightConstraint.constant = CGFloat(giftCardList.count * 45)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(cellType: GiftCodeTableViewCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension GiftAddedTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giftCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCodeTableViewCell", for: indexPath)as? GiftCodeTableViewCell {
            cell.selectionStyle = .none
            cell.lblCode.text = giftCardList[indexPath.row].code ?? ""
            cell.btnRemove.addTapGestureRecognizer {
            self.delegate?.codeRemove(code: cell.lblCode.text ?? "")
            
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

protocol SendRemoveCodeDelegate: AnyObject {
    func codeRemove(code:String)
}
