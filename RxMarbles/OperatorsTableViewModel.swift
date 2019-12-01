//
//  OperatorsTableViewModel.swift
//  RxMarbles
//
//  Created by Asaf Baibekov on 23/11/2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

import UIKit

class OperatorsTableViewModel {

	private(set) var numberOfSections: Int

	private let sections: [Section]
	private var filteredSections: [Section]

	init() {
		self.sections = [
			Section(name: "Combining", rows: [.combineLatest, .concat, .merge, .startWith, .switchLatest, .withLatestFrom, .zip]),
			Section(name: "Conditional", rows: [.amb, .skipUntil, .skipWhile, .skipWhileWithIndex, .takeUntil, .takeWhile, .takeWhileWithIndex]),
			Section(name: "Creating",rows: [.empty, .interval, .just, .never, .of, .repeatElement, .throw, .timer]),
			Section(name: "Error", rows: [.catchError, .catchErrorJustReturn, .retry]),
			Section(name: "Filtering", rows: [.debounce, .distinctUntilChanged, .elementAt, .filter, .ignoreElements, .sample, .single, .skip, .skipDuration, .take, .takeDuration, .takeLast, .throttle]),
			Section(name: "Mathematical", rows: [.reduce]),
			Section(name: "Transforming", rows: [.buffer, .delaySubscription, .flatMap, .flatMapFirst, .flatMapLatest, .map, .mapWithIndex, .scan, .toArray]),
			Section(name: "Utility", rows: [.timeout])
		]
		self.filteredSections = [Section]()
		self.numberOfSections = self.sections.count
	}
}

extension OperatorsTableViewModel {
	func titleForHeader(in section: Int) -> String? {
		return self.getModelSection(at: section).name
	}

	func numberOfRows(in section: Int) -> Int {
		return self.getModelSection(at: section).rows.count
	}
}

extension OperatorsTableViewModel {
	func updateSearchResults(for searchController: UISearchController) {
		guard searchController.isActive, let text = searchController.searchBar.text, !text.isEmpty else { self.reset(); return }
		self.filteredSections.removeAll()
		self.sections.forEach { section in
			let results = section.rows.filter { $0.description.range(of: text, options: String.CompareOptions.caseInsensitive) != nil }
			if !results.isEmpty {
				self.filteredSections.append(Section(name: section.name, rows: results))
			}
		}
		self.numberOfSections = self.filteredSections.isEmpty ? sections.count : filteredSections.count
	}

	func reset() {
		self.filteredSections.removeAll()
		self.numberOfSections = sections.count
	}
}

extension OperatorsTableViewModel {
	func getModelSection(at section: Int) -> Section {
		return (self.filteredSections.isEmpty ? self.sections : self.filteredSections)[section]
	}

	func getOperator(at indexPath: IndexPath) -> Operator {
		return getModelSection(at: indexPath.section).rows[indexPath.row]
	}
}
