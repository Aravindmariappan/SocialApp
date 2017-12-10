//
//  PersonDeatilsViewController.swift
//  SocialApp
//
//  Created by Aravind on 09/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController {

    @IBOutlet weak var personName: UILabel!
    static let vcIdentifier = "peopleDetailVCIdentifier"

    var person : Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureWithPerson(_ person:Person, withAnimation animated:Bool) {
        self.person = person
        if animated == true {
            self.hideLabels(completion: { (completed) in
                if completed == true {
                    self.personName.text = person.name
                    self.showLabels()
                }
            })
        }
        else {
            personName.text = person.name
        }
    }
    
    //MARK: Animation Helper
    
    func hideLabels(completion: ((Bool) -> Swift.Void)? = nil) {
        var labelFrame = self.personName.frame
        labelFrame.origin.y += labelFrame.size.height/3
//        labelFrame.size.height = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.personName.alpha = 0.0
            self.personName.frame = labelFrame
            self.personName.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
        }, completion: { (completed) in
            completion!(true)
        })
        
//        var rotationAndPerspectiveTransform = CATransform3DIdentity
//        rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0
//        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(Double.pi * 0.6), 1.0, 0.0, 0.0)
//
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .transitionFlipFromTop, animations: {
//            self.personName.alpha = 0.0
//            self.personName.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
//            self.personName.layer.transform = rotationAndPerspectiveTransform
//        }, completion: { (completed) in
//            completion!(true)
//        })
    }
    
    func showLabels() {
        var labelFrame = self.personName.frame
//        labelFrame.size.height = 56.0
        labelFrame.origin.y -= 56.0/3
        UIView.animate(withDuration: 0.25) {
            self.personName.alpha = 1.0
            self.personName.frame = labelFrame
            self.personName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }

}
