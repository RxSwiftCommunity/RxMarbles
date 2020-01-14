//
//  ViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices
import Device

class OperatorViewController: UIViewController {

    private var _disposeBag = DisposeBag()
    
    private var _currentActivity: NSUserActivity?
    
    private let _scrollView = UIScrollView()
    private let _sceneView: SceneView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
    
    init(rxOperator: Operator) {
        _sceneView = SceneView(rxOperator: rxOperator, frame: CGRect.zero)
        
        super.init(nibName: nil, bundle: nil)
        
        title = rxOperator.description
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        _sceneView.editing = editing
        
        navigationItem.setHidesBackButton(editing, animated: animated)
        navigationItem.rightBarButtonItems = _rightButtonItems()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.rightBarButtonItems = _rightButtonItems()
        
        // Prevent interactivePopGestureRecognizer if we are in navigation controller
        guard
            let requireRecognizerToFail = navigationController?
                .interactivePopGestureRecognizer?
                .require
        else { return }
       
        [
            _sceneView.sourceSequenceA?.longPressGestureRecorgnizer,
            _sceneView.sourceSequenceB?.longPressGestureRecorgnizer
        ]
        .compactMap { $0 }
        .forEach(requireRecognizerToFail)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .always;
        }

        view.backgroundColor = Color.bgPrimary
        
        view.addSubview(_scrollView)
        _scrollView.addSubview(_sceneView)
        
        _currentActivity = _sceneView.rxOperator.userActivity()
        
        Notifications.setEventView.rx().subscribe(onNext: {
            [unowned self] (notification: Notification) in self._setEventView(notification)
        }).disposed(by: _disposeBag)
        
        Notifications.addEvent.rx().subscribe(onNext: {
            [unowned self] (notification: Notification) -> Void in self._addEventToTimeline(notification)
        }).disposed(by: _disposeBag)
        
        Notifications.openOperatorDescription.rx().subscribe(onNext: {
            [unowned self] (notification: Notification) -> Void in self._openOperatorDocumentation(notification)
        }).disposed(by: _disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _scrollView.frame = view.bounds
        _sceneView.frame = CGRect(x: 20, y: 0, width: _scrollView.bounds.size.width - 40, height: _scrollView.bounds.height)
        _sceneView.layoutSubviews()
        
        var height: CGFloat = 70.0
        height += _sceneView.resultSequence.bounds.height
        if !_sceneView.rxOperator.withoutTimelines {
            height += _sceneView.sourceSequenceA.bounds.height
            if _sceneView.rxOperator.multiTimelines {
                height += _sceneView.sourceSequenceB.bounds.height
            }
        }
        height += _sceneView.rxOperatorText.bounds.height
        _sceneView.frame.size.height = height
        _scrollView.contentSize = _sceneView.bounds.size
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _currentActivity?.becomeCurrent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _currentActivity?.resignCurrent()
    }
    
//    MARK: Button Items
    
    private func _rightButtonItems() -> [UIBarButtonItem] {
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(OperatorViewController.share(_:)))
        
        if _sceneView.rxOperator.withoutTimelines {
            return [shareButtonItem]
        }
        return isEditing ? [editButtonItem] : [editButtonItem, shareButtonItem]
    }
    
//    MARK: Navigation
    
    private func _openOperatorDocumentation(_ notification: Notification) {
        let safariViewController = SFSafariViewController(url: _sceneView.rxOperator.url)
        present(safariViewController, animated: true, completion: nil)
    }
    
