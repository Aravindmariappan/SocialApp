//
//  ViewController.swift
//  SocialApp
//
//  Created by Aravind on 09/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bottomSelectionBar: UIView!
    @IBOutlet weak var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBottomView(bottomSelectionBar)
        self.view.layoutIfNeeded()
        let detailVC = configureDetailViewController()
        addChildVC(detailVC)
    }
    
    func configureBottomView(_ bottomView:UIView) {
        bottomView.layer.cornerRadius = 30.0
        bottomView.clipsToBounds = true
    }

    func addChildVC(_ viewController: UIViewController) {
        if !childViewControllers.contains(viewController) {
            addChildViewController(viewController)
            detailView.addSubview(viewController.view)
            addFit(toContainerConstarints: viewController.view, toParentView: detailView)
            self.view.layoutIfNeeded()
            detailView.layoutIfNeeded()
            viewController.view.isHidden = false
            viewController.didMove(toParentViewController: self)
        }
    }
    
    func configureDetailViewController() -> UIViewController {
        let vcIdentifier = DetailViewController.vcIdentifier
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: vcIdentifier)
        return detailVC!
    }
    
    //MARK: Helper
    
    func addFit(toContainerConstarints toView: UIView, toParentView parentView: UIView) {
        toView.translatesAutoresizingMaskIntoConstraints = false
        let viewsDictionary = ["toView": toView]
        let horizontalconstraintsArray = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[toView]-0-|", options: .alignAllLastBaseline, metrics: nil, views: viewsDictionary)
        let verticalconstraintsArray = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[toView]-0-|", options: .alignAllLastBaseline, metrics: nil, views: viewsDictionary)
        parentView.addConstraints(horizontalconstraintsArray)
        parentView.addConstraints(verticalconstraintsArray)
    }
    
}

