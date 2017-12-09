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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureWithPerson(_ person:Person) {
        personName.text = person.name
        hideLabels()
    }
    
    //MARK: Animation Helper
    
    func hideLabels() {
        var labelFrame = self.personName.frame
        labelFrame.origin.y += labelFrame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.personName.alpha = 0.0
            self.personName.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)
        }, completion: { (completed) in
            self.showLabels()
        })
    }
    func showLabels() {
        var labelFrame = self.personName.frame
        labelFrame.origin.y -= labelFrame.size.height
        UIView.animate(withDuration: 0.25) {
            self.personName.alpha = 1.0
            self.personName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }

}
