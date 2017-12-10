//
//  GalleryCollectionViewCell.swift
//  SocialApp
//
//  Created by Aravind on 09/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

import UIKit

enum ScaleType {
    case scaleUp
    case scaleDown
}

class GalleryCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "GalleryCellIdentifier"

    @IBOutlet weak var galleryImageView: UIImageView!
    
    var scaleType : ScaleType = .scaleDown
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWithPerson(_ person:Person, withScaleType scaleType:ScaleType) {
        self.scaleType = scaleType
        galleryImageView.image = UIImage(named: person.imageName)
        scaleUpCellWithScaleType(self.scaleType, animated: false)
    }
    
    func scaleUpCellWithScaleType(_ scaleType:ScaleType, animated animate:Bool) {
        var xScale = CGFloat(1.00)
        var yScale = CGFloat(1.00)
        let animationDuration = animate == true ? 0.75 : 0.00
        if scaleType == .scaleUp {
            xScale = 1.25
            yScale = 1.25
        }
        UIView.animate(withDuration: animationDuration) {
            self.galleryImageView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
        }
    }
}
