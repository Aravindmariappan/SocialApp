//
//  DetailViewController.swift
//  SocialApp
//
//  Created by Aravind on 09/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static let vcIdentifier = "detailVCIdentifier"
    
    static let bottomViewHeight = (full: CGFloat(400.0), short: CGFloat(150.0))
    
    @IBOutlet weak var bottomDetailView: UIView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var bottomDetailViewHieghtConstraint: NSLayoutConstraint!
    
    var contentArray : [Person]!
    var personDetailVC : PersonDetailsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentArray = configureData()
        self.view.layoutIfNeeded()
        configureBottomView(bottomDetailView)
        configureCollectionView(galleryCollectionView)
        personDetailVC = configureDetailViewController() as! PersonDetailsViewController
        addChildVC(personDetailVC)
        personDetailVC.configureWithPerson(contentArray[0])
    }

    //MARK: Configure Data
    
    func configureData() -> [Person] {
        let imageData = ["Image1","Image2","Image3"]
        let userName = ["Iron Man","Dhanush","Deepika Padukone"]
        let followersCount = [111,222,333]
        let followingCount = [611,822,533]
        let postsCount = [11,52,33]
        var contentArray = [Person]()
        for index in 0...2 {
            let person = Person()
            person.imageName = imageData[index];
            person.name = userName[index];
            person.followersCount = followersCount[index];
            person.followingCount = followingCount[index];
            person.postsCount = postsCount[index];
            contentArray.append(person)
        }
        
        return contentArray
    }
    //MARK: View Config
    
    func configureBottomView(_ bottomView:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = bottomView.frame
        rectShape.position = bottomView.center
        rectShape.path = UIBezierPath(roundedRect: bottomView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        bottomView.layer.mask = rectShape
        bottomView.clipsToBounds = true
        
        //Pan gesture
        let upSwipeGesture = UISwipeGestureRecognizer.init(target: self, action:#selector(bottomViewAnimated(gesture:)))
        upSwipeGesture.direction = .up
        bottomView.addGestureRecognizer(upSwipeGesture)
        
        let downSwipeGesture = UISwipeGestureRecognizer.init(target: self, action:#selector(bottomViewAnimated(gesture:)))
        downSwipeGesture.direction = .down
        bottomView.addGestureRecognizer(downSwipeGesture)
    }
    
    func configureCollectionView(_ collectionView:UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: GalleryCollectionViewCell.cellIdentifier)
    }
    
    //MARK: Collection View DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GalleryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.configureWithPerson(contentArray[indexPath.item], withScaleType: .scaleUp)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    //MARK: Scroll Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in galleryCollectionView.visibleCells {
            let indexPath: IndexPath? = galleryCollectionView.indexPath(for: cell)
            let person = self.contentArray[(indexPath?.row)!]
            personDetailVC.configureWithPerson(person)
        }
    }
    //MARK: People Detail VC
    
    func addChildVC(_ viewController: UIViewController) {
        if !childViewControllers.contains(viewController) {
            addChildViewController(viewController)
            bottomDetailView.addSubview(viewController.view)
            addFit(toContainerConstarints: viewController.view, toParentView: bottomDetailView)
            viewController.view.isHidden = false
            viewController.didMove(toParentViewController: self)
        }
    }
    
    func configureDetailViewController() -> UIViewController {
        let vcIdentifier = PersonDetailsViewController.vcIdentifier
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: vcIdentifier)
        
        return detailVC!
    }

    //MARK: Helper
    
    func addFit(toContainerConstarints toView: UIView, toParentView parentView: UIView) {
        toView.translatesAutoresizingMaskIntoConstraints = false
        let childViewHeight = 400
        let metrics = ["childViewHeight":childViewHeight]
        let viewsDictionary = ["toView": toView]
        let horizontalconstraintsArray = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[toView]-0-|", options: .alignAllLastBaseline, metrics: nil, views: viewsDictionary)
        let verticalconstraintsArray = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[toView(childViewHeight)]", options: .alignAllLastBaseline, metrics: metrics, views: viewsDictionary)
        parentView.addConstraints(horizontalconstraintsArray)
        parentView.addConstraints(verticalconstraintsArray)
    }

    //MARK: Animation Helper
    
    @objc func bottomViewAnimated(gesture:UISwipeGestureRecognizer) {
        let swipeDirection = gesture.direction
        if swipeDirection == .up {
            self.bottomDetailViewHieghtConstraint.constant = DetailViewController.bottomViewHeight.full
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
            })
            animateCellWithScaleType(.scaleDown)
        }
        else {
            self.bottomDetailViewHieghtConstraint.constant = DetailViewController.bottomViewHeight.short
            animateCellWithScaleType(.scaleUp)
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func animateCellWithScaleType(_ scaleType:ScaleType) {
        let displayedCellIndexPath = currentDisplayedIndexPath()
        let galleryCell : GalleryCollectionViewCell = galleryCollectionView.cellForItem(at: displayedCellIndexPath) as! GalleryCollectionViewCell
        galleryCell.scaleUpCellWithScaleType(scaleType, animated: true)
    }
    
    func currentDisplayedIndexPath() -> IndexPath {
        var visibleRect: CGRect = CGRect()
        visibleRect.origin = (galleryCollectionView?.contentOffset)!
        visibleRect.size = (galleryCollectionView?.bounds.size)!
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = (galleryCollectionView?.indexPathForItem(at: visiblePoint))!
        
        return visibleIndexPath
    }
}
