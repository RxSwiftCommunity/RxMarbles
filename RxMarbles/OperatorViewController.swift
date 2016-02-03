//
//  ViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Names {
    static let setEventView = "SetEventView"
    static let addEvent = "AddEvent"
}

class OperatorViewController: UIViewController, UISplitViewControllerDelegate {
    private var _currentActivity: NSUserActivity?
    private var _disposeBag = DisposeBag()
    
    private let _scrollView = UIScrollView()
    private let _sceneView: SceneView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
    
    init(rxOperator: Operator) {
        _sceneView = SceneView(rxOperator: rxOperator, frame: CGRectZero)
        super.init(nibName: nil, bundle: nil)
        title = rxOperator.description
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        _sceneView.editing = editing
        navigationItem.setHidesBackButton(editing, animated: animated)
        navigationItem.rightBarButtonItems = editing ? [editButtonItem()] : [editButtonItem(), UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "makeSnapshot")]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.rightBarButtonItems = [editButtonItem(), UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "makeSnapshot")]
        view.addSubview(_scrollView)
        _scrollView.addSubview(_sceneView)
        _currentActivity = _sceneView.rxOperator.userActivity()
       
        let recognizers = [_sceneView.sourceTimeline?.longPressGestureRecorgnizer,
                           _sceneView.secondSourceTimeline?.longPressGestureRecorgnizer]
        
        for r in recognizers where r != nil {
            navigationController?.interactivePopGestureRecognizer?.requireGestureRecognizerToFail(r!)
        }
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.rx_notification(Names.setEventView).subscribeNext {
            [unowned self] notification in self.setEventView(notification)
        }.addDisposableTo(_disposeBag)
        
        notificationCenter.rx_notification(Names.addEvent).subscribeNext {
            [unowned self] notification in self.addEventToTimeline(notification)
        }.addDisposableTo(_disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _scrollView.frame = view.bounds
        
        var height: CGFloat = 90.0
        height += _sceneView.resultTimeline.bounds.height
        if !_sceneView.rxOperator.withoutTimelines {
            height += _sceneView.sourceTimeline.bounds.height
            if _sceneView.rxOperator.multiTimelines {
                height += _sceneView.secondSourceTimeline.bounds.height
            }
        }
        _sceneView.frame = CGRectMake(20, 0, _scrollView.bounds.size.width - 40, height)
        
        _scrollView.contentSize.height = _sceneView.bounds.height
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        _currentActivity?.becomeCurrent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        _currentActivity?.resignCurrent()
    }
    
//    MARK: Snapshot
    
    func makeSnapshot() {
        let size = CGSizeMake(_scrollView.bounds.width, _sceneView.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.mainScreen().scale)
        let c = UIGraphicsGetCurrentContext()!
        UIColor.whiteColor().setFill()
        UIRectFill(_scrollView.bounds)
        _scrollView.layer.renderInContext(c)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let shareActivity = UIActivityViewController(activityItems: [snapshot], applicationActivities: nil)
        shareActivity.excludedActivityTypes = [
            UIActivityTypeAssignToContact,
            UIActivityTypePrint,
        ]
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            let rootViewController = delegate.window?.rootViewController {
            rootViewController.presentViewController(shareActivity, animated: true, completion: nil)
        }
    }
    