//    MARK: Snapshot
    
    private func _makeSnapshot() -> UIImage {
        let size = CGSize(width: _scrollView.bounds.width, height: _sceneView.bounds.size.height - _sceneView.rxOperatorText.bounds.height)
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let c = UIGraphicsGetCurrentContext()!
        
        Color.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        _scrollView.layer.render(in: c)
        
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
    
	@objc private dynamic func share(_ sender: AnyObject?) {
		let activity = UIActivityViewController(activityItems: [_makeSnapshot()], applicationActivities: nil)
		activity.excludedActivityTypes = [UIActivity.ActivityType.assignToContact, .print]
		guard let rootViewController = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else { return }
		if Device.type() == .iPad || Device.type() == .simulator {
			activity.popoverPresentationController?.sourceView = view
			if let shareButtonItem = sender {
				activity.popoverPresentationController?.barButtonItem = shareButtonItem as? UIBarButtonItem
			}
		}
		rootViewController.present(activity, animated: true, completion: nil)
	}
    
//    MARK: Alert controllers
    
    private func _addEventToTimeline(_ notification: Notification) {
        guard
            let sender = notification.object as? UIButton,
            let sequence = sender.superview as? SourceSequenceView
        else { return }
        
        var time = Int(sequence.bounds.size.width / 2.0)
        
        let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .actionSheet)
       
        let sceneView = _sceneView
        let nextAction = UIAlertAction(title: "Next", style: .default) { _ in
            let e = RxMarbles.next(time, String(arc4random() % 9 + 1), Color.nextRandom, (sequence == sceneView.sourceSequenceA) ? .circle : .rect)
            sequence.addEventToTimeline(e, animator: sequence.animator)
            sceneView.resultSequence.subject.onNext(())
        }
        let completedAction = UIAlertAction(title: "Completed", style: .default) { _ in
            time = sequence.maxEventTime() > 850 ? sequence.maxEventTime() + 30 : 850
            let e = completed(time)
            sequence.addEventToTimeline(e, animator: sequence.animator)
            sceneView.resultSequence.subject.onNext(())
        }
        let errorAction = UIAlertAction(title: "Error", style: .default) { _ in
            let e = error(500)
            sequence.addEventToTimeline(e, animator: sequence.animator)
            sceneView.resultSequence.subject.onNext(())
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        elementSelector.addAction(nextAction)
        let sourceEvents: [EventView] = sequence.sourceEvents
        if !sourceEvents.contains(where: { $0.isCompleted }) {
            elementSelector.addAction(completedAction)
        }
        elementSelector.addAction(errorAction)
        elementSelector.addAction(cancelAction)
        
        elementSelector.popoverPresentationController?.sourceRect = sender.frame
        elementSelector.popoverPresentationController?.sourceView = sender.superview
        
        present(elementSelector, animated: true, completion: nil)
    }

    private func _setEventView(_ notification: Notification) {
        guard let eventView = notification.object as? EventView else { return }
        
        let settingsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if eventView.isNext {
            let contentViewController = UIViewController()
            contentViewController.preferredContentSize = CGSize(width: 200.0, height: 90.0)
            
            let preview = EventView(recorded: eventView.recorded)
            preview.center = CGPoint(x: 100.0, y: 25.0)
            contentViewController.view.addSubview(preview)
            
            let colorsSegmentedControl = _contentViewColorsSegmentedControl(eventView)
            contentViewController.view.addSubview(colorsSegmentedControl)
            
            settingsAlertController.setValue(contentViewController, forKey: "contentViewController")
            settingsAlertController.addTextField { textField in
                if let text = eventView.recorded.value.element?.value {
                    textField.text = text
                }
            }
            settingsAlertController.addAction(_saveAction(preview, oldEventView: eventView))
            
            Observable
                .combineLatest(settingsAlertController.textFields!.first!.rx.textInput.text.orEmpty, colorsSegmentedControl.rx.value, resultSelector: { text, segment in
                    return (text, segment)
                })
                .subscribe(onNext: { text, segment in
                    self._updatePreviewEventView(preview, params: (color: Color.nextAll[segment], value: text))
                })
                .disposed(by: _disposeBag)
        } else {
            settingsAlertController.message = "Delete event?"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        settingsAlertController.addAction(_deleteAction(eventView: eventView))
        settingsAlertController.addAction(cancelAction)
        present(settingsAlertController, animated: true, completion: nil)
    }
    
    private func _contentViewColorsSegmentedControl(_ eventView: EventView) -> UISegmentedControl {
        let colors = Color.nextAll
        let currentColor = eventView.recorded.value.element?.color
        let colorsSegment = UISegmentedControl(items: colors.map { _ in "" } )
        colorsSegment.tintColor = .clear
        colorsSegment.frame = CGRect(x: 0.0, y: 50.0, width: 200.0, height: 30.0)
        
        zip(colorsSegment.subviews, colors).forEach { v, color in v.backgroundColor = color }
        
        colorsSegment.selectedSegmentIndex = colors.firstIndex(of: currentColor!)!
        return colorsSegment
    }
    
    private func _saveAction(_ newEventView: EventView, oldEventView: EventView) -> UIAlertAction {
        return UIAlertAction(title: "Save", style: .default) { _ in
            guard let index = oldEventView.sequenceView?.sourceEvents.firstIndex(of: oldEventView)
            else { return }
            
            oldEventView.sequenceView?.sourceEvents.remove(at: index)
            oldEventView.sequenceView?.addEventToTimeline(newEventView.recorded, animator: oldEventView.sequenceView?.animator)
            oldEventView.removeFromSuperview()
            self._sceneView.resultSequence.subject.onNext(())
        }
    }
    
    private func _deleteAction(eventView: EventView) -> UIAlertAction {
        return UIAlertAction(title: "Delete", style: .destructive) { _ in
            eventView.animator?.removeAllBehaviors()
            eventView.animator?.addBehavior(eventView.gravity!)
            eventView.animator?.addBehavior(eventView.removeBehavior!)
        }
    }
    
    private func _updatePreviewEventView(_ preview: EventView, params: (color: UIColor, value: String)) {
        let time = preview.recorded.time
        let shape = preview.recorded.value.element?.shape
        let event = Event.next(ColoredType(value: params.value, color: params.color, shape: shape!))
        
        preview.recorded = RecordedType(time: time, value: event)
        preview.label.text = params.value
        preview.setColorOnPreview(color: params.color)
    }
    
//    MARK: Preview Actions
    override var previewActionItems: [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "Share", style: .default) { _, _ in
            self.share(nil)
        }
        return [shareAction]
    }
}
