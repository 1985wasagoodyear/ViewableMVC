//
//  ViewableVCFactory.swift
//  ViewableMVC
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

public class ViewableVCFactory<T: Viewable> {
    
    public class func makeListVC(_ controller: ListController<T>) -> ListViewController<T> {
        let vc = ListViewController<T>()
        vc.controller = controller
        return vc
    }
    
    public class func makeIconsVC(_ controller: ListController<T>) -> IconsViewController<T> {
        let vc = IconsViewController<T>()
        vc.controller = controller
        return vc
    }
    
    
}
