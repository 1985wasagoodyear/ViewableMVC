//
//  SimpsonsDetailViewController.swift
//  SimpsonsViewer
//
//  Created by K Y on 7/2/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

class SimpsonsDetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    var image: UIImage?
    var nameText: String?
    var infoText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        nameLabel.text = nameText
        descLabel.text = infoText
        if let name = nameText {
            self.title = name.replacingOccurrences(of: " (The Simpsons)",
                                                   with: "")
        }
        else {
            self.title = "The Elusive Spider-Pig"
        }
    }
    
}

extension SimpsonsDetailViewController {
    static func newVC() -> SimpsonsDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SimpsonsDetailViewController") as! SimpsonsDetailViewController
    }
    
}
