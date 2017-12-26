//
//  OperatorTableViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
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

    var selectedOperator: Operator = Operator.combineLatest {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let _searchController = UISearchController(searchResultsController: nil)
    private var _filteredSections = [Section]()
    
    private let _sections = [
        Section(
            name: "Combining",
            rows: [.combineLatest, .concat, .merge, .startWith, .switchLatest, .withLatestFrom, .zip]
        ),
        Section(
            name: "Conditional",
            rows: [.amb, .skipUntil, .skipWhile, .skipWhileWithIndex, .takeUntil, .takeWhile, .takeWhileWithIndex]
        ),
        Section(
            name: "Creating",
            rows: [.empty, .interval, .just, .never, .of, .repeatElement, .throw, .timer]
        ),
        Section(
            name: "Error",
            rows: [.catchError, .catchErrorJustReturn, .retry]
        ),
        Section(
            name: "Filtering",
            rows: [.debounce, .distinctUntilChanged, .elementAt, .filter, .ignoreElements, .sample, .single, .skip, .skipDuration, .take, .takeDuration, .takeLast, .throttle]
        ),
        Section(
            name: "Mathematical",
            rows: [.reduce]
        ),
        Section(
            name: "Transforming",
            rows: [.buffer, .delaySubscription, .flatMap, .flatMapFirst, .flatMapLatest, .map, .mapWithIndex, .scan, .toArray]
        ),
        Section(
            name: "Utility",
            rows: [.timeout]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Operators"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(OperatorsTableViewController.openHelpView))
        
        _searchController.searchResultsUpdater = self
        _searchController.obscuresBackgroundDuringPresentation = false
        _searchController.searchBar.searchBarStyle = .minimal
        
        definesPresentationContext = true
        
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.searchController = _searchController
            tableView.tableHeaderView = UIView()
        } else {
            _searchController.hidesNavigationBarDuringPresentation = false
            _searchController.searchBar.backgroundColor = UIColor.white
            tableView.tableHeaderView = _searchController.searchBar
        }
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OperatorCell")
        
        tableView.rx
            .itemSelected
            .map(_rowAtIndexPath)
            .subscribe(onNext: { [unowned self] op in self.openOperator(op) })
            .disposed(by: _disposeBag)
        
        // Check for force touch feature, and add force touch/previewing capability.
        if traitCollection.forceTouchCapability == .available {
            /*  
                Register for `UIViewControllerPreviewingDelegate` to enable
                "Peek" and "Pop".
                (see: MasterViewController+UIViewControllerPreviewing.swift)

                The view controller will be automatically unregistered when it is
                deallocated.
            */
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    func openOperator(_ op: Operator) {
        selectedOperator = op
        let viewController = OperatorViewController(rxOperator: selectedOperator)
        showDetailViewController(viewController, sender: nil)
    }
    
    @objc func openHelpView() {
        let helpController = HelpViewController()
        present(helpController, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
    private var _activeSections: [Section] {
        get { return isSearchActive() ? _filteredSections : _sections }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return _activeSections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = _activeSections[section]
        return sec.name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _activeSections[section].rows.count
    }
    
    fileprivate func _rowAtIndexPath(_ indexPath: IndexPath) -> Operator {
        let section = _activeSections[indexPath.section]
        return section.rows[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let op = _rowAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperatorCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = op.description
        cell.accessoryType = op == selectedOperator ? .checkmark : .none

        return cell
    }
    
//    MARK: - Filtering Sections
    
    private func filterSectionsWithText(text: String) {
        _filteredSections.removeAll()
        
        _sections.forEach({ section in
            let results = section.rows.filter({ row in
                row.description.range(of: text, options: String.CompareOptions.caseInsensitive) != nil
                
            })
            if results.count > 0 {
                _filteredSections.append(Section(name: section.name, rows: results))
            }
        })
    }
    
//    MARK: - UISearchResultsUpdating
    
    func isSearchActive() -> Bool {
        return _searchController.isActive && _searchController.searchBar.text != ""
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            filterSectionsWithText(text: searchString)
        }
        tableView.reloadData()
    }
    
    func focusSearch() {
        presentingViewController?.dismiss(animated: false, completion: nil)
        _searchController.searchBar.becomeFirstResponder()
    }
    
//    MARK: UIContentContainer
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        _searchController.isActive = false
    }
}

extension OperatorsTableViewController: UIViewControllerPreviewingDelegate {
    /// Create a previewing view controller to be shown at "Peek".
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // Obtain the index path and the cell that was pressed.
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath)
        else { return nil }
        
        selectedOperator = _rowAtIndexPath(indexPath)
        
        // Create a detail view controller and set its properties.
        let detailController = OperatorViewController(rxOperator:selectedOperator)
        
        // Set the source rect to the cell frame, so surrounding elements are blurred.
        previewingContext.sourceRect = cell.frame
        
        return detailController
    }
    
    /// Present the view controller for the "Pop" action.
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // Reuse the "Peek" view controller for presentation.
        showDetailViewController(viewControllerToCommit, sender: self)
    }
}
