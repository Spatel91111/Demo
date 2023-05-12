//
//  ViewController+UICollectionViewDelegate.swift
//  ButtonEffect
//
//  Created by Subhash Kimani on 12/05/23.
//

import UIKit

class PhotoListCC: UICollectionViewCell {
    @IBOutlet weak var imgCheckmark: UIImageView!
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.aryColList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotoListCC.self)", for: indexPath) as! PhotoListCC
        let objList = self.aryColList[indexPath.row]
        cell.imgCheckmark.image = objList.getCheckMarkImage()
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - 70.0) / 3.0
        return CGSize(width: size, height: size)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoListCC
        print("start clicked")
        self.aryColList[indexPath.row].isChecked = !self.aryColList[indexPath.row].isChecked
        cell?.imgCheckmark.image = self.aryColList[indexPath.row].getCheckMarkImage()
        cell?.showAnimation({
            print(" ->stop clicked")
        })
    }
}
