//
//  PersonDeatilsViewController.swift
//  SocialApp
//
//  Created by Aravind on 09/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personDescription: UILabel!
    
    @IBOutlet var animatedViews: [UIView]!
    
    static let vcIdentifier = "peopleDetailVCIdentifier"

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var curvedTopView: UIView!
    var person : Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView(collectionView)
        configureCurvedView(curvedTopView)
    }
    
    func configureCurvedView(_ view:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        view.layer.mask = rectShape
        view.clipsToBounds = true
    }
    
    //MARK: Collection View
    
    func configureCollectionView(_ collectionView:UICollectionView) {
        collectionView.dataSource = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageArray = ["GalleryImage1", "GalleryImage2", "GalleryImage3"]
        let thumbnailCell : ThumbnailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCellIdentifier", for: indexPath) as! ThumbnailCollectionViewCell
        let imageIndex = indexPath.row % 3
        thumbnailCell.thumbnailImageView.image = UIImage.init(named: imageArray[imageIndex])
        return thumbnailCell
    }
    
    //MARK:
    
    func configureWithPerson(_ person:Person, withAnimation animated:Bool) {
        self.person = person
        if animated == true {
            for view in animatedViews {
                view.hideLabels(completion: { (height) in
                    if (view == self.personName) {
                        self.personName.text = person.name
                    }
                    else if (view == self.personDescription) {
                        self.personDescription.text = person.personDescription
                    }
                    view.showLabels(withOriginalHeight: height)
                })
            }
        }
        else {
            personName.text = person.name
            personDescription.text = person.personDescription
        }
    }
}

extension UIView {

    func hideLabels(completion: ((CGFloat) -> Swift.Void)? = nil) {
        var labelFrame = self.frame
        let heightBeforeChange = self.frame.size.height
        labelFrame.origin.y += labelFrame.size.height/3
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
            self.frame = labelFrame
            self.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
        }, completion: { (completed) in
            completion!(heightBeforeChange)
        })
    }
    
    func showLabels(withOriginalHeight height:CGFloat) {
        var labelFrame = self.frame
        labelFrame.origin.y -= height/3
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
            self.frame = labelFrame
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
