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
    static var timeLine: UIImage { return UIImage(named: "timeLine")! }
    static var cross: UIImage { return UIImage(named: "cross")! }
    static var trash: UIImage { return UIImage(named: "Trash")! }
}

func ==(lhs: ColoredType, rhs: ColoredType) -> Bool {
    return lhs.value == rhs.value && lhs.color == rhs.color && lhs.shape == rhs.shape
}

typealias RecordedType = Recorded<Event<ColoredType>>

class ViewController: UIViewController, UISplitViewControllerDelegate {
    var currentOperator = Operator.Delay
    private var _currentActivity: NSUserActivity?
    var _sceneView: SceneView!
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.setHidesBackButton(editing, animated: animated)
        if animated {
            UIView.animateWithDuration(0.3) { _ in
                self._sceneView._resultTimeline.alpha = editing ? 0.5 : 1.0
            }
        } else {
            _sceneView._resultTimeline.alpha = editing ? 0.5 : 1.0
        }
        if let sourceTimeline = _sceneView._sourceTimeline {
            sourceTimelineEditActions(sourceTimeline, isEdit: editing)
        }
        if currentOperator.multiTimelines {
            if let secondSourceTimeline = _sceneView._secondSourceTimeline {
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
//        setEditing(false, animated: false)
        _currentActivity = currentOperator.userActivity()
    }
    
    func setupSceneView() {
        if _sceneView != nil {
            _sceneView.removeFromSuperview()
        }
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        _sceneView = SceneView()
        view.addSubview(_sceneView)
        _sceneView.frame = view.frame
        _sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sceneView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sceneView" : _sceneView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sceneView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sceneView" : _sceneView]))
        
        _sceneView.animator = UIDynamicAnimator(referenceView: _sceneView)
        
        let width = _sceneView.frame.width - 20
        
        let resultTimeline = ResultTimelineView(frame: CGRectMake(10, 0, width, 40), currentOperator: currentOperator)
        resultTimeline.center.y = 200
        _sceneView.addSubview(resultTimeline)
        _sceneView._resultTimeline = resultTimeline
        
        let sourceTimeLine = SourceTimelineView(frame: CGRectMake(10, 0, width, 40), resultTimeline: resultTimeline)
        sourceTimeLine._parentViewController = self
        sourceTimeLine._sceneView = _sceneView
        sourceTimeLine.center.y = 120
        _sceneView.addSubview(sourceTimeLine)
        _sceneView._sourceTimeline = sourceTimeLine
        
        for t in 1..<4 {
            let time = orientation.isPortrait ? t * 40 : Int(CGFloat(t) * 40.0 * scaleKoefficient())
            let event = Event.Next(ColoredType(value: String(randomNumber()), color: RXMUIKit.randomColor(), shape: .Circle))
            sourceTimeLine.addNextEventToTimeline(time, event: event, animator: _sceneView.animator, isEditing: editing)
        }
        let completedTime = orientation.isPortrait ? 150 : Int(150.0 * scaleKoefficient())
        sourceTimeLine.addCompletedEventToTimeline(completedTime, animator: _sceneView.animator, isEditing: editing)
        
        if currentOperator.multiTimelines {
            resultTimeline.center.y = 280
            let secondSourceTimeline = SourceTimelineView(frame: CGRectMake(10, 0, width, 40), resultTimeline: resultTimeline)
            secondSourceTimeline._parentViewController = self
            secondSourceTimeline._sceneView = _sceneView
            secondSourceTimeline.center.y = 200
            _sceneView.addSubview(secondSourceTimeline)
            _sceneView._secondSourceTimeline = secondSourceTimeline
            
            for t in 1..<3 {
                let time = orientation.isPortrait ? t * 40 : Int(CGFloat(t) * 40.0 * scaleKoefficient())
                let event = Event.Next(ColoredType(value: String(randomNumber()), color: RXMUIKit.randomColor(), shape: .RoundedRect))
                secondSourceTimeline.addNextEventToTimeline(time, event: event, animator: _sceneView.animator, isEditing: editing)
            }
            let secondCompletedTime = orientation.isPortrait ? 110 : Int(110.0 * scaleKoefficient())
            secondSourceTimeline.addCompletedEventToTimeline(secondCompletedTime, animator: _sceneView.animator, isEditing: editing)
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
        if let timeline: SourceTimelineView = sender.superview as? SourceTimelineView {
            var time = Int(timeline.bounds.size.width / 2.0)
            
            let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .ActionSheet)
            
            let nextAction = UIAlertAction(title: "Next", style: .Default) { (action) -> Void in
                let shape: EventShape = (timeline == self._sceneView._sourceTimeline) ? .Circle : .RoundedRect
                let event = Event.Next(ColoredType(value: String(self.randomNumber()), color: RXMUIKit.randomColor(), shape: shape))
                timeline.addNextEventToTimeline(time, event: event, animator: self._sceneView.animator, isEditing: self.editing)
                timeline.updateResultTimeline()
            }
            let completedAction = UIAlertAction(title: "Completed", style: .Default) { (action) -> Void in
                if let t = timeline.maxNextTime() {
                    time = t + 20
                } else {
                    time = Int(self._sceneView._sourceTimeline.bounds.size.width - 60.0)
                }
                timeline.addCompletedEventToTimeline(time, animator: self._sceneView.animator, isEditing: self.editing)
                timeline.updateResultTimeline()
            }
            let errorAction = UIAlertAction(title: "Error", style: .Default) { (action) -> Void in
                timeline.addErrorEventToTimeline(time, animator: self._sceneView.animator, isEditing: self.editing)
                timeline.updateResultTimeline()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
            
            elementSelector.addAction(nextAction)
            let sourceEvents: [EventView] = timeline._sourceEvents
            if sourceEvents.indexOf({ $0.isCompleted == true }) == nil {
                elementSelector.addAction(completedAction)
            }
            elementSelector.addAction(errorAction)
            elementSelector.addAction(cancelAction)
            elementSelector.popoverPresentationController?.sourceRect = sender.frame
            elementSelector.popoverPresentationController?.sourceView = sender.superview
            presentViewController(elementSelector, animated: true) { () -> Void in }
        }
    }
    
    private func randomNumber() -> Int {
        return Int(arc4random_uniform(10) + 1)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
                self._sceneView._resultTimeline._sourceEvents.forEach({ (eventView) -> () in
                    eventView.removeFromSuperview()
                })
            }) { (context) -> Void in
                self.scaleTimesOnChangeOrientation(self._sceneView._sourceTimeline)
                if self.currentOperator.multiTimelines {
                    self.scaleTimesOnChangeOrientation(self._sceneView._secondSourceTimeline)
                }
        }
    }
    
    private func scaleTimesOnChangeOrientation(timeline: SourceTimelineView) {
        let scaleKoef = scaleKoefficient()
        var sourceEvents = timeline._sourceEvents
        timeline._sourceEvents.forEach({ eventView in
            eventView.removeFromSuperview()
        })
        timeline._sourceEvents.removeAll()
        sourceEvents.forEach({ eventView in
            let time = Int(CGFloat(eventView._recorded.time) * scaleKoef)
            if eventView.isNext {
                timeline.addNextEventToTimeline(time, event: eventView._recorded.value, animator: _sceneView.animator, isEditing: self.editing)
            } else if eventView.isCompleted {
                timeline.addCompletedEventToTimeline(time, animator: _sceneView.animator, isEditing: editing)
            } else {
                timeline.addErrorEventToTimeline(time, animator: _sceneView.animator, isEditing: editing)
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

}