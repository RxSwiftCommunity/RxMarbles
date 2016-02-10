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
    private let actionButton = UIButton(type: .Custom)
    private let completedButton = UIButton(type: .Custom)
    private let firstHelpImage = UIImageView()
    private let secondHelpImage = UIImageView()
    private let thirdHelpImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
    
//        configureScrollView()
        configureLogoImageView()
        configureActionButton()
        configureCompletedButton()
        configureResultTimeline()
        configureHelpImageViews()
        configureEventViews()
    }
    
    private func configureScrollView() {
        let backgroundColorAnimation = BackgroundColorAnimation(view: scrollView)
        backgroundColorAnimation[0] = .whiteColor()
        backgroundColorAnimation[2] = .whiteColor()
        backgroundColorAnimation[3] = UIColor(red: 0.14, green: 0.8, blue: 1, alpha: 1)
        animator.addAnimation(backgroundColorAnimation)
    }
    
    private func configureLogoImageView() {
        logoImageView.backgroundColor = .lightGrayColor()
        contentView.addSubview(logoImageView)
        contentView.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 50))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[logo(==80)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["logo" : logoImageView]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[logo(==80)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["logo" : logoImageView]))
        keepView(logoImageView, onPages: [0, 1, 2, 3, 4])
    }
    
    private func configureActionButton() {
        actionButton.setTitle("onNext()", forState: .Normal)
        actionButton.setTitleColor(.blackColor(), forState: .Normal)
        contentView.addSubview(actionButton)
        contentView.addConstraint(NSLayoutConstraint(item: actionButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        keepView(actionButton, onPage: 0)
        
        let hideAnimation = HideAnimation(view: actionButton, hideAt: 0.9)
        animator.addAnimation(hideAnimation)
    }
    
    private func configureCompletedButton() {
        completedButton.setTitle("Completed", forState: .Normal)
        completedButton.setTitleColor(.blackColor(), forState: .Normal)
        contentView.addSubview(completedButton)
        contentView.addConstraint(NSLayoutConstraint(item: completedButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        keepView(completedButton, onPage: 1)
        
        let hideAnimation = HideAnimation(view: completedButton, hideAt: 1.9)
        animator.addAnimation(hideAnimation)
    }
    
    private func configureResultTimeline() {
        contentView.addSubview(resultTimeline)
        contentView.addConstraint(NSLayoutConstraint(item: resultTimeline, attribute: .Bottom, relatedBy: .Equal, toItem: actionButton, attribute: .Top, multiplier: 1, constant: -30))
        scrollView.addConstraint(NSLayoutConstraint(item: resultTimeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 0.9, constant: 0))
        keepView(resultTimeline, onPages: [0, 1, 2])
    }
    
    private func configureHelpImageViews() {
        let size = (view.frame.width > view.frame.height ? view.frame.height : view.frame.width) * 0.8
        let metrics = ["size" : size]
        
        firstHelpImage.backgroundColor = .lightGrayColor()
        contentView.addSubview(firstHelpImage)
        contentView.addConstraint(NSLayoutConstraint(item: firstHelpImage, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(==size)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["image" : firstHelpImage]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[image(==size)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["image" : firstHelpImage]))
        keepView(firstHelpImage, onPage: 0)
        
        secondHelpImage.backgroundColor = .lightGrayColor()
        contentView.addSubview(secondHelpImage)
        contentView.addConstraint(NSLayoutConstraint(item: secondHelpImage, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(==size)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["image" : secondHelpImage]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[image(==size)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["image" : secondHelpImage]))
        keepView(secondHelpImage, onPage: 1)
        
        thirdHelpImage.backgroundColor = .lightGrayColor()
        contentView.addSubview(thirdHelpImage)
        contentView.addConstraint(NSLayoutConstraint(item: thirdHelpImage, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(==size)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["image" : thirdHelpImage]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[image(==size)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["image" : thirdHelpImage]))
        keepView(thirdHelpImage, onPage: 2)
    }
    
    private func configureEventViews() {
        resultTimeline.translatesAutoresizingMaskIntoConstraints = false
        firstEventView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(firstEventView)
        contentView.addConstraint(NSLayoutConstraint(item: firstEventView, attribute: .CenterY, relatedBy: .Equal, toItem: resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: firstEventView, attribute: .CenterX, relatedBy: .Equal, toItem: resultTimeline, attribute: .CenterX, multiplier: 1, constant: -100))
        keepView(firstEventView, onPages: [0, 1, 2])
        
        secondEventView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(secondEventView)
        let secondVerticalConstraint = NSLayoutConstraint(item: secondEventView, attribute: .CenterY, relatedBy: .Equal, toItem: resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0)
        contentView.addConstraint(secondVerticalConstraint)
        let secondHorisontalConstraint = NSLayoutConstraint(item: secondEventView, attribute: .CenterX, relatedBy: .Equal, toItem: resultTimeline, attribute: .CenterX, multiplier: 1, constant: 0)
        scrollView.addConstraint(secondHorisontalConstraint)
        keepView(secondEventView, onPages: [0, 1, 2])
        
        let secondVerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: secondVerticalConstraint)
        secondVerticalAnimation[0] = 52
        secondVerticalAnimation[1] = 0
        animator.addAnimation(secondVerticalAnimation)
        
        let secondHorisontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: secondHorisontalConstraint)
        secondHorisontalAnimation[0] = 50
        secondHorisontalAnimation[1] = 0
        animator.addAnimation(secondHorisontalAnimation)
        
        completedEventView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completedEventView)
        let completedVerticalConstraint = NSLayoutConstraint(item: completedEventView, attribute: .CenterY, relatedBy: .Equal, toItem: resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0)
        contentView.addConstraint(completedVerticalConstraint)
        let completedHorisontalConstraint = NSLayoutConstraint(item: completedEventView, attribute: .CenterX, relatedBy: .Equal, toItem: resultTimeline, attribute: .CenterX, multiplier: 1, constant: 100)
        scrollView.addConstraint(completedHorisontalConstraint)
        keepView(completedEventView, onPages: [1, 2])
        
        let completedVerticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: completedVerticalConstraint)
        completedVerticalAnimation[1] = 52
        completedVerticalAnimation[2] = 0
        animator.addAnimation(completedVerticalAnimation)
        
        let completedHorisontalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: completedHorisontalConstraint)
        completedHorisontalAnimation[1] = 50
        completedHorisontalAnimation[2] = 100
        animator.addAnimation(completedHorisontalAnimation)
        
        let completedHideAnimation = HideAnimation(view: completedEventView, showAt: 0.9)
        animator.addAnimation(completedHideAnimation)
    }
    
    override func numberOfPages() -> Int {
        return 5
    }
}
