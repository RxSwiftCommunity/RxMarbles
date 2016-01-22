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

struct ColoredType: Equatable {
    var value: String
    var color: UIColor
    var shape: EventShape
}

struct Image {
    static let timeLine = UIImage(named: "timeLine")!
    static let cross    = UIImage(named: "cross")!
    static let trash    = UIImage(named: "Trash")!
}

func ==(lhs: ColoredType, rhs: ColoredType) -> Bool {
    return lhs.value == rhs.value && lhs.color == rhs.color && lhs.shape == rhs.shape
}

typealias RecordedType = Recorded<Event<ColoredType>>

class ViewController: UIViewController, UISplitViewControllerDelegate {
    private var _currentActivity: NSUserActivity?
    private var _eventSetupAlertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
    
    var currentOperator = Operator.Delay
    var sceneView: SceneView!
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.setHidesBackButton(editing, animated: animated)
        if animated {
            UIView.animateWithDuration(0.3) { _ in
                self.sceneView.resultTimeline.alpha = editing ? 0.5 : 1.0
            }
        } else {
            sceneView.resultTimeline.alpha = editing ? 0.5 : 1.0
        }
        if let sourceTimeline = sceneView.sourceTimeline {
            sourceTimelineEditActions(sourceTimeline, isEdit: editing)
        }
        if currentOperator.multiTimelines {
            if let secondSourceTimeline = sceneView.secondSourceTimeline {
                sourceTimelineEditActions(secondSourceTimeline, isEdit: editing)
            }
        }
    }
    
    private func sourceTimelineEditActions(sourceTimeline: SourceTimelineView, isEdit: Bool) {
        if isEdit {
            sourceTimeline.addTapRecognizers()
            sourceTimeline.showAddButton()
            sourceTimeline._addButton!.addTarget(self, action: "addElementToTimeline:", forControlEvents: .TouchUpInside)
        } else {
            sourceTimeline.removeTapRecognizers()
            sourceTimeline.hideAddButton()
        }
        sourceTimeline.allEventViewsAnimation()
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
    }
    
    func setupSceneView() {
        sceneView?.removeFromSuperview()
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        sceneView = SceneView()
        view.addSubview(sceneView)
        sceneView.frame = view.frame
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sceneView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sceneView" : sceneView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sceneView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sceneView" : sceneView]))
        
        sceneView.animator = UIDynamicAnimator(referenceView: sceneView)
        
        let width = sceneView.frame.width - 20
        
        let resultTimeline = ResultTimelineView(frame: CGRectMake(10, 0, width, 40), currentOperator: currentOperator)
        resultTimeline.center.y = 200
        sceneView.addSubview(resultTimeline)
        sceneView.resultTimeline = resultTimeline
        
        let sourceTimeLine = SourceTimelineView(frame: CGRectMake(10, 0, width, 40), scene: sceneView)
        sourceTimeLine.center.y = 120
        sceneView.addSubview(sourceTimeLine)
        sceneView.sourceTimeline = sourceTimeLine
        
        for t in 1..<4 {
            let time = orientation.isPortrait ? t * 40 : Int(CGFloat(t) * 40.0 * scaleKoefficient())
            let event = Event.Next(ColoredType(value: String(randomNumber()), color: RXMUIKit.randomColor(), shape: .Circle))
            sourceTimeLine.addNextEventToTimeline(time, event: event, animator: sceneView.animator, isEditing: editing)
        }
        let completedTime = orientation.isPortrait ? 150 : Int(150.0 * scaleKoefficient())
        sourceTimeLine.addCompletedEventToTimeline(completedTime, animator: sceneView.animator, isEditing: editing)
        
        if currentOperator.multiTimelines {
            resultTimeline.center.y = 280
            let secondSourceTimeline = SourceTimelineView(frame: CGRectMake(10, 0, width, 40), scene: sceneView)
            secondSourceTimeline.center.y = 200
            sceneView.addSubview(secondSourceTimeline)
            sceneView.secondSourceTimeline = secondSourceTimeline
            
            for t in 1..<3 {
                let time = orientation.isPortrait ? t * 40 : Int(CGFloat(t) * 40.0 * scaleKoefficient())
                let event = Event.Next(ColoredType(value: String(randomNumber()), color: RXMUIKit.randomColor(), shape: .RoundedRect))
                secondSourceTimeline.addNextEventToTimeline(time, event: event, animator: sceneView.animator, isEditing: editing)
            }
            let secondCompletedTime = orientation.isPortrait ? 110 : Int(110.0 * scaleKoefficient())
            secondSourceTimeline.addCompletedEventToTimeline(secondCompletedTime, animator: sceneView.animator, isEditing: editing)
        }
        
        sourceTimeLine.updateResultTimeline()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        _currentActivity?.becomeCurrent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        _currentActivity?.resignCurrent()
    }
    
    func addElementToTimeline(sender: UIButton) {
        guard let timeline = sender.superview as? SourceTimelineView else { return }
        var time = Int(timeline.bounds.size.width / 2.0)
        
        let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .ActionSheet)
        
        let nextAction = UIAlertAction(title: "Next", style: .Default) { action in
            let shape: EventShape = (timeline == self.sceneView.sourceTimeline) ? .Circle : .RoundedRect
            let event = Event.Next(ColoredType(value: String(self.randomNumber()), color: RXMUIKit.randomColor(), shape: shape))
            timeline.addNextEventToTimeline(time, event: event, animator: self.sceneView.animator, isEditing: self.editing)
            timeline.updateResultTimeline()
        }
        let completedAction = UIAlertAction(title: "Completed", style: .Default) { (action) -> Void in
            if let t = timeline.maxNextTime() {
                time = t + 20
            } else {
                time = Int(self.sceneView.sourceTimeline.bounds.size.width - 60.0)
            }
            timeline.addCompletedEventToTimeline(time, animator: self.sceneView.animator, isEditing: self.editing)
            timeline.updateResultTimeline()
        }
        let errorAction = UIAlertAction(title: "Error", style: .Default) { (action) -> Void in
            timeline.addErrorEventToTimeline(time, animator: self.sceneView.animator, isEditing: self.editing)
            timeline.updateResultTimeline()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
        
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
    
    private func randomNumber() -> Int {
        return Int(arc4random_uniform(10) + 1)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(
            { context in
                self.sceneView.resultTimeline.sourceEvents.forEach({ $0.removeFromSuperview() })
            },
            completion: { context in
                self.scaleTimesOnChangeOrientation(self.sceneView.sourceTimeline)
                if self.currentOperator.multiTimelines {
                    self.scaleTimesOnChangeOrientation(self.sceneView.secondSourceTimeline)
                }
            }
        )
    }
    
    private func scaleTimesOnChangeOrientation(timeline: SourceTimelineView) {
        let scaleKoef = scaleKoefficient()
        var sourceEvents = timeline.sourceEvents
        timeline.sourceEvents.forEach({ $0.removeFromSuperview() })
        timeline.sourceEvents.removeAll()
        sourceEvents.forEach({ eventView in
            let time = Int(CGFloat(eventView.recorded.time) * scaleKoef)
            if eventView.isNext {
                timeline.addNextEventToTimeline(time, event: eventView.recorded.value, animator: sceneView.animator, isEditing: self.editing)
            } else if eventView.isCompleted {
                timeline.addCompletedEventToTimeline(time, animator: sceneView.animator, isEditing: editing)
            } else {
                timeline.addErrorEventToTimeline(time, animator: sceneView.animator, isEditing: editing)
            }
        })
        sourceEvents.removeAll()
        timeline.allEventViewsAnimation()
        timeline.updateResultTimeline()
    }
    
    private func scaleKoefficient() -> CGFloat {
        let width = view.frame.width
        let height = view.frame.height
        return width / height
    }
    
//    MARK: Alert controller

    func setEventView(notification: NSNotification) {
        let settingsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        if let eventView: EventView = notification.object as? EventView {
            if eventView.isNext {
                let contentViewController = UIViewController()
                contentViewController.preferredContentSize = CGSizeMake(200.0, 90.0)
                
                let shape = eventView.recorded.value.element?.shape
                let preview = EventView(recorded: eventView.recorded, shape: shape!)
                preview.center = CGPointMake(100.0, 25.0)
                contentViewController.view.addSubview(preview)
                
                let colors = [RXMUIKit.lightBlueColor(), RXMUIKit.darkYellowColor(), RXMUIKit.lightGreenColor(), RXMUIKit.blueColor(), RXMUIKit.orangeColor()]
                let currentColor = eventView.recorded.value.element?.color
                let colorsSegment = UISegmentedControl(items: ["", "", "", "", ""])
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
        let time = newEventView.recorded.time
        if let index = oldEventView.timeLine?.sourceEvents.indexOf(oldEventView) {
            oldEventView.timeLine?.sourceEvents.removeAtIndex(index)
            oldEventView.removeFromSuperview()
            oldEventView.timeLine?.addNextEventToTimeline(time, event: newEventView.recorded.value, animator: newEventView.animator, isEditing: true)
            oldEventView.timeLine?.updateResultTimeline()
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
        preview.backgroundColor = params.color
    }
}