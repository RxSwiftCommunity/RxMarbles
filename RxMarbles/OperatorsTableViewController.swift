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

class OperatorsTableViewController: UITableViewController, UISearchResultsUpdating {
    private let _disposeBag = DisposeBag()

    var selectedOperator = Operator.Delay
    private let _searchController = UISearchController(searchResultsController: nil)
    private var _filteredSections = [Section]()

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
        
        _searchController.searchResultsUpdater = self
        _searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = _searchController.searchBar
        
        title = "Operators"
        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "OperatorCell")
        
        tableView.rx_itemSelected
            .map(_rowAtIndexPath)
            .subscribeNext { op in
                self.selectedOperator = op
                self.tableView.reloadData()
                let viewController = ViewController()
                viewController.currentOperator = self.selectedOperator
                self.showDetailViewController(viewController, sender: nil)
            }
        .addDisposableTo(_disposeBag)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isSearchActive() {
            return _filteredSections.count
        }
        return _sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = isSearchActive() ? _filteredSections[section] : _sections[section]
        return sec.name
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive() ? _filteredSections[section].rows.count : _sections[section].rows.count
    }
    
    private func _rowAtIndexPath(indexPath: NSIndexPath) -> Operator {
        let section = isSearchActive() ? _filteredSections[indexPath.section] : _sections[indexPath.section]
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
//    MARK: - Filtering Sections
    
    private func filterSectionsWithText(text: String) {
        _filteredSections.removeAll()
        _sections.forEach({ section in
            let results = section.rows.filter({ row in
                row.description.lowercaseString.containsString(text.lowercaseString)
            })
            if results.count > 0 {
                _filteredSections.append(Section(name: section.name, rows: results))
            }
        })
    }
    
//    MARK: - UISearchResultsUpdating
    
    func isSearchActive() -> Bool {
        return (_searchController.active && _searchController.searchBar.text != "")
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            filterSectionsWithText(searchString)
        }
        tableView.reloadData()
    }
    
}
