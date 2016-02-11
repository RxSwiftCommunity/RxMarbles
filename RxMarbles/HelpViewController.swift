//
//  HelpViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 10.02.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import RazzleDazzle
import SafariServices

struct Link {
    static let anjlab = "http://anjlab.com/en"
    static let rxswift = "https://github.com/ReactiveX/RxSwift"
}

class HelpViewController: AnimatedPagingScrollViewController {
    
    private let _logoImageView = UIImageView(image: UIImage(named: "IntroLogo"))
    private let _resultTimeline = UIImageView(image: Image.timeLine)
    
    private let _sharingEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Sharing", color: Color.nextGreen, shape: EventShape.Circle))))
    private let _searchEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Search", color: Color.nextBlue, shape: EventShape.Circle))))
    private let _editingEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Editing", color: Color.nextOrange, shape: EventShape.Circle))))
    private let _rxSwiftEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "RxSwift", color: Color.nextDarkYellow, shape: EventShape.Star))))
    private let _anjlabEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "AnjLab", color: Color.nextViolet, shape: EventShape.Star))))
    private let _completedEventView = EventView(recorded: RecordedType(time: 0, event: .Completed))
    
    private let _searchNextButton = UIButton(type: .System)
    private let _editingNextButton = UIButton(type: .System)
    private let _rxSwiftNextButton = UIButton(type: .System)
    private let _anjlabNextButton = UIButton(type: .System)
    private let _completedButton = UIButton(type: .System)
    
    private let _firstHelpImage = UIImageView()
    private let _secondHelpImage = UIImageView()
    private let _thirdHelpImage = UIImageView()
    
    private let _poweredByRxLabel = UILabel()
    private let _addStarButton = UIButton(type: .System)
    private let _anjLabButton = UIButton(type: .System)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        _configureLogoImageView()
        _configureImageViews()
        
        _configureSearchNextButton()
        _configureEditingNextButton()
        _configureRxSwiftNextButton()
        _configureAnjlabNextButton()
        _configureCompletedButton()
        
        _configureResultTimeline()
        
        _configureSharingEventView()
        _configureSearchEventView()
        _configureEditingEventView()
        _configureRxSwiftEventView()
        _configureAnjlabEventView()
        _configureCompletedEventView()
        
        _configurePoweredByRxLabel()
        _configureAddStarButton()
        _configureAnjLabButton()
    }
    
    private func _configureLogoImageView() {
        contentView.addSubview(_logoImageView)
        let verticalConstraint = NSLayoutConstraint(item: _logoImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: -100)
        contentView.addConstraint(verticalConstraint)
        keepView(_logoImageView, onPages: [0, 1, 2, 3, 4, 5])
        
        let verticalAnimation = ConstraintConstantAnimation(superview: contentView, constraint: verticalConstraint)
        verticalAnimation[0] = 30
        verticalAnimation[4] = 30
        verticalAnimation[5] = scrollView.frame.height / 2 - _logoImageView.frame.height / 2
        animator.addAnimation(verticalAnimation)
    }
    
    private func _configureImageViews() {
        _configureImageViewsConstraints(_firstHelpImage, page: 0)
        
        _configureImageViewsConstraints(_secondHelpImage, page: 1)
        
        _configureImageViewsConstraints(_thirdHelpImage, page: 2)
    }
    
    private func _configureImageViewsConstraints(imageView: UIImageView, page: CGFloat) {
        imageView.backgroundColor = .lightGrayColor()
        contentView.addSubview(imageView)
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300))
        keepView(imageView, onPage: page)
    }
    
    private func _configureSearchNextButton() {
        _searchNextButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 14)
        _searchNextButton.setTitle("onNext(   )", forState: .Normal)
        _searchNextButton.addTarget(self, action: "addSearchNext", forControlEvents: .TouchUpInside)
        contentView.addSubview(_searchNextButton)
        contentView.addConstraint(NSLayoutConstraint(item: _searchNextButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        keepView(_searchNextButton, onPage: 0)
    }
    
    private func _configureEditingNextButton() {
        _editingNextButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 14)
        _editingNextButton.setTitle("onNext(   )", forState: .Normal)
        _editingNextButton.addTarget(self, action: "addEditingNext", forControlEvents: .TouchUpInside)
        contentView.addSubview(_editingNextButton)
        contentView.addConstraint(NSLayoutConstraint(item: _editingNextButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        keepView(_editingNextButton, onPage: 1)
    }
    
    private func _configureRxSwiftNextButton() {
        _rxSwiftNextButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 14)
        _rxSwiftNextButton.setTitle("onNext(   )", forState: .Normal)
        _rxSwiftNextButton.addTarget(self, action: "addRxSwiftNext", forControlEvents: .TouchUpInside)
        contentView.addSubview(_rxSwiftNextButton)
        contentView.addConstraint(NSLayoutConstraint(item: _rxSwiftNextButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        keepView(_rxSwiftNextButton, onPage: 2)
    }
    
    private func _configureAnjlabNextButton() {
        _anjlabNextButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 14)
        _anjlabNextButton.setTitle("onNext(   )", forState: .Normal)
        _anjlabNextButton.addTarget(self, action: "addAnjlabNext", forControlEvents: .TouchUpInside)
        contentView.addSubview(_anjlabNextButton)
        contentView.addConstraint(NSLayoutConstraint(item: _anjlabNextButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        keepView(_anjlabNextButton, onPage: 3)
    }
    
    private func _configureCompletedButton() {
        _completedButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 14)
        _completedButton.setTitle("Completed", forState: .Normal)
        _completedButton.addTarget(self, action: "addCompleted", forControlEvents: .TouchUpInside)
        contentView.addSubview(_completedButton)
        contentView.addConstraint(NSLayoutConstraint(item: _completedButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        keepView(_completedButton, onPage: 4)
    }
    
    private func _configureResultTimeline() {
        contentView.addSubview(_resultTimeline)
        contentView.addConstraint(NSLayoutConstraint(item: _resultTimeline, attribute: .Bottom, relatedBy: .Equal, toItem: _searchNextButton, attribute: .Top, multiplier: 1, constant: -30))
        scrollView.addConstraint(NSLayoutConstraint(item: _resultTimeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.9, constant: 0))
        keepView(_resultTimeline, onPages: [0, 1, 2, 3, 4, 5])
    }
    
    private func _configureSharingEventView() {
        contentView.addSubview(_sharingEventView)
        
        contentView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .CenterY, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .CenterX, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterX, multiplier: 1, constant: -125))
        _sharingEventView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        _sharingEventView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        
        keepView(_sharingEventView, onPages: [0, 1, 2, 3, 4, 5])
    }
    
    private func _configureSearchEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_searchEventView)
        keepView(_searchEventView, onPages: [0, 1, 2, 3, 4, 5])
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        verticalConstraintAnimation[0] = 48
        verticalConstraintAnimation[1] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horisontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horizontal)
        horisontalConstraintAnimation[0] = 25
        horisontalConstraintAnimation[1] = -75
        animator.addAnimation(horisontalConstraintAnimation)
    }
    
    private func _configureEditingEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_editingEventView)
        keepView(_editingEventView, onPages: [1, 2, 3, 4, 5])
        
        let showAnimation = HideAnimation(view: _editingEventView, showAt: 0.99)
        animator.addAnimation(showAnimation)
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        verticalConstraintAnimation[1] = 48
        verticalConstraintAnimation[2] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horisontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horizontal)
        horisontalConstraintAnimation[1] = 25
        horisontalConstraintAnimation[2] = -25
        animator.addAnimation(horisontalConstraintAnimation)
    }
    
    private func _configureRxSwiftEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_rxSwiftEventView)
        keepView(_rxSwiftEventView, onPages: [2, 3, 4, 5])
        
        let showAnimation = HideAnimation(view: _rxSwiftEventView, showAt: 1.99)
        animator.addAnimation(showAnimation)
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        verticalConstraintAnimation[2] = 48
        verticalConstraintAnimation[3] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horisontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horizontal)
        horisontalConstraintAnimation[2] = 25
        horisontalConstraintAnimation[3] = 25
        animator.addAnimation(horisontalConstraintAnimation)
    }
    
    private func _configureAnjlabEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_anjlabEventView)
        keepView(_anjlabEventView, onPages: [2, 3, 4, 5])
        
        let showAnimation = HideAnimation(view: _anjlabEventView, showAt: 2.99)
        animator.addAnimation(showAnimation)
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        verticalConstraintAnimation[3] = 48
        verticalConstraintAnimation[4] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horisontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horizontal)
        horisontalConstraintAnimation[3] = 25
        horisontalConstraintAnimation[4] = 75
        animator.addAnimation(horisontalConstraintAnimation)
    }
    
    private func _configureCompletedEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_completedEventView)
        keepView(_completedEventView, onPages: [4, 5])
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        verticalConstraintAnimation[4] = 48
        verticalConstraintAnimation[5] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horisontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horizontal)
        horisontalConstraintAnimation[4] = 0
        horisontalConstraintAnimation[5] = 125
        animator.addAnimation(horisontalConstraintAnimation)
        
        let showAnimation = HideAnimation(view: _completedEventView, showAt: 4.1)
        animator.addAnimation(showAnimation)
    }
    
    private func _configureEventViewConstraints(eventView: EventView) -> (NSLayoutConstraint, NSLayoutConstraint) {
        contentView.addSubview(eventView)
        let verticalConstraint = NSLayoutConstraint(item: eventView, attribute: .CenterY, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0)
        contentView.addConstraint(verticalConstraint)
        let horizontalConstraint = NSLayoutConstraint(item: eventView, attribute: .CenterX, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterX, multiplier: 1, constant: 25)
        scrollView.addConstraint(horizontalConstraint)
        eventView.addConstraint(NSLayoutConstraint(item: eventView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        eventView.addConstraint(NSLayoutConstraint(item: eventView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        return (verticalConstraint, horizontalConstraint)
    }
    
    
    private func _configurePoweredByRxLabel() {
        _poweredByRxLabel.text = "Powered by RxSwift"
        _poweredByRxLabel.textColor = .blackColor()
        _poweredByRxLabel.textAlignment = .Center
        _poweredByRxLabel.font = UIFont(name: "Menlo-Regular", size: 16)
        contentView.addSubview(_poweredByRxLabel)
        contentView.addConstraint(NSLayoutConstraint(item: _poweredByRxLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        keepView(_poweredByRxLabel, onPage: 3)
    }
    
    private func _configureAddStarButton() {
        _addStarButton.setTitle("Add Star", forState: .Normal)
        _addStarButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 12)
        _addStarButton.addTarget(self, action: "openRxSwiftOnGithub", forControlEvents: .TouchUpInside)
        contentView.addSubview(_addStarButton)
        contentView.addConstraint(NSLayoutConstraint(item: _addStarButton, attribute: .Top, relatedBy: .Equal, toItem: _poweredByRxLabel, attribute: .Bottom, multiplier: 1, constant: 30))
        keepView(_addStarButton, onPage: 3)
    }
    
    private func _configureAnjLabButton() {
        _anjLabButton.setTitle("AnjLab", forState: .Normal)
        _anjLabButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 20)
        _anjLabButton.addTarget(self, action: "openAnjLab", forControlEvents: .TouchUpInside)
        contentView.addSubview(_anjLabButton)
        contentView.addConstraint(NSLayoutConstraint(item: _anjLabButton, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        keepView(_anjLabButton, onPage: 4)
    }
    
    override func numberOfPages() -> Int {
        return 6
    }
    
//    MARK: Navigation
    
    func addSearchNext() {
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentOffset = CGPointMake(self.pageWidth * 1, 0)
        }
    }
    
    func addEditingNext() {
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentOffset = CGPointMake(self.pageWidth * 2, 0)
        }
    }
    
    func addRxSwiftNext() {
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentOffset = CGPointMake(self.pageWidth * 3, 0)
        }
    }
    
    func addAnjlabNext() {
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentOffset = CGPointMake(self.pageWidth * 4, 0)
        }
    }
    
    func addCompleted() {
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentOffset = CGPointMake(self.pageWidth * 5, 0)
        }
    }
    
    func openRxSwiftOnGithub() {
        let url = NSURL(string: Link.rxswift)
        openURLinSafariViewController(url!)
    }
    
    func openAnjLab() {
        let url = NSURL(string: Link.anjlab)
        openURLinSafariViewController(url!)
    }
    
    private func openURLinSafariViewController(url: NSURL) {
        let safariViewController = SFSafariViewController(URL: url)
        presentViewController(safariViewController, animated: true, completion: nil)
    }
    
//    MARK: UIInterfaceOrientationMask Portrait only
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}