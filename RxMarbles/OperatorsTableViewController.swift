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

class OperatorsTableViewController: UITableViewController {

	private let viewModel = OperatorsTableViewModel()

	private let _disposeBag = DisposeBag()

    var selectedOperator: Operator = Operator.combineLatest {
        didSet {
            tableView.reloadData()
        }
    }

	private lazy var _searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.searchBarStyle = .minimal
		return searchController
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("operators", comment: "")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("help_button_title", comment: ""),
            style: .plain,
            target: self,
            action: #selector(OperatorsTableViewController.openHelpView)
        )
        
        definesPresentationContext = true
        
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.searchController = _searchController
            tableView.tableHeaderView = UIView()
        } else {
            _searchController.hidesNavigationBarDuringPresentation = false
            _searchController.searchBar.backgroundColor = .white
            tableView.tableHeaderView = _searchController.searchBar
        }
        
        tableView.backgroundColor = Color.bgPrimary
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OperatorCell")
        
        tableView.rx
            .itemSelected
			.map(self.viewModel.getOperator)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
		return self.viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.viewModel.titleForHeader(in: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.numberOfRows(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let op = self.viewModel.getOperator(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperatorCell", for: indexPath)
        cell.textLabel?.text = op.description
        cell.accessoryType = op == selectedOperator ? .checkmark : .none
        cell.backgroundColor = Color.bgPrimary
        return cell
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

extension OperatorsTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		self.viewModel.updateSearchResults(for: searchController)
        tableView.reloadData()
    }
}

extension OperatorsTableViewController: UIViewControllerPreviewingDelegate {
    /// Create a previewing view controller to be shown at "Peek".
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // Obtain the index path and the cell that was pressed.
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
		selectedOperator = self.viewModel.getOperator(at: indexPath)
        
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
