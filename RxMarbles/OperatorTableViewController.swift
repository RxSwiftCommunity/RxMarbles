//
//  OperatorTableViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Section {
    var name: String
    var rows: [Operator]
}

class OperatorTableViewController: UITableViewController {
    
    var selectedOperator: Operator?

    private let _sections = [
        Section(
            name: "Transforming",
            rows: [.Delay, .Map, .Scan, .FlatMap, .FlatMapFirst, .FlatMapLatest, .Buffer]
        ),
        Section(
            name: "Combining",
            rows: [.CombineLatest, .Concat, .Merge, .StartWith, .Zip]
        ),
        Section(
            name: "Filtering",
            rows: [.DistinctUntilChanged, .ElementAt, .Filter, .Debounce, .IgnoreElements, .Sample, .Skip, .Take, .TakeLast]
        ),
        Section(
            name: "Mathematical",
            rows: [.Reduce]
        ),
        Section(
            name: "Conditional",
            rows: [.Amb]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Operator"
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "OperatorCell")
        
        _ = tableView.rx_itemSelected
            .map { indexPath in
                return (indexPath, self._rowAtIndexPath(indexPath))
            }
            .subscribeNext { indexPath, op in
                self.selectedOperator = op
                self.tableView.reloadData()
                let viewController = ViewController()
                viewController._currentOperator = self.selectedOperator!
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    viewController.navigationItem.leftItemsSupplementBackButton = true
                    viewController.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem()
                    let navDetailController = UINavigationController(rootViewController: viewController)
                    self.splitViewController?.showDetailViewController(navDetailController, sender: nil)
                } else {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = _sections[section]
        return sec.name
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  _sections[section].rows.count
    }
    
    private func _rowAtIndexPath(indexPath: NSIndexPath) -> Operator {
        let section = _sections[indexPath.section]
        return section.rows[indexPath.row]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let op = _rowAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("OperatorCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = op.description
        
        if op == selectedOperator {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }

        return cell
    }
}
