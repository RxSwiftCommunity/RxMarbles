//
//  OperatorTableViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

struct Section {
    var name: String
    var rows: [Operator]
}

class OperatorTableViewController: UITableViewController {
    
    var selectedOperator: Operator?
    
   
    private let _sections = [
        Section(
            name: "Transforming",
            rows: [.Delay, .Map, .Scan, .Debounce, .FlatMap]
        ),
        Section(
            name: "Combining",
            rows: [.CombineLatest, .Concat, .StartWith, .Zip]
        ),
        Section(
            name: "Filtering",
            rows: [.DistinctUntilChanged, .ElementAt, .Filter, .IgnoreElements, .Sample, .Skip, .Take, .TakeLast]
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
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "OperatorCell")
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let op = _rowAtIndexPath(indexPath)
        selectedOperator = op
        navigationController?.popViewControllerAnimated(true)
    }

}
