//
//  HelpViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 10.02.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import RazzleDazzle

class HelpViewController: AnimatedPagingScrollViewController {
    
    private let _logoImageView = UIImageView(image: UIImage(named: "IntroLogo"))
    private let _resultTimeline = UIImageView(image: Image.timeLine)
    private let _firstEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "", color: Color.nextGreen, shape: EventShape.Circle))))
    private let _secondEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "", color: Color.nextBlue, shape: EventShape.Circle))))
    private let _completedEventView = EventView(recorded: RecordedType(time: 0, event: .Completed))
    private let _nextButton = UIButton(type: .Custom)
    private let _completedButton = UIButton(type: .Custom)
    private let _firstHelpImage = UIImageView()
    private let _secondHelpImage = UIImageView()
    private let _thirdHelpImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        _configureLogoImageView()
        _configureImageViews()
        _configureNextButton()
        _configureCompletedButton()
        _configureResultTimeline()
        
        _configureFirstEventView()
        _configureSecondEventView()
        _configureCompletedEventView()
    }
    
    private func _configureLogoImageView() {
        contentView.addSubview(_logoImageView)
        let verticalConstraint = NSLayoutConstraint(item: _logoImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: -100)
        contentView.addConstraint(verticalConstraint)
        keepView(_logoImageView, onPages: [0, 1, 2, 3, 4])
        
        let verticalAnimation = ConstraintConstantAnimation(superview: contentView, constraint: verticalConstraint)
        verticalAnimation[0] = 30
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
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        keepView(imageView, onPage: page)
    }
    
    private func _configureNextButton() {
        _nextButton.setTitle("onNext()", forState: .Normal)
        _nextButton.setTitleColor(.blackColor(), forState: .Normal)
        contentView.addSubview(_nextButton)
        contentView.addConstraint(NSLayoutConstraint(item: _nextButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        keepView(_nextButton, onPage: 0)
    }
    
    private func _configureCompletedButton() {
        _completedButton.setTitle("Completed", forState: .Normal)
        _completedButton.setTitleColor(.blackColor(), forState: .Normal)
        contentView.addSubview(_completedButton)
        contentView.addConstraint(NSLayoutConstraint(item: _completedButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        keepView(_completedButton, onPage: 1)
    }
    
    private func _configureResultTimeline() {
        contentView.addSubview(_resultTimeline)
        contentView.addConstraint(NSLayoutConstraint(item: _resultTimeline, attribute: .Bottom, relatedBy: .Equal, toItem: _nextButton, attribute: .Top, multiplier: 1, constant: -30))
        scrollView.addConstraint(NSLayoutConstraint(item: _resultTimeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.9, constant: 0))
        keepView(_resultTimeline, onPages: [0, 1, 2])
    }
    
    private func _configureFirstEventView() {
        contentView.addSubview(_firstEventView)
        
        contentView.addConstraint(NSLayoutConstraint(item: _firstEventView, attribute: .CenterY, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: _firstEventView, attribute: .Right, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterX, multiplier: 1, constant: -100))
        
        keepView(_firstEventView, onPages: [0, 1, 2])
    }
    
    private func _configureSecondEventView() {
        contentView.addSubview(_secondEventView)
        
        let verticalConstraint = NSLayoutConstraint(item: _secondEventView, attribute: .CenterY, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0)
        contentView.addConstraint(verticalConstraint)
        let horisontalConstraint = NSLayoutConstraint(item: _secondEventView, attribute: .CenterX, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterX, multiplier: 1, constant: 50)
        scrollView.addConstraint(horisontalConstraint)
        keepView(_secondEventView, onPages: [0, 1, 2])
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: verticalConstraint)
        verticalConstraintAnimation[0] = 52
        verticalConstraintAnimation[1] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horisontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horisontalConstraint)
        horisontalConstraintAnimation[0] = 50
        horisontalConstraintAnimation[1] = 0
        animator.addAnimation(horisontalConstraintAnimation)
    }
    
    private func _configureCompletedEventView() {
        contentView.addSubview(_completedEventView)
        
        let verticalConstraint = NSLayoutConstraint(item: _completedEventView, attribute: .CenterY, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0)
        contentView.addConstraint(verticalConstraint)
        let horisontalConstraint = NSLayoutConstraint(item: _completedEventView, attribute: .CenterX, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterX, multiplier: 1, constant: 50)
        scrollView.addConstraint(horisontalConstraint)
        keepView(_completedEventView, onPages: [1, 2])
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: verticalConstraint)
        verticalConstraintAnimation[1] = 52
        verticalConstraintAnimation[2] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horisontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horisontalConstraint)
        horisontalConstraintAnimation[1] = 50
        horisontalConstraintAnimation[2] = 100
        animator.addAnimation(horisontalConstraintAnimation)
        
        let showAnimation = HideAnimation(view: _completedEventView, showAt: 0.99)
        animator.addAnimation(showAnimation)
    }
    
    override func numberOfPages() -> Int {
        return 5
    }
    
//    MARK: UIInterfaceOrientationMask Portrait only
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}
