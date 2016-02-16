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

class HelpViewController: AnimatedPagingScrollViewController, UITextViewDelegate {
    
    let helpMode: Bool = false
    
    private let _logoImageView  = Image.helpLogo.imageView()
    private let _reactiveXLogo  = Image.rxLogo.imageView()
    private let _resultTimeline = Image.timeLine.imageView()
    
    private let _sharingEventView   = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Explore", color: Color.nextBlue, shape: .Circle))))
    private let _searchEventView    = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Experiment", color: Color.nextBlue, shape: .Circle))))
    private let _editingEventView   = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Share", color: Color.nextBlue, shape: .Circle))))
    private let _rxSwiftEventView   = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Rx", color: Color.nextBlue, shape: .Star))))
    private let _anjlabEventView    = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "About", color: Color.nextBlue, shape: .Star))))
    private let _completedEventView = EventView(recorded: RecordedType(time: 0, event: .Completed))
    
    private let _searchNextButton   = UIButton(type: .System)
    private let _editingNextButton  = UIButton(type: .System)
    private let _rxSwiftNextButton  = UIButton(type: .System)
    private let _anjlabNextButton   = UIButton(type: .System)
    private let _completedButton    = UIButton(type: .System)
    
    private let _firstHelpView  = UIView()
    private let _secondHelpView = UIView()
    private let _thirdHelpView  = UIView()
    
    private let _closeButton = UIButton(type: .Custom)
    
    private let _upArrow   = Image.upArrow.imageView()
    private let _downArrow = Image.downArrow.imageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        _configureLogoImageView()
        _configureReactiveXLogo()
        
//        _configureImageViews()
        _configureResultTimeline()
        _configureButtons()

//        _configureEventViews()
//
//        _configureExperimentPage()
//        
//        _configureSharePage()
//        
//        _configureRxPage()
//        
//        _configureAnjLabPage()
        
        _configureCloseButton()
    }
    
    private func _configureLogoImageView() {
        contentView.addSubview(_logoImageView)
        
        _logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let scale = CGFloat(0.81666)
        
        _logoImageView.transform = CGAffineTransformScale(_logoImageView.transform, scale, scale)
       
        let centerY = _logoImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -200)
        
        let centerX = _logoImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0)
        
        view.addConstraints([centerY, centerX])
        
        let yAnimation = ConstraintConstantAnimation(superview: view, constraint: centerY)
        
        yAnimation[0] = -200
        yAnimation[4] = -200
        yAnimation[5] = -60
        
        animator.addAnimation(yAnimation)
       
        let xAnimation = ConstraintConstantAnimation(superview: view, constraint: centerX)
        
        
        xAnimation[4] = 0
        xAnimation[5] = -60
        
        animator.addAnimation(xAnimation)
        
        let scaleAnimation = ScaleAnimation(view: _logoImageView)
        scaleAnimation[0] = scale
        scaleAnimation[3] = scale
        scaleAnimation[4] = 1.0
        scaleAnimation[5] = scale
        animator.addAnimation(scaleAnimation)
    }
    
    private func _configureReactiveXLogo() {
        contentView.addSubview(_reactiveXLogo)
        _reactiveXLogo.translatesAutoresizingMaskIntoConstraints = false
        
        _reactiveXLogo.alpha = 0
        
        let centerX = _reactiveXLogo.centerXAnchor.constraintEqualToAnchor(_logoImageView.centerXAnchor)
        
        let centerY = _reactiveXLogo.centerYAnchor.constraintEqualToAnchor(_logoImageView.centerYAnchor)
        
        contentView.addConstraints([centerX, centerY])
        
        let alphaAnimation = AlphaAnimation(view: _reactiveXLogo)
        alphaAnimation[0] = 0.0
        alphaAnimation[2.5] = 0.0
        alphaAnimation[3] = 1.0
        alphaAnimation[3.5] = 0.0
        
        animator.addAnimation(alphaAnimation)
    }
    
    private func _configureCloseButton() {
        _closeButton.setImage(Image.cross, forState: .Normal)
        _closeButton.contentMode = .Center
        
        _ = _closeButton.rx_tap.subscribeNext({ [unowned self] in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        view.addSubview(_closeButton)
        _closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let top = _closeButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20)
        let right = _closeButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10)
        
        let width = _closeButton.widthAnchor.constraintEqualToConstant(40)
        let height = _closeButton.heightAnchor.constraintEqualToConstant(40)
       
        view.addConstraints([top, right, width, height])
    }
    
    private func _configureImageViews() {
        _configureImageViewsConstraints(_firstHelpView, page: 0)
        _configureImageViewsConstraints(_secondHelpView, page: 1)
        _configureImageViewsConstraints(_thirdHelpView, page: 2)
    }
    
    private func _configureImageViewsConstraints(imageView: UIView, page: CGFloat) {
        contentView.addSubview(imageView)
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300))
        keepView(imageView, onPage: page)
    }
    
    private func _configureSearchNextButton() {
        _configureButton(_searchNextButton, onPage: 0)
        _searchNextButton.addTarget(self, action: "addSearchNext", forControlEvents: .TouchUpInside)
    }
    
    private func _configureEditingNextButton() {
        _configureButton(_editingNextButton, onPage: 1)
        _editingNextButton.addTarget(self, action: "addEditingNext", forControlEvents: .TouchUpInside)
    }
    
    private func _configureRxSwiftNextButton() {
        _configureButton(_rxSwiftNextButton, onPage: 2)
        _rxSwiftNextButton.addTarget(self, action: "addRxSwiftNext", forControlEvents: .TouchUpInside)
    }
    
    private func _configureAnjlabNextButton() {
        _configureButton(_anjlabNextButton, onPage: 3)
        _anjlabNextButton.addTarget(self, action: "addAnjlabNext", forControlEvents: .TouchUpInside)
    }
    
    private func _configureCompletedButton() {
        _configureButton(_completedButton, onPage: 4)
        _completedButton.setTitle("onCompleted()", forState: .Normal)
        _completedButton.addTarget(self, action: "addCompleted", forControlEvents: .TouchUpInside)
    }
    
    private func _configureButton(next: UIButton, onPage page: CGFloat) {
        next.titleLabel?.font = Font.code(14)
        next.setTitle("onNext(   )", forState: .Normal)
        contentView.addSubview(next)
        let vertical = NSLayoutConstraint(item: next, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20)
        contentView.addConstraint(vertical)
        keepView(next, onPages: [page, page + 1])
        
        let outOfScreenAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        outOfScreenAnimation[page] = -20
        outOfScreenAnimation[page + 1] = 100
        animator.addAnimation(outOfScreenAnimation)
    }
    
    private func _configureButtons() {
        _configureSearchNextButton()
        _configureEditingNextButton()
        _configureRxSwiftNextButton()
        _configureAnjlabNextButton()
        _configureCompletedButton()
    }
    
    private func _configureResultTimeline() {
        contentView.addSubview(_resultTimeline)
        _resultTimeline.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = _resultTimeline.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 180)
        
        let centerX = _resultTimeline.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0)
        
        let width = _resultTimeline.widthAnchor.constraintEqualToConstant(300)
        
        view.addConstraints([centerX, centerY, width])
    }
    
    private func _configureSharingEventView() {
        contentView.addSubview(_sharingEventView)
        
        contentView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .CenterY, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .CenterX, relatedBy: .Equal, toItem: _resultTimeline, attribute: .CenterX, multiplier: 1, constant: -125))
        _sharingEventView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        _sharingEventView.addConstraint(NSLayoutConstraint(item: _sharingEventView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        
        keepView(_sharingEventView, onPages: [0, 1, 2, 3, 4, 5])
        
        _configureEventViewTapRecognizer(_sharingEventView)
    }
    
    private func _configureSearchEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_searchEventView)
        keepView(_searchEventView, onPages: [0, 1, 2, 3, 4, 5])
        
        _configureEventViewAnimations(0, xOffset: -75, horizontal: horizontal, vertical: vertical)
        _configureEventViewTapRecognizer(_searchEventView)
    }
    
    private func _configureEditingEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_editingEventView)
        keepView(_editingEventView, onPages: [1, 2, 3, 4, 5])
        
        _configureEventViewAnimations(1, xOffset: -25, horizontal: horizontal, vertical: vertical)
        _configureEventViewTapRecognizer(_editingEventView)
    }
    
    private func _configureRxSwiftEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_rxSwiftEventView)
        keepView(_rxSwiftEventView, onPages: [2, 3, 4, 5])
        
        _configureEventViewAnimations(2, xOffset: 25, horizontal: horizontal, vertical: vertical)
        _configureEventViewTapRecognizer(_rxSwiftEventView)
    }
    
    private func _configureAnjlabEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_anjlabEventView)
        keepView(_anjlabEventView, onPages: [3, 4, 5])
        
        _configureEventViewAnimations(3, xOffset: 75, horizontal: horizontal, vertical: vertical)
        _configureEventViewTapRecognizer(_anjlabEventView)
    }
    
    private func _configureCompletedEventView() {
        let (vertical, horizontal) = _configureEventViewConstraints(_completedEventView)
        keepView(_completedEventView, onPages: [4, 5])
        
        _configureEventViewAnimations(4, xOffset: 125, horizontal: horizontal, vertical: vertical)
        let showAnimation = HideAnimation(view: _completedEventView, showAt: 4.1)
        animator.addAnimation(showAnimation)
    }
    
    private func _configureEventViews() {
        _configureSharingEventView()
        _configureSearchEventView()
        _configureEditingEventView()
        _configureRxSwiftEventView()
        _configureAnjlabEventView()
        _configureCompletedEventView()
    }
    
    private func _configureShareIcons() {
        let evernote     = UIImageView(image: Image.evernote)
        let facebook     = UIImageView(image: Image.facebook)
        let hanghout     = UIImageView(image: Image.hanghout)
        let mail         = UIImageView(image: Image.mail)
        let messenger    = UIImageView(image: Image.messenger)
        let skype        = UIImageView(image: Image.skype)
        let slack        = UIImageView(image: Image.slack)
        let trello       = UIImageView(image: Image.trello)
        let twitter      = UIImageView(image: Image.twitter)
        let viber        = UIImageView(image: Image.viber)
        
        let shareLogos = [
            evernote,
            facebook,
            hanghout,
            mail,
            messenger,
            skype,
            slack,
            trello,
            twitter,
            viber
        ]
        
        shareLogos.forEach {
            contentView.addSubview($0)
            keepView($0, onPage: 2)
            
            let scaleAnimation = ScaleAnimation(view: $0)
            scaleAnimation[1.1] = 0.1
            scaleAnimation[2] = 1.0
            scaleAnimation[2.9] = 0.1
            animator.addAnimation(scaleAnimation)
            
            let rotateAnimation = RotationAnimation(view: $0)
            rotateAnimation[1.1] = -3600.0
            rotateAnimation[2] = 0.0
            rotateAnimation[2.9] = 3600.0
            animator.addAnimation(rotateAnimation)
        }
        
        contentView.addConstraint(NSLayoutConstraint(item: facebook, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 318))
        scrollView.addConstraint(NSLayoutConstraint(item: facebook, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -100))
        contentView.addConstraint(NSLayoutConstraint(item: twitter, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 318))
        scrollView.addConstraint(NSLayoutConstraint(item: twitter, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -50))
        contentView.addConstraint(NSLayoutConstraint(item: trello, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 318))
        contentView.addConstraint(NSLayoutConstraint(item: slack, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 318))
        scrollView.addConstraint(NSLayoutConstraint(item: slack, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 50))
        contentView.addConstraint(NSLayoutConstraint(item: mail, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 318))
        scrollView.addConstraint(NSLayoutConstraint(item: mail, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 100))
        contentView.addConstraint(NSLayoutConstraint(item: messenger, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 379))
        scrollView.addConstraint(NSLayoutConstraint(item: messenger, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -100))
        contentView.addConstraint(NSLayoutConstraint(item: viber, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 379))
        scrollView.addConstraint(NSLayoutConstraint(item: viber, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -50))
        contentView.addConstraint(NSLayoutConstraint(item: skype, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 379))
        contentView.addConstraint(NSLayoutConstraint(item: hanghout, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 379))
        scrollView.addConstraint(NSLayoutConstraint(item: hanghout, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 50))
        contentView.addConstraint(NSLayoutConstraint(item: evernote, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 379))
        scrollView.addConstraint(NSLayoutConstraint(item: evernote, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 100))
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
    
    private func _configureEventViewAnimations(page: CGFloat, xOffset: CGFloat, horizontal: NSLayoutConstraint, vertical: NSLayoutConstraint) {
        
        let verticalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        verticalConstraintAnimation[page] = 48
        verticalConstraintAnimation[page + 1] = 0
        animator.addAnimation(verticalConstraintAnimation)
        
        let horizontalConstraintAnimation = ConstraintConstantAnimation(superview: contentView, constraint: horizontal)
        if page > 0 {
            horizontalConstraintAnimation[page - 1] = pageWidth + 25
        }
        horizontalConstraintAnimation[page] = 25
        horizontalConstraintAnimation[page + 1] = xOffset
        animator.addAnimation(horizontalConstraintAnimation)
    }
    
    private func _configureEventViewTapRecognizer(eventView: EventView) {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "eventViewTap:")
        eventView.addGestureRecognizer(tap)
    }
    
    private func _configureExperimentPage() {
        let navBar = UIImageView(image: Image.navBarExperiment)
        let timeline = UIImageView(image: Image.timelineExperiment)
        let editLabel = UILabel()
        let timelineLabel = UILabel()
        let experimentLabel = UILabel()
        
        contentView.addSubview(navBar)
        contentView.addConstraint(NSLayoutConstraint(item: navBar, attribute: .Top, relatedBy: .Equal, toItem: _logoImageView, attribute: .Bottom, multiplier: 1, constant: 30))
        keepView(navBar, onPage: 1)
        
        editLabel.text = "Add new,\nchange colors and values in edit mode"
        editLabel.numberOfLines = 2
        editLabel.font = Font.text(13)
        contentView.addSubview(editLabel)
        contentView.addConstraint(NSLayoutConstraint(item: editLabel, attribute: .Top, relatedBy: .Equal, toItem: navBar, attribute: .Bottom, multiplier: 1, constant: 40))
        scrollView.addConstraint(NSLayoutConstraint(item: editLabel, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1, constant: pageWidth * 1 - 25))
        keepView(editLabel, onPage: 1)
        
        contentView.addSubview(timeline)
        contentView.addConstraint(NSLayoutConstraint(item: timeline, attribute: .Top, relatedBy: .Equal, toItem: navBar, attribute: .Bottom, multiplier: 1, constant: 130))
        keepView(timeline, onPage: 1)
        
        contentView.addSubview(_upArrow)
        let upVertical = NSLayoutConstraint(item: _upArrow, attribute: .Top, relatedBy: .Equal, toItem: _logoImageView, attribute: .Bottom, multiplier: 1, constant: 84)
        contentView.addConstraint(upVertical)
        let upHorizontal = NSLayoutConstraint(item: _upArrow, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1, constant: pageWidth * 1 + 110)
        scrollView.addConstraint(upHorizontal)
        keepView(_upArrow, onPages: [1, 2])
        
        let upArrowMoveAnimation = ConstraintConstantAnimation(superview: contentView, constraint: upHorizontal)
        upArrowMoveAnimation[1] = pageWidth * 1 + 110
        upArrowMoveAnimation[2] = pageWidth * 2 + 80
        animator.addAnimation(upArrowMoveAnimation)
        
        contentView.addSubview(_downArrow)
        let downVertical = NSLayoutConstraint(item: _downArrow, attribute: .Top, relatedBy: .Equal, toItem: _logoImageView, attribute: .Bottom, multiplier: 1, constant: 150)
        contentView.addConstraint(downVertical)
        let downHorizontal = NSLayoutConstraint(item: _downArrow, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1, constant: pageWidth * 1 + 110)
        scrollView.addConstraint(downHorizontal)
        keepView(_downArrow, onPage: 1)
        
        timelineLabel.text = "move events around"
        timelineLabel.font = Font.text(13)
        contentView.addSubview(timelineLabel)
        contentView.addConstraint(NSLayoutConstraint(item: timelineLabel, attribute: .Top, relatedBy: .Equal, toItem: timeline, attribute: .Bottom, multiplier: 1, constant: 20))
        keepView(timelineLabel, onPage: 1)
        
        experimentLabel.text = "Edit. Learn. Experiment."
        experimentLabel.font = Font.text(14)
        contentView.addSubview(experimentLabel)
        contentView.addConstraint(NSLayoutConstraint(item: experimentLabel, attribute: .Top, relatedBy: .Equal, toItem: navBar, attribute: .Bottom, multiplier: 1, constant: 303))
        keepView(experimentLabel, onPage: 1)
    }
    
    private func _configureSharePage() {
        let navBar = UIImageView(image: Image.navBarShare)
        let shareLabel = UILabel()
        let spreadTheWordLabel = UILabel()
        contentView.addSubview(navBar)
        contentView.addConstraint(NSLayoutConstraint(item: navBar, attribute: .Top, relatedBy: .Equal, toItem: _logoImageView, attribute: .Bottom, multiplier: 1, constant: 30))
        keepView(navBar, onPage: 2)
        
        shareLabel.text = "Share you diagrams"
        shareLabel.font = Font.text(13)
        contentView.addSubview(shareLabel)
        contentView.addConstraint(NSLayoutConstraint(item: shareLabel, attribute: .Top, relatedBy: .Equal, toItem: navBar, attribute: .Bottom, multiplier: 1, constant: 50))
        let shareLabelHorizontal = NSLayoutConstraint(item: shareLabel, attribute: .CenterX, relatedBy: .Equal, toItem: navBar, attribute: .CenterX, multiplier: 1, constant: -15)
        scrollView.addConstraint(shareLabelHorizontal)
        keepView(shareLabel, onPage: 2)
        
        spreadTheWordLabel.text = "Spread the word"
        spreadTheWordLabel.font = Font.text(14)
        contentView.addSubview(spreadTheWordLabel)
        contentView.addConstraint(NSLayoutConstraint(item: spreadTheWordLabel, attribute: .Top, relatedBy: .Equal, toItem: navBar, attribute: .Bottom, multiplier: 1, constant: 303))
        keepView(spreadTheWordLabel, onPage: 2)
        
        _configureShareIcons()
    }
    
    private func _configureRxPage() {
        let manyLikeLabel = UILabel()
        let erikMeijerTwitter = UIImageView(image: Image.twitter)
        let erikMeijerTextView = UITextView()
        let krunoslavZaherTwitter = UIImageView(image: Image.twitter)
        let krunoslavZaherTextView = UITextView()
        let rxSwiftLabel = UILabel()
        let githubButton = UIButton(type: .Custom)
        let alasLabel = UILabel()
        
        manyLikeLabel.text = "Many ❤️👍🍻👋 to"
        manyLikeLabel.font = Font.text(18)
        contentView.addSubview(manyLikeLabel)
        contentView.addConstraint(NSLayoutConstraint(item: manyLikeLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 160))
        keepView(manyLikeLabel, onPage: 3)
        
        erikMeijerTwitter.alpha = 0.3
        contentView.addSubview(erikMeijerTwitter)
        contentView.addConstraint(NSLayoutConstraint(item: erikMeijerTwitter, attribute: .Top, relatedBy: .Equal, toItem: manyLikeLabel, attribute: .Bottom, multiplier: 1, constant: 40))
        keepView(erikMeijerTwitter, onPage: 3)
        
        erikMeijerTextView.attributedText = _erikMeijerText()
        erikMeijerTextView.delegate = self
        erikMeijerTextView.editable = false
        erikMeijerTextView.scrollEnabled = false
        erikMeijerTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        erikMeijerTextView.textAlignment = .Center
        contentView.addSubview(erikMeijerTextView)
        contentView.addConstraint(NSLayoutConstraint(item: erikMeijerTextView, attribute: .Top, relatedBy: .Equal, toItem: erikMeijerTwitter, attribute: .Bottom, multiplier: 1, constant: 10))
        erikMeijerTextView.addConstraint(NSLayoutConstraint(item: erikMeijerTextView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250))
        erikMeijerTextView.addConstraint(NSLayoutConstraint(item: erikMeijerTextView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        keepView(erikMeijerTextView, onPage: 3)
        
        krunoslavZaherTwitter.alpha = 0.3
        contentView.addSubview(krunoslavZaherTwitter)
        contentView.addConstraint(NSLayoutConstraint(item: krunoslavZaherTwitter, attribute: .Top, relatedBy: .Equal, toItem: erikMeijerTextView, attribute: .Bottom, multiplier: 1, constant: 35))
        keepView(krunoslavZaherTwitter, onPage: 3)
        
        krunoslavZaherTextView.attributedText = _krunoslavZaherText()
        krunoslavZaherTextView.delegate = self
        krunoslavZaherTextView.editable = false
        krunoslavZaherTextView.scrollEnabled = false
        krunoslavZaherTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        krunoslavZaherTextView.textAlignment = .Center
        contentView.addSubview(krunoslavZaherTextView)
        contentView.addConstraint(NSLayoutConstraint(item: krunoslavZaherTextView, attribute: .Top, relatedBy: .Equal, toItem: krunoslavZaherTwitter, attribute: .Bottom, multiplier: 1, constant: 10))
        krunoslavZaherTextView.addConstraint(NSLayoutConstraint(item: krunoslavZaherTextView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250))
        krunoslavZaherTextView.addConstraint(NSLayoutConstraint(item: krunoslavZaherTextView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50))
        keepView(krunoslavZaherTextView, onPage: 3)
        
        rxSwiftLabel.text = "⭐ RxSwift on"
        rxSwiftLabel.font = Font.text(14)
        contentView.addSubview(rxSwiftLabel)
        contentView.addConstraint(NSLayoutConstraint(item: rxSwiftLabel, attribute: .Top, relatedBy: .Equal, toItem: krunoslavZaherTextView, attribute: .Bottom, multiplier: 1, constant: 60))
        scrollView.addConstraint(NSLayoutConstraint(item: rxSwiftLabel, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1, constant: pageWidth * 3 - 25))
        keepView(rxSwiftLabel, onPage: 3)
        
        githubButton.setImage(Image.github, forState: .Normal)
        githubButton.addTarget(self, action: "openRxSwiftOnGithub", forControlEvents: .TouchUpInside)
        contentView.addSubview(githubButton)
        contentView.addConstraint(NSLayoutConstraint(item: githubButton, attribute: .CenterY, relatedBy: .Equal, toItem: rxSwiftLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: githubButton, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1, constant: pageWidth * 3 + 50))
        keepView(githubButton, onPage: 3)
        
        alasLabel.text = "¯\\_(ツ)_/¯"
        contentView.addSubview(alasLabel)
        contentView.addConstraint(NSLayoutConstraint(item: alasLabel, attribute: .Top, relatedBy: .Equal, toItem: rxSwiftLabel, attribute: .Bottom, multiplier: 1, constant: 9))
        keepView(alasLabel, onPage: 3)
    }
    
    private func _erikMeijerText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "Erik ", attributes: [NSFontAttributeName : Font.text(14)])
        let twitter = NSMutableAttributedString(string: "@headinthebox", attributes:
            [
                NSLinkAttributeName             : NSURL(string: "https://twitter.com/headinthebox")!,
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(twitter)
        text.appendAttributedString(NSAttributedString(string: " Meijer\nfor his work on ", attributes: [NSFontAttributeName : Font.text(14)]))
        let reactivex = NSMutableAttributedString(string: "Reactive Extensions", attributes:
            [
                NSLinkAttributeName             : NSURL(string: "http://reactivex.io")!,
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(reactivex)
        return text
    }
    
    private func _krunoslavZaherText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "Krunoslav ", attributes: [NSFontAttributeName : Font.text(14)])
        let twitter = NSMutableAttributedString(string: "@KrunoslavZaher", attributes:
            [
                NSLinkAttributeName             : NSURL(string: "https://twitter.com/KrunoslavZaher")!,
                NSForegroundColorAttributeName  : UIColor.blackColor(),
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(twitter)
        text.appendAttributedString(NSAttributedString(string: " Zaher\nfor ", attributes: [NSFontAttributeName : Font.text(14)]))
        let reactivex = NSMutableAttributedString(string: "RxSwift", attributes:
            [
                NSLinkAttributeName             : Link.rxswift,
                NSForegroundColorAttributeName  : UIColor.blackColor(),
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(reactivex)
        return text
    }
    
    private func _configureAnjLabPage() {
        let anjLabButton       = UIButton(type: .Custom)
        let rxMarblesLabel     = UILabel()
        let versionLabel       = UILabel()
        let developedByLabel   = UILabel()
        
        rxMarblesLabel.text = "RxMarbles"
        rxMarblesLabel.font = Font.text(25)
        contentView.addSubview(rxMarblesLabel)
        contentView.addConstraint(NSLayoutConstraint(item: rxMarblesLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 248))
        let rxHorizontal = NSLayoutConstraint(item: rxMarblesLabel, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1, constant: pageWidth * 4 - 10)
        scrollView.addConstraint(rxHorizontal)
        rxMarblesLabel.addConstraint(NSLayoutConstraint(item: rxMarblesLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200))
        keepView(rxMarblesLabel, onPage: 4)
        
        let rxHorizontalAnimation = ConstraintConstantAnimation(superview: contentView, constraint: rxHorizontal)
        rxHorizontalAnimation[4] = pageWidth * 4 - 10
        rxHorizontalAnimation[4.9] = pageWidth * 5 + 300
        animator.addAnimation(rxHorizontalAnimation)
        
        versionLabel.text = "v1.0.0"
        contentView.addSubview(versionLabel)
        contentView.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .Top, relatedBy: .Equal, toItem: rxMarblesLabel, attribute: .Bottom, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .Leading, relatedBy: .Equal, toItem: rxMarblesLabel, attribute: .Leading, multiplier: 1, constant: 0))
        versionLabel.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        keepView(versionLabel, onPage: 4)
        
        developedByLabel.text = "developed by"
        contentView.addSubview(developedByLabel)
        contentView.addConstraint(NSLayoutConstraint(item: developedByLabel, attribute: .Top, relatedBy: .Equal, toItem: versionLabel, attribute: .Bottom, multiplier: 1, constant: 57))
        keepView(developedByLabel, onPage: 4)
        
        anjLabButton.setImage(Image.anjlab, forState: .Normal)
        anjLabButton.addTarget(self, action: "openAnjLab", forControlEvents: .TouchUpInside)
        contentView.addSubview(anjLabButton)
        contentView.addConstraint(NSLayoutConstraint(item: anjLabButton, attribute: .Top, relatedBy: .Equal, toItem: developedByLabel, attribute: .Bottom, multiplier: 1, constant: 32))
        keepView(anjLabButton, onPage: 4)
    }
    
    override func numberOfPages() -> Int {
        return 6
    }
    
//    MARK: Navigation
    
    func eventViewTap(r: UITapGestureRecognizer) {
        switch r.view as! EventView {
        case _sharingEventView:
            addSharingNext()
        case _searchEventView:
            addSearchNext()
        case _editingEventView:
            addEditingNext()
        case _rxSwiftEventView:
            addRxSwiftNext()
        case _anjlabEventView:
            addAnjlabNext()
        default:
            break
        }
    }
    
    func addSharingNext() {
        _setOffsetAnimated(0)
    }
    
    func addSearchNext() {
        _setOffsetAnimated(1)
    }
    
    func addEditingNext() {
        _setOffsetAnimated(2)
    }
    
    func addRxSwiftNext() {
        _setOffsetAnimated(3)
    }
    
    func addAnjlabNext() {
        _setOffsetAnimated(4)
    }
    
    func addCompleted() {
        _setOffsetAnimated(5)
    }
    
    func _setOffsetAnimated(offset: CGFloat) {
        scrollView.setContentOffset(CGPointMake(self.pageWidth * offset, 0), animated: true)
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
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    MARK: UIInterfaceOrientationMask Portrait only
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
//    MARK: UITextViewDelegate
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return true
    }
}