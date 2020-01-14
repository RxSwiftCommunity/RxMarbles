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

    private var disposeBag = DisposeBag()
    
    private var currentActivity: NSUserActivity?
    
    private let scrollView = UIScrollView()
    private let sceneView: SceneView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
    
    init(rxOperator: Operator) {
        sceneView = SceneView(rxOperator: rxOperator, frame: CGRect.zero)
        
        super.init(nibName: nil, bundle: nil)
        
        title = rxOperator.description
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        sceneView.editing = editing
        
        navigationItem.setHidesBackButton(editing, animated: animated)
        navigationItem.rightBarButtonItems = rightButtonItems()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.rightBarButtonItems = rightButtonItems()
        
        // Prevent interactivePopGestureRecognizer if we are in navigation controller
        guard
            let requireRecognizerToFail = navigationController?
                .interactivePopGestureRecognizer?
                .require
        else { return }
       
        [
            sceneView.sourceSequenceA?.longPressGestureRecorgnizer,
            sceneView.sourceSequenceB?.longPressGestureRecorgnizer
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(sceneView)
        
        currentActivity = sceneView.rxOperator.userActivity()
        
        Notifications.setEventView.rx().subscribe(onNext: {
            [unowned self] (notification: Notification) in self.setEventView(notification)
        }).disposed(by: disposeBag)
        
        Notifications.addEvent.rx().subscribe(onNext: {
            [unowned self] (notification: Notification) -> Void in self.addEventToTimeline(notification)
        }).disposed(by: disposeBag)
        
        Notifications.openOperatorDescription.rx().subscribe(onNext: {
            [unowned self] (notification: Notification) -> Void in self.openOperatorDocumentation(notification)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        sceneView.frame = CGRect(x: 20, y: 0, width: scrollView.bounds.size.width - 40, height: scrollView.bounds.height)
        sceneView.layoutSubviews()
        
        var height: CGFloat = 70.0
        height += sceneView.resultSequence.bounds.height
        if !sceneView.rxOperator.withoutTimelines {
            height += sceneView.sourceSequenceA.bounds.height
            if sceneView.rxOperator.multiTimelines {
                height += sceneView.sourceSequenceB.bounds.height
            }
        }
        height += sceneView.rxOperatorText.bounds.height
        sceneView.frame.size.height = height
        scrollView.contentSize = sceneView.bounds.size
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentActivity?.becomeCurrent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        currentActivity?.resignCurrent()
    }
    
//    MARK: Button Items
    
    private func rightButtonItems() -> [UIBarButtonItem] {
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(OperatorViewController.share(_:)))
        
        if sceneView.rxOperator.withoutTimelines {
            return [shareButtonItem]
        }
        return isEditing ? [editButtonItem] : [editButtonItem, shareButtonItem]
    }
    
//    MARK: Navigation
    
    private func openOperatorDocumentation(_ notification: Notification) {
        let safariViewController = SFSafariViewController(url: sceneView.rxOperator.url)
        present(safariViewController, animated: true, completion: nil)
    }
    
//    MARK: Snapshot
    
    private func makeSnapshot() -> UIImage {
        let size = CGSize(width: scrollView.bounds.width, height: sceneView.bounds.size.height - sceneView.rxOperatorText.bounds.height)
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let c = UIGraphicsGetCurrentContext()!
        
        Color.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        scrollView.layer.render(in: c)
        
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
    
	@objc private dynamic func share(_ sender: AnyObject?) {
		let activity = UIActivityViewController(activityItems: [makeSnapshot()], applicationActivities: nil)
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
    
    private func addEventToTimeline(_ notification: Notification) {
        guard
            let sender = notification.object as? UIButton,
            let sequence = sender.superview as? SourceSequenceView
        else { return }
        
        var time = Int(sequence.bounds.size.width / 2.0)
        
        let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .actionSheet)
       
        let sceneView = self.sceneView
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

    private func setEventView(_ notification: Notification) {
        guard let eventView = notification.object as? EventView else { return }
        
        let settingsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if eventView.isNext {
            let contentViewController = UIViewController()
            contentViewController.preferredContentSize = CGSize(width: 200.0, height: 90.0)
            
            let preview = EventView(recorded: eventView.recorded)
            preview.center = CGPoint(x: 100.0, y: 25.0)
            contentViewController.view.addSubview(preview)
            
            let colorsSegmentedControl = contentViewColorsSegmentedControl(eventView)
            contentViewController.view.addSubview(colorsSegmentedControl)
            
            settingsAlertController.setValue(contentViewController, forKey: "contentViewController")
            settingsAlertController.addTextField { textField in
                if let text = eventView.recorded.value.element?.value {
                    textField.text = text
                }
            }
            settingsAlertController.addAction(saveAction(preview, oldEventView: eventView))
            
            Observable
                .combineLatest(settingsAlertController.textFields!.first!.rx.textInput.text.orEmpty, colorsSegmentedControl.rx.value, resultSelector: { text, segment in
                    return (text, segment)
                })
                .subscribe(onNext: { text, segment in
                    self.updatePreviewEventView(preview, params: (color: Color.nextAll[segment], value: text))
                })
                .disposed(by: disposeBag)
        } else {
            settingsAlertController.message = "Delete event?"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        settingsAlertController.addAction(deleteAction(eventView: eventView))
        settingsAlertController.addAction(cancelAction)
        present(settingsAlertController, animated: true, completion: nil)
    }
    
    private func contentViewColorsSegmentedControl(_ eventView: EventView) -> UISegmentedControl {
        let colors = Color.nextAll
        let currentColor = eventView.recorded.value.element?.color
        let colorsSegment = UISegmentedControl(items: colors.map { _ in "" } )
        colorsSegment.tintColor = .clear
        colorsSegment.frame = CGRect(x: 0.0, y: 50.0, width: 200.0, height: 30.0)
        
        zip(colorsSegment.subviews, colors).forEach { v, color in v.backgroundColor = color }
        
        colorsSegment.selectedSegmentIndex = colors.firstIndex(of: currentColor!)!
        return colorsSegment
    }
    
    private func saveAction(_ newEventView: EventView, oldEventView: EventView) -> UIAlertAction {
        return UIAlertAction(title: "Save", style: .default) { _ in
            guard let index = oldEventView.sequenceView?.sourceEvents.firstIndex(of: oldEventView)
            else { return }
            
            oldEventView.sequenceView?.sourceEvents.remove(at: index)
            oldEventView.sequenceView?.addEventToTimeline(newEventView.recorded, animator: oldEventView.sequenceView?.animator)
            oldEventView.removeFromSuperview()
            self.sceneView.resultSequence.subject.onNext(())
        }
    }
    
    private func deleteAction(eventView: EventView) -> UIAlertAction {
        return UIAlertAction(title: "Delete", style: .destructive) { _ in
            eventView.animator?.removeAllBehaviors()
            eventView.animator?.addBehavior(eventView.gravity!)
            eventView.animator?.addBehavior(eventView.removeBehavior!)
        }
    }
    
    private func updatePreviewEventView(_ preview: EventView, params: (color: UIColor, value: String)) {
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
