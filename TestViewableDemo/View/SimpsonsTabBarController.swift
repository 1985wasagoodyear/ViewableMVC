//
//  SimpsonsTabBarController.swift
//  SimpsonsViewer
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit
import ViewableMVC

class SimpsonsTabBarController: UITabBarController {

    var controller: ListController<SimpsonContainer>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The Simpsons"
        let url = URL(string: Constants.urlString)!
        controller = ListController<SimpsonContainer>(url: url,
                                                      navigationHandler: self)
        let listVC = ViewableVCFactory<SimpsonContainer>.makeListVC(controller)
        listVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured,
                                         tag: 0)
        let collectionVC = ViewableVCFactory<SimpsonContainer>.makeIconsVC(controller)
        collectionVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more,
                                               tag: 1)
        setViewControllers([listVC, collectionVC], animated: false)
    }

}

extension SimpsonsTabBarController: ListNavigationHandler {
    func go(to index: Int) {
        let name = controller.text(at: index) ?? "Name not found"
        let info = controller.info(at: index) ?? "Info not found"
        controller.image(at: index) { (im) in
            let vc = SimpsonsDetailViewController.newVC()
            vc.image = UIImage(data: im)
            vc.nameText = name
            vc.infoText = info
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
}
