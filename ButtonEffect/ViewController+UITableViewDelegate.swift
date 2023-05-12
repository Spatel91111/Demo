//
//  ViewController+UITableViewDelegate.swift
//  ButtonEffect
//
//  Created by Subhash Kimani on 12/05/23.
//

import UIKit

class ListingCell: UITableViewCell {
    
    @IBOutlet weak var imgCheckmark: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryTblList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListingCell.self)", for: indexPath) as! ListingCell
        let objList = self.aryTblList[indexPath.row]
        cell.imgCheckmark.image = objList.getCheckMarkImage()
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? ListingCell
        print("start clicked")
        self.aryTblList[indexPath.row].isChecked = !self.aryTblList[indexPath.row].isChecked
        cell?.imgCheckmark.image = self.aryTblList[indexPath.row].getCheckMarkImage()
        cell?.showAnimation(scale: 0.97, {
            print(" ->stop clicked")
        })
    }
}