//    MARK: Alert controllers
    
    func addEventToTimeline(notification: NSNotification) {
        let sender = notification.object as! UIButton
        guard let timeline = sender.superview as? SourceTimelineView else { return }
        var time = Int(timeline.bounds.size.width / 2.0)
        
        let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .ActionSheet)
       
        let sceneView = _sceneView
        let nextAction = UIAlertAction(title: "Next", style: .Default) { _ in
            let e = next(time, String(random() % 9 + 1), Color.nextRandom, (timeline == sceneView.sourceTimeline) ? .Circle : .Rect)
            timeline.addEventToTimeline(e, animator: timeline.animator)
            sceneView.resultTimeline.subject.onNext()
        }
        let completedAction = UIAlertAction(title: "Completed", style: .Default) { _ in
            time = timeline.maxEventTime()! > 850 ? timeline.maxEventTime()! + 30 : 850
            let e = completed(time)
            timeline.addEventToTimeline(e, animator: timeline.animator)
            sceneView.resultTimeline.subject.onNext()
        }
        let errorAction = UIAlertAction(title: "Error", style: .Default) { _ in
            let e = error(500)
            timeline.addEventToTimeline(e, animator: timeline.animator)
            sceneView.resultTimeline.subject.onNext()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in }
        
        elementSelector.addAction(nextAction)
        let sourceEvents: [EventView] = timeline.sourceEvents
        if sourceEvents.indexOf({ $0.isCompleted == true }) == nil {
            elementSelector.addAction(completedAction)
        }
        elementSelector.addAction(errorAction)
        elementSelector.addAction(cancelAction)
        elementSelector.popoverPresentationController?.sourceRect = sender.frame
        elementSelector.popoverPresentationController?.sourceView = sender.superview
        presentViewController(elementSelector, animated: true) { () -> Void in }
    }

    func setEventView(notification: NSNotification) {
        let settingsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        if let eventView = notification.object as? EventView {
            if eventView.isNext {
                let contentViewController = UIViewController()
                contentViewController.preferredContentSize = CGSizeMake(200.0, 90.0)
                
                let preview = EventView(recorded: eventView.recorded)
                preview.center = CGPointMake(100.0, 25.0)
                contentViewController.view.addSubview(preview)
                
                let colors = Color.nextAll
                let currentColor = eventView.recorded.value.element?.color
                let colorsSegment = UISegmentedControl(items: colors.map { _ in "" } )
                colorsSegment.tintColor = .clearColor()
                colorsSegment.frame = CGRectMake(0.0, 50.0, 200.0, 30.0)
                
                let subviewsCount = colorsSegment.subviews.count
                for i in 0..<subviewsCount {
                    colorsSegment.subviews[i].backgroundColor = colors[i]
                }
                colorsSegment.selectedSegmentIndex = colors.indexOf({ $0 == currentColor! })!
                
                contentViewController.view.addSubview(colorsSegment)
                
                settingsAlertController.setValue(contentViewController, forKey: "contentViewController")
                
                settingsAlertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                    if let text = eventView.recorded.value.element?.value {
                        textField.text = text
                    }
                })
                
                _ = Observable
                    .combineLatest(settingsAlertController.textFields!.first!.rx_text, colorsSegment.rx_value, resultSelector: { text, segment in
                        return (text, segment)
                    })
                    .subscribeNext({ (text, segment) in
                        self.updatePreviewEventView(preview, params: (color: colors[segment], value: text))
                    })
                
                let saveAction = UIAlertAction(title: "Save", style: .Default) { _ in
                    self.saveAction(preview, oldEventView: eventView)
                }
                settingsAlertController.addAction(saveAction)
            } else {
                settingsAlertController.message = "Delete event?"
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { _ in
                self.deleteAction(eventView)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in }
            settingsAlertController.addAction(deleteAction)
            settingsAlertController.addAction(cancelAction)
            presentViewController(settingsAlertController, animated: true, completion: nil)
        }
    }
    
    private func saveAction(newEventView: EventView, oldEventView: EventView) {
        if let index = oldEventView.timeLine?.sourceEvents.indexOf(oldEventView) {
            oldEventView.timeLine?.sourceEvents.removeAtIndex(index)
            oldEventView.timeLine?.addEventToTimeline(newEventView.recorded, animator: oldEventView.timeLine?.animator)
            oldEventView.removeFromSuperview()
            _sceneView.resultTimeline.subject.onNext()
        }
    }
    
    private func deleteAction(eventView: EventView) {
        eventView.animator!.removeAllBehaviors()
        eventView.animator!.addBehavior(eventView.gravity!)
        eventView.animator!.addBehavior(eventView.removeBehavior!)
    }
    
    private func updatePreviewEventView(preview: EventView, params: (color: UIColor, value: String)) {
        let time = preview.recorded.time
        let shape = preview.recorded.value.element?.shape
        let event = Event.Next(ColoredType(value: params.value, color: params.color, shape: shape!))
        
        preview.recorded = RecordedType(time: time, event: event)
        preview.label.text = params.value
        preview.setColorOnPreview(params.color)
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "Share", style: .Default) { action, controller in
            self.makeSnapshot()
        }
        return [shareAction]
    }
    
}

extension UINavigationController {
    public override func previewActionItems() -> [UIPreviewActionItem] {
        return viewControllers.last?.previewActionItems() ?? []
    }
}