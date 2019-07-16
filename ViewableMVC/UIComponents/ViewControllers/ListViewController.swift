//
//  ListViewController.swift
//  ViewableMVC
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

private let reuseID = "reuseID"

typealias TableViewDelegate = UITableViewDataSource & UITableViewDelegate

public class ListViewController<T:Viewable>: UIViewController, TableViewDelegate {
    
    private var tableView: UITableView! {
        didSet {
            tableView.setupToFill(superView: view)
            tableView.dataSource = self
            tableView.delegate = self
            let nib = UINib(nibName: "ListTableViewCell",
                            bundle: Bundle(for: ListTableViewCell.self)) 
            tableView.register(nib, forCellReuseIdentifier: reuseID)
        }
    }
    
    var controller: ListController<T>!
    
    override public func loadView() {
        super.loadView()
        tableView = UITableView(frame: view.frame,
                                style: .plain)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.fetchIfNeeded { [weak self] (loaded) in
            if loaded {
                self?.tableView.reloadData()
            }
            else {
                // present some error
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                 for: indexPath) as! ListTableViewCell
        if let text = controller.text(at: indexPath.row) {
            cell.listLabel.text = text
        }
        else {
            cell.listLabel.text = controller.settings.placeholderText
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller.didSelect(at: indexPath.row)
    }
    
}
