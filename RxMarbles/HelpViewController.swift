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
    
    let helpMode: Bool = false
    
    private let _logoImageView  = UIImageView(image: Image.helpLogo)
    private let _reactiveXLogo  = UIImageView(image: Image.rxLogo)
    private let _resultTimeline = UIImageView(image: Image.timeLine)
    
    private let _evernote     = UIImageView(image: Image.evernote)
    private let _facebook     = UIImageView(image: Image.facebook)
    private let _hanghout     = UIImageView(image: Image.hanghout)
    private let _mail         = UIImageView(image: Image.mail)
    private let _messenger    = UIImageView(image: Image.messenger)
    private let _skype        = UIImageView(image: Image.skype)
    private let _slack        = UIImageView(image: Image.slack)
    private let _trello       = UIImageView(image: Image.trello)
    private let _twitter      = UIImageView(image: Image.twitter)
    private let _viber        = UIImageView(image: Image.viber)
    
    private let _sharingEventView   = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Explore", color: Color.nextBlue, shape: EventShape.Circle))))
    private let _searchEventView    = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Experiment", color: Color.nextBlue, shape: EventShape.Circle))))
    private let _editingEventView   = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Share", color: Color.nextBlue, shape: EventShape.Circle))))
    private let _rxSwiftEventView   = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "RxSwift", color: Color.nextBlue, shape: EventShape.Star))))
    private let _anjlabEventView    = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "AnjLab", color: Color.nextBlue, shape: EventShape.Star))))
    private let _completedEventView = EventView(recorded: RecordedType(time: 0, event: .Completed))
    
    private let _searchNextButton   = UIButton(type: .System)
    private let _editingNextButton  = UIButton(type: .System)
    private let _rxSwiftNextButton  = UIButton(type: .System)
    private let _anjlabNextButton   = UIButton(type: .System)
    private let _completedButton    = UIButton(type: .System)
    
    private let _firstHelpView  = UIView()
    private let _secondHelpView = UIView()
    private let _thirdHelpView  = UIView()
    
    private let _poweredByRxLabel   = UILabel()
    private let _addStarButton      = UIButton(type: .System)
    
    private let _anjLabButton       = UIButton(type: .Custom)
    private let _rxMarblesLabel     = UILabel()
    private let _versionLabel       = UILabel()
    private let _developedByLabel   = UILabel()
    
    private let _closeButton = UIButton(type: .Custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        _configureLogoImageView()
        _configureReactiveXLogo()
        _configureCloseButton()
        
        _configureImageViews()
        
        _configureButtons()
        
        _configureResultTimeline()
        
        _configureEventViews()
        
        _configureShareIcons()
        
        _configurePoweredByRxLabel()
        _configureAddStarButton()
        
        _configureAnjLabPage()
    }
    
    private func _configureLogoImageView() {
        contentView.addSubview(_logoImageView)
        let vertical = NSLayoutConstraint(item: _logoImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 100)
        contentView.addConstraint(vertical)
        keepView(_logoImageView, onPages: [0, 1, 2, 3, 4, 5])
        
        let verticalAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        verticalAnimation[0] = 100
        verticalAnimation[2.5] = 100
        verticalAnimation[2.6] = 90
        verticalAnimation[2.7] = 120
        verticalAnimation[2.8] = 80
        verticalAnimation[2.9] = 110
        verticalAnimation[3]   = 100
        verticalAnimation[3.1] = 90
        verticalAnimation[3.2] = 120
        verticalAnimation[3.3] = 85
        verticalAnimation[3.4] = 110
        verticalAnimation[3.5] = 100
        verticalAnimation[4] = 100
        verticalAnimation[5] = scrollView.frame.height / 2 - _logoImageView.frame.height / 2
        animator.addAnimation(verticalAnimation)
    }
    
    private func _configureReactiveXLogo() {
        contentView.addSubview(_reactiveXLogo)
        let horizontal = NSLayoutConstraint(item: _reactiveXLogo, attribute: .CenterX, relatedBy: .Equal, toItem: _logoImageView, attribute: .CenterX, multiplier: 1, constant: 0)
        contentView.addConstraint(horizontal)
        let vertical = NSLayoutConstraint(item: _reactiveXLogo, attribute: .CenterY, relatedBy: .Equal, toItem: _logoImageView, attribute: .CenterY, multiplier: 1, constant: 0)
        contentView.addConstraint(vertical)
        
        let alphaAnimation = AlphaAnimation(view: _reactiveXLogo)
        alphaAnimation[0] = 0.0
        alphaAnimation[2.5] = 0.0
        alphaAnimation[3] = 1.0
        alphaAnimation[3.5] = 0.0
        animator.addAnimation(alphaAnimation)
        
        keepView(_reactiveXLogo, onPage: 3)
    }
    
    private func _configureCloseButton() {
        contentView.addSubview(_closeButton)
        _closeButton.setBackgroundImage(Image.cross, forState: .Normal)
        _closeButton.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        contentView.addConstraint(NSLayoutConstraint(item: _closeButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 30))
        scrollView.addConstraint(NSLayoutConstraint(item: _closeButton, attribute: .CenterX, relatedBy: .Equal, toItem: _logoImageView, attribute: .CenterX, multiplier: 1, constant: 150))
        keepView(_closeButton, onPages: [0, 1, 2, 3, 4, 5])
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
        contentView.addConstraint(NSLayoutConstraint(item: _resultTimeline, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -80))
        scrollView.addConstraint(NSLayoutConstraint(item: _resultTimeline, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300))
        keepView(_resultTimeline, onPages: [0, 1, 2, 3, 4, 5])
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
        let shareLogos = [
            _evernote,
            _facebook,
            _hanghout,
            _mail,
            _messenger,
            _skype,
            _slack,
            _trello,
            _twitter,
            _viber
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
        
        contentView.addConstraint(NSLayoutConstraint(item: _facebook, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: -30))
        scrollView.addConstraint(NSLayoutConstraint(item: _facebook, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -100))
        contentView.addConstraint(NSLayoutConstraint(item: _twitter, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: -30))
        scrollView.addConstraint(NSLayoutConstraint(item: _twitter, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -50))
        contentView.addConstraint(NSLayoutConstraint(item: _trello, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: -30))
        contentView.addConstraint(NSLayoutConstraint(item: _slack, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: -30))
        scrollView.addConstraint(NSLayoutConstraint(item: _slack, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 50))
        contentView.addConstraint(NSLayoutConstraint(item: _mail, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: -30))
        scrollView.addConstraint(NSLayoutConstraint(item: _mail, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 100))
        contentView.addConstraint(NSLayoutConstraint(item: _messenger, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 30))
        scrollView.addConstraint(NSLayoutConstraint(item: _messenger, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -100))
        contentView.addConstraint(NSLayoutConstraint(item: _viber, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 30))
        scrollView.addConstraint(NSLayoutConstraint(item: _viber, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: -50))
        contentView.addConstraint(NSLayoutConstraint(item: _skype, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: _hanghout, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 30))
        scrollView.addConstraint(NSLayoutConstraint(item: _hanghout, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 50))
        contentView.addConstraint(NSLayoutConstraint(item: _evernote, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 30))
        scrollView.addConstraint(NSLayoutConstraint(item: _evernote, attribute: .CenterX, relatedBy: .Equal, toItem: _thirdHelpView, attribute: .CenterX, multiplier: 1, constant: 100))
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
    
    private func _configurePoweredByRxLabel() {
        _poweredByRxLabel.text = "Powered by RxSwift"
        _poweredByRxLabel.textColor = .blackColor()
        _poweredByRxLabel.textAlignment = .Center
        _poweredByRxLabel.font = Font.code(16)
        contentView.addSubview(_poweredByRxLabel)
        contentView.addConstraint(NSLayoutConstraint(item: _poweredByRxLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        keepView(_poweredByRxLabel, onPage: 3)
    }
    
    private func _configureAddStarButton() {
        _addStarButton.setTitle("Add Star", forState: .Normal)
        _addStarButton.titleLabel?.font = Font.code(12)
        _addStarButton.addTarget(self, action: "openRxSwiftOnGithub", forControlEvents: .TouchUpInside)
        contentView.addSubview(_addStarButton)
        contentView.addConstraint(NSLayoutConstraint(item: _addStarButton, attribute: .Top, relatedBy: .Equal, toItem: _poweredByRxLabel, attribute: .Bottom, multiplier: 1, constant: 30))
        keepView(_addStarButton, onPage: 3)
        
        let showAnimations = HideAnimation(view: _addStarButton, showAt: 2.8)
        animator.addAnimation(showAnimations)
        
        let alphaAnimations = AlphaAnimation(view: _addStarButton)
        alphaAnimations[2.8] = 0.0
        alphaAnimations[3.0] = 1.0
        alphaAnimations[3.2] = 0.0
        animator.addAnimation(alphaAnimations)
    }
    
    private func _configureAnjLabPage() {
        _rxMarblesLabel.text = "RxMarbles"
        _rxMarblesLabel.font = UIFont(name: "Menlo-Regular", size: 25)
        contentView.addSubview(_rxMarblesLabel)
        contentView.addConstraint(NSLayoutConstraint(item: _rxMarblesLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: -50))
        keepView(_rxMarblesLabel, onPage: 4)
        
        _versionLabel.text = "v1.0.0"
        contentView.addSubview(_versionLabel)
        contentView.addConstraint(NSLayoutConstraint(item: _versionLabel, attribute: .Top, relatedBy: .Equal, toItem: _rxMarblesLabel, attribute: .Bottom, multiplier: 1, constant: 0))
        keepView(_versionLabel, onPage: 4)
        
        _developedByLabel.text = "developed by"
        contentView.addSubview(_developedByLabel)
        contentView.addConstraint(NSLayoutConstraint(item: _developedByLabel, attribute: .Top, relatedBy: .Equal, toItem: _versionLabel, attribute: .Bottom, multiplier: 1, constant: 30))
        keepView(_developedByLabel, onPage: 4)
        
        _anjLabButton.setImage(Image.anjlab, forState: .Normal)
        _anjLabButton.addTarget(self, action: "openAnjLab", forControlEvents: .TouchUpInside)
        contentView.addSubview(_anjLabButton)
        contentView.addConstraint(NSLayoutConstraint(item: _anjLabButton, attribute: .Top, relatedBy: .Equal, toItem: _developedByLabel, attribute: .Bottom, multiplier: 1, constant: 30))
        keepView(_anjLabButton, onPage: 4)
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
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentOffset = CGPointMake(self.pageWidth * offset, 0)
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
}