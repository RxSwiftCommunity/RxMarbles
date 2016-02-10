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
    
    private let logoImageView = UIImageView(image: UIImage(named: "IntroLogo"))
    private let resultTimeline = UIImageView(image: Image.timeLine)
    private let firstEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "", color: Color.nextGreen, shape: EventShape.Circle))))
    private let secondEventView = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "", color: Color.nextBlue, shape: EventShape.Circle))))
    private let completedEventView = EventView(recorded: RecordedType(time: 0, event: .Completed))
    private let nextButton = UIButton(type: .Custom)
    private let completedButton = UIButton(type: .Custom)
    private let firstHelpImage = UIImageView()
    private let secondHelpImage = UIImageView()
    private let thirdHelpImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        configureLogoImageView()
        configureImageViews()
        configureNextButton()
        configureCompletedButton()
        configureResultTimeline()
        
        configureFirstEventView()
    }
    
    private func configureLogoImageView() {
        contentView.addSubview(logoImageView)
        let verticalConstraint = NSLayoutConstraint(item: logoImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: -100)
        contentView.addConstraint(verticalConstraint)
        keepView(logoImageView, onPages: [0, 1, 2, 3, 4])
        
        let verticalAnimation = ConstraintConstantAnimation(superview: contentView, constraint: verticalConstraint)
        verticalAnimation[0] = 30
        animator.addAnimation(verticalAnimation)
    }
    
    private func configureImageViews() {
        configureImageViewsConstraints(firstHelpImage, page: 0)
        
        configureImageViewsConstraints(secondHelpImage, page: 1)
        
        configureImageViewsConstraints(thirdHelpImage, page: 2)
    }
    
    private func configureImageViewsConstraints(imageView: UIImageView, page: CGFloat) {
        imageView.backgroundColor = .lightGrayColor()
        contentView.addSubview(imageView)
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        keepView(imageView, onPage: page)
    }
    
    private func configureNextButton() {
        nextButton.setTitle("onNext()", forState: .Normal)
        nextButton.setTitleColor(.blackColor(), forState: .Normal)
        contentView.addSubview(nextButton)
        contentView.addConstraint(NSLayoutConstraint(item: nextButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        keepView(nextButton, onPage: 0)
    }
    
    private func configureCompletedButton() {
        completedButton.setTitle("Completed", forState: .Normal)
        completedButton.setTitleColor(.blackColor(), forState: .Normal)
        contentView.addSubview(completedButton)
        contentView.addConstraint(NSLayoutConstraint(item: completedButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        keepView(completedButton, onPage: 1)
    }
    
    private func configureResultTimeline() {
        contentView.addSubview(resultTimeline)
        contentView.addConstraint(NSLayoutConstraint(item: resultTimeline, attribute: .Bottom, relatedBy: .Equal, toItem: nextButton, attribute: .Top, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: resultTimeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.9, constant: 0))
        keepView(resultTimeline, onPages: [0, 1, 2])
    }
    
    private func configureFirstEventView() {
        contentView.addSubview(firstEventView)
        
        contentView.addConstraint(NSLayoutConstraint(item: firstEventView, attribute: .CenterY, relatedBy: .Equal, toItem: resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0))
//        scrollView.addConstraint(NSLayoutConstraint(item: firstEventView, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .Leading, multiplier: 1, constant: 30))
        
        keepView(firstEventView, onPages: [0, 1, 2])
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
