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

class ViewController: UIViewController, UISplitViewControllerDelegate {
    private var _currentActivity: NSUserActivity?
    
    var currentOperator = Operator.Delay
    var sceneView: SceneView!
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        sceneView.editing = editing
        navigationItem.setHidesBackButton(editing, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentOperator.description
        view.backgroundColor = .whiteColor()
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.rightBarButtonItem = editButtonItem()
        setupSceneView()
        _currentActivity = currentOperator.userActivity()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setEventView:", name: "SetEventView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addEventToTimeline:", name: "AddEvent", object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = CGRectMake(20, 0, view.bounds.size.width - 40, view.bounds.size.height)
    }
    
    func setupSceneView() {
        sceneView?.removeFromSuperview()
        let sceneFrame = CGRectMake(20, 0, view.bounds.size.width - 40, view.bounds.size.height)
        sceneView = SceneView(rxOperator: currentOperator, frame: sceneFrame)
        view.addSubview(sceneView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        _currentActivity?.becomeCurrent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        _currentActivity?.resignCurrent()
    }
    
//    MARK: Alert controllers
    
    func addEventToTimeline(notification: NSNotification) {
        let sender = notification.object as! UIButton
        guard let timeline = sender.superview as? SourceTimelineView else { return }
        var time = Int(timeline.bounds.size.width / 2.0)
        
        let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .ActionSheet)
        
        let nextAction = UIAlertAction(title: "Next", style: .Default) { _ in
            let e = next(time, String(random() % 10), Color.nextRandom, (timeline == self.sceneView.sourceTimeline) ? .Circle : .Rect)
            timeline.addEventToTimeline(e, animator: self.sceneView.animator, isEditing: self.editing)
            self.sceneView.updateResultTimeline()
        }
        let completedAction = UIAlertAction(title: "Completed", style: .Default) { _ in
            if let t = timeline.maxEventTime() {
                time = t + 20
            } else {
                time = Int(self.sceneView.sourceTimeline.bounds.size.width - 60.0)
            }
            let e = completed(time)
            timeline.addEventToTimeline(e, animator: self.sceneView.animator, isEditing: self.editing)
            self.sceneView.updateResultTimeline()
        }
        let errorAction = UIAlertAction(title: "Error", style: .Default) { _ in
            let e = error(time)
            timeline.addEventToTimeline(e, animator: self.sceneView.animator, isEditing: self.editing)
            self.sceneView.updateResultTimeline()
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
                var counter = 0
                colorsSegment.subviews.forEach({ subview in
                    subview.backgroundColor = colors[counter]
                    if currentColor == colors[counter] {
                        colorsSegment.selectedSegmentIndex = counter
                    }
                    counter++
                })
                
                if colorsSegment.selectedSegmentIndex < 0 {
                    colorsSegment.selectedSegmentIndex = 0
                }
                
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
                
                let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
                    self.saveAction(preview, oldEventView: eventView)
                }
                settingsAlertController.addAction(saveAction)
            } else {
                settingsAlertController.message = "Delete event?"
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
                self.deleteAction(eventView)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
            settingsAlertController.addAction(deleteAction)
            settingsAlertController.addAction(cancelAction)
            presentViewController(settingsAlertController, animated: true, completion: nil)
        }
    }
    
    private func saveAction(newEventView: EventView, oldEventView: EventView) {
        if let index = oldEventView.timeLine?.sourceEvents.indexOf(oldEventView) {
            oldEventView.timeLine?.sourceEvents.removeAtIndex(index)
            oldEventView.timeLine?.addEventToTimeline(newEventView.recorded, animator: sceneView.animator, isEditing: true)
            oldEventView.removeFromSuperview()
            sceneView.updateResultTimeline()
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
}