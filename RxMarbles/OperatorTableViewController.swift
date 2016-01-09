//
//  OperatorTableViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

class OperatorTableViewController: UITableViewController {
    
    var selectedOperator: NSDictionary!
    
    private let sections = [["id" : "Transforming", "title": NSLocalizedString("TRANSFORMING OPERATORS", comment: ""), "rows" : [
                                ["id" : "delay",    "title": NSLocalizedString("delay", comment: "")],
                                ["id" : "map",      "title": NSLocalizedString("map", comment: "")],
                                ["id" : "scan",     "title": NSLocalizedString("scan", comment: "")],
                                ["id" : "debounce", "title": NSLocalizedString("debounce", comment: "")]
                                ]],
                            ["id" : "Combining", "title": NSLocalizedString("COMBINING OPERATORS", comment: ""), "rows" : [
                                ["id" : "startWith",    "title": NSLocalizedString("startWith", comment: "")]
                                ]],
                            ["id" : "Filtering", "title": NSLocalizedString("FILTERING OPERATORS", comment: ""), "rows" : [
                                ["id" : "distinctUntilChanged",    "title": NSLocalizedString("distinctUntilChanged", comment: "")],
                                ["id" : "elementAt",    "title": NSLocalizedString("elementAt", comment: "")],
                                ["id" : "filter",    "title": NSLocalizedString("filter", comment: "")],
                                ["id" : "skip",    "title": NSLocalizedString("skip", comment: "")],
                                ["id" : "take",    "title": NSLocalizedString("take", comment: "")],
                                ["id" : "takeLast",    "title": NSLocalizedString("takeLast", comment: "")]
                            ]],
                            ["id" : "Mathematical", "title": NSLocalizedString("MATHEMATICAL OPERATORS", comment: ""), "rows" : [
                                ["id" : "reduce",    "title": NSLocalizedString("reduce", comment: "")]
                                ]]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "OperatorCell")
        self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 0.0, 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = sections[section]
        return sec["title"] as? String
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections[section]["rows"]?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = (section["rows"] as! NSArray)[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OperatorCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = row["title"] as? String
        
        if row == selectedOperator {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let section = sections[indexPath.section]
        let row = (section["rows"] as! NSArray)[indexPath.row] as! NSDictionary
        
        selectedOperator = row
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }

}
