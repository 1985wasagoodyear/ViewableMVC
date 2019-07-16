//
//  IconsViewController.swift
//  ViewableMVC
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

private let reuseID = "reuseID"

typealias CollectionViewDelegate = UICollectionViewDataSource & UICollectionViewDelegate

public class IconsViewController<T:Viewable>: UIViewController, CollectionViewDelegate {
    
    private var collectionView: UICollectionView! {
        didSet {
            collectionView.setupToFill(superView: view)
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
            let nib = UINib(nibName: "IconsCollectionViewCell",
                            bundle: Bundle(for: IconsCollectionViewCell.self))
            collectionView.register(nib, forCellWithReuseIdentifier: reuseID)
        }
    }
    
    weak var controller: ListController<T>!
    
    public override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        let config = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: config)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.fetchIfNeeded { [weak self] (loaded) in
            if loaded {
                self?.collectionView.reloadData()
            }
            else {
                // present error
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! IconsCollectionViewCell
        controller.image(at: indexPath.row) {
            cell.imageView.image = UIImage(data: $0)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.didSelect(at: indexPath.row)
    }
    
}
