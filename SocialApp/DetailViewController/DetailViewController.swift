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
    
    static let bottomViewHeight = (full: CGFloat(485.0), short: CGFloat(235.0))
    
    @IBOutlet weak var bottomDetailView: UIView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var bottomDetailViewHieghtConstraint: NSLayoutConstraint!
    
    var contentArray : [Person]!
    var personDetailVC : PersonDetailsViewController!
    var currentPageIndex : NSInteger = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        contentArray = configureData()
        self.view.layoutIfNeeded()
        configureBottomView(bottomDetailView)
        configureCollectionView(galleryCollectionView)
        personDetailVC = configureDetailViewController() as! PersonDetailsViewController
        addChildVC(personDetailVC)
        personDetailVC.configureWithPerson(contentArray[0], withAnimation: false)
    }

    //MARK: Configure Data
    
    func configureData() -> [Person] {
        let imageData = ["Image1","Image2","Image3"]
        let userName = ["Iron Man","Dhanush","Deepika Padukone"]
        let description = ["Superhero","Actor","Actress"]
        let followersCount = [111,222,333]
        let followingCount = [611,822,533]
        let postsCount = [11,52,33]
        var contentArray = [Person]()
        for index in 0...2 {
            let person = Person()
            person.imageName = imageData[index]
            person.personDescription = description[index]
            person.name = userName[index]
            person.followersCount = followersCount[index]
            person.followingCount = followingCount[index]
            person.postsCount = postsCount[index]
            contentArray.append(person)
        }
        
        return contentArray
    }
    //MARK: View Config
    
    func configureBottomView(_ bottomView:UIView) {
        bottomDetailViewHieghtConstraint.constant = DetailViewController.bottomViewHeight.short
        self.view.layoutIfNeeded()
        
        //Swipe gesture
        let upSwipeGesture = UISwipeGestureRecognizer.init(target: self, action:#selector(bottomViewAnimated(gesture:)))
        upSwipeGesture.direction = .up
        bottomView.addGestureRecognizer(upSwipeGesture)

        let downSwipeGesture = UISwipeGestureRecognizer.init(target: self, action:#selector(bottomViewAnimated(gesture:)))
        downSwipeGesture.direction = .down
        bottomView.addGestureRecognizer(downSwipeGesture)
        
        //Pan gesture
//        let panGesture = UIPanGestureRecognizer.init(target: self, action:#selector(bottomViewAnimatedWithPan(gesture:)))
//        bottomView.addGestureRecognizer(panGesture)
//        panGesture.require(toFail: upSwipeGesture)
//        panGesture.require(toFail: downSwipeGesture)
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
        let cellWidth: CGFloat = galleryCollectionView.frame.size.width
        let currentPageIndex = NSInteger(galleryCollectionView.contentOffset.x / cellWidth)
        if self.currentPageIndex != currentPageIndex {
            self.currentPageIndex = currentPageIndex
            let person = self.contentArray[currentPageIndex]
            personDetailVC.configureWithPerson(person, withAnimation: true)
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
        let childViewHeight = DetailViewController.bottomViewHeight.full
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
            UIView.animate(withDuration: 0.75, animations: {
                self.view.layoutIfNeeded()
            })
            animateCellWithScaleType(.scaleDown)
        }
        else {
            self.bottomDetailViewHieghtConstraint.constant = DetailViewController.bottomViewHeight.short
            animateCellWithScaleType(.scaleUp)
            UIView.animate(withDuration: 0.75, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func animateCellWithScaleType(_ scaleType:ScaleType) {
        let displayedCellIndexPath = IndexPath.init(item: currentPageIndex, section: 0)
        let galleryCell : GalleryCollectionViewCell = galleryCollectionView.cellForItem(at: displayedCellIndexPath) as! GalleryCollectionViewCell
        galleryCell.scaleUpCellWithScaleType(scaleType, animated: true)
    }
    
    @objc func bottomViewAnimatedWithPan(gesture:UIPanGestureRecognizer) {
//        let bottomView = gesture.view!
        let translationY : CGFloat = abs(gesture.translation(in: self.view).y)
        print("translationY : \(translationY)")
        var heightConstraint : CGFloat = self.bottomDetailViewHieghtConstraint.constant
        if gesture.state != .cancelled {
            if (heightConstraint + translationY) > DetailViewController.bottomViewHeight.short {
                if (heightConstraint + translationY) <= DetailViewController.bottomViewHeight.full {
                    heightConstraint += translationY
                    self.bottomDetailViewHieghtConstraint.constant = heightConstraint
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
    
    
}
