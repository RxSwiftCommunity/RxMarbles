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

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class HelpViewController: AnimatedPagingScrollViewController, UITextViewDelegate {
    
    let helpMode: Bool = false
    
    private let _logoImageView  = Image.helpLogo.imageView()
    private let _reactiveXLogo  = Image.rxLogo.imageView()
    private let _resultTimeline = Image.timeLine.imageView()
    
    private let _closeButton = UIButton(type: .Custom)
    
    private let _upArrow   = Image.upArrow.imageView()
    private let _downArrow = Image.downArrow.imageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        _configureLogoImageView()
        _configureReactiveXLogo()
        _configureResultTimeline()
        _configureButtons()
        _configureEventViews()
        
        _configureExplorePage()
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
    
    private func _configureButtons() {
        let experimentNextButton   = UIButton(type: .System)
        let shareNextButton  = UIButton(type: .System)
        let rxNextButton  = UIButton(type: .System)
        let aboutNextButton   = UIButton(type: .System)
        let completedButton    = UIButton(type: .System)
        
        _configureButton(experimentNextButton, onPage: 0, action: "experimentTransition")
        _configureButton(shareNextButton, onPage: 1, action: "shareTransition")
        _configureButton(rxNextButton, onPage: 2, action: "rxTransition")
        _configureButton(aboutNextButton, onPage: 3, action: "aboutTransition")
        _configureButton(completedButton, onPage: 4, action: "completedTransition")
        completedButton.setTitle("onCompleted()", forState: .Normal)
    }
    
    private func _configureButton(next: UIButton, onPage page: CGFloat, action: Selector) {
        next.titleLabel?.font = Font.code(.MonoRegular, size: 14)
        next.setTitle("onNext(   )", forState: .Normal)
        next.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        contentView.addSubview(next)
        keepView(next, onPages: [page, page + 1])
        
        let vertical = NSLayoutConstraint(item: next, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20)
        contentView.addConstraint(vertical)
        
        let outOfScreenAnimation = ConstraintConstantAnimation(superview: contentView, constraint: vertical)
        outOfScreenAnimation[page] = -20
        outOfScreenAnimation[page + 1] = 100
        animator.addAnimation(outOfScreenAnimation)
    }
    
    private func _configureResultTimeline() {
        contentView.addSubview(_resultTimeline)
        _resultTimeline.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = _resultTimeline.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -80)
        
        let centerX = _resultTimeline.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0)
        
        let width = _resultTimeline.widthAnchor.constraintEqualToConstant(300)
        
        view.addConstraints([centerX, centerY, width])
    }
    
    private func _configureEventViews() {
        let explore     = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Explore", color: Color.nextBlue, shape: .Circle))))
        let experiment  = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Experiment", color: Color.nextBlue, shape: .Circle))))
        let share       = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Share", color: Color.nextBlue, shape: .Circle))))
        let rx          = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Rx", color: Color.nextBlue, shape: .Star))))
        let about       = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "About", color: Color.nextBlue, shape: .Star))))
        let completed   = EventView(recorded: RecordedType(time: 0, event: .Completed))
        
        let events = [ explore, experiment, share, rx, about, completed ]
        
        events.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            let height  = $0.heightAnchor.constraintEqualToConstant(50)
            contentView.addConstraint(height)
        }
        
        _tapRecognizerWithAction(explore, action: "exploreTransition")
        _tapRecognizerWithAction(experiment, action: "experimentTransition")
        _tapRecognizerWithAction(share, action: "shareTransition")
        _tapRecognizerWithAction(rx, action: "rxTransition")
        _tapRecognizerWithAction(about, action: "aboutTransition")
        _tapRecognizerWithAction(completed, action: "completedTransition")
        
        let exploreX = explore.centerXAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor, constant: -140)
        let exploreY = explore.centerYAnchor.constraintEqualToAnchor(_resultTimeline.centerYAnchor)
        contentView.addConstraints([exploreX, exploreY])
        
        _configureEventViewAnimations(experiment, page: 0, xOffset: nil)
        _configureEventViewAnimations(share, page: 1, xOffset: nil)
        _configureEventViewAnimations(rx, page: 2, xOffset: nil)
        _configureEventViewAnimations(about, page: 3, xOffset: nil)
        _configureEventViewAnimations(completed, page: 4, xOffset: 135)
        
        completed.hidden = true
        let showCompletedAnimation = HideAnimation(view: completed, showAt: 4.1)
        animator.addAnimation(showCompletedAnimation)
    }
    
    private func _configureEventViewAnimations(eventView: EventView, page: CGFloat, xOffset: CGFloat?) {
        let x = eventView.centerXAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor, constant: pageWidth + 25)
        let y = eventView.centerYAnchor.constraintEqualToAnchor(_resultTimeline.centerYAnchor, constant: 48)
        contentView.addConstraints([x, y])
        let xAnimation = ConstraintConstantAnimation(superview: contentView, constraint: x)
        if page > 0 {
            xAnimation[page - 1] = pageWidth * page + 25
        }
        xAnimation[page] = 25
        if let offset = xOffset {
            xAnimation[page + 1] = offset
        } else {
            xAnimation[page + 1] = -85 + page * 65
        }
        animator.addAnimation(xAnimation)
        let yAnimation = ConstraintConstantAnimation(superview: contentView, constraint: y)
        yAnimation[page] = 48
        yAnimation[page + 1] = 0
        animator.addAnimation(yAnimation)
    }
    
    private func _tapRecognizerWithAction(eventView: EventView, action: Selector) {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: action)
        eventView.addGestureRecognizer(tap)
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
    }
    
    private func _configureExplorePage() {
        let cloudView = UIView()
        cloudView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cloudView)
        
        let centerX = cloudView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor)
        let centerY = cloudView.centerYAnchor.constraintEqualToAnchor(scrollView.centerYAnchor)
        let width   = cloudView.widthAnchor.constraintEqualToConstant(300)
        let height  = cloudView.heightAnchor.constraintEqualToConstant(300)
        
        scrollView.addConstraints([centerX, centerY, width, height])
        
        let relativities = [
            (vertical: (min: -10, max: 10), horizontal: (min: -10, max: 10)),
            (vertical: (min: 10, max: -10), horizontal: (min: 10, max: -10)),
            (vertical: (min: -10, max: -10), horizontal: (min: -10, max: -10)),
            (vertical: (min: 10, max: 10), horizontal: (min: 10, max: 10))
        ]
        
        var cloudLabels: [UILabel] = []
        for i in 0..<4 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            
            cloudLabels.append(label)
            cloudView.addSubview(label)
            
            let labelX  = label.centerXAnchor.constraintEqualToAnchor(cloudView.centerXAnchor)
            let labelY  = label.centerYAnchor.constraintEqualToAnchor(cloudView.centerYAnchor)
            let lWidth  = label.widthAnchor.constraintEqualToAnchor(cloudView.widthAnchor)
            let lHeight = label.heightAnchor.constraintEqualToAnchor(cloudView.heightAnchor)
            
            cloudView.addConstraints([labelX, labelY, lWidth, lHeight])
            
            _addMotionEffectToView(label, relativity: relativities[i])
        }
        
        let attributedStrings = _operatorsCloud()
        
        cloudLabels.forEach {
            let index = cloudLabels.indexOf($0)
            $0.attributedText = attributedStrings[index!]
        }
    }
    
    private func _addMotionEffectToView(view: UIView, relativity: (vertical: (min: Int, max: Int), horizontal: (min: Int, max: Int))) {
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = relativity.vertical.min
        verticalMotionEffect.maximumRelativeValue = relativity.vertical.max
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = relativity.horizontal.min
        horizontalMotionEffect.maximumRelativeValue = relativity.horizontal.max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        view.addMotionEffect(group)
    }
    
    private func _operatorsCloud() -> [NSMutableAttributedString] {
        var strings: [NSMutableAttributedString] = []
        for _ in 0..<4 {
            strings.append(NSMutableAttributedString())
        }
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .ByWordWrapping
        p.lineSpacing = 12
        p.alignment = .Center
        
        let allOperators = Operator.all.shuffle()
        
        var i = 0
        
        for op in allOperators[0...30] {
            let rnd = random() % 3
            
            let operatorString = _attributedOperatorString(op, p: p, rnd: rnd)
            let alphaString = NSMutableAttributedString(attributedString: operatorString)
            alphaString.addAttributes([NSForegroundColorAttributeName : UIColor.clearColor()], range: NSMakeRange(0, operatorString.length))
            switch rnd {
            case 0:
                strings.forEach {
                    $0.appendAttributedString(strings.indexOf($0) == 0 ? operatorString : alphaString)
                }
            case 1:
                strings.forEach {
                    $0.appendAttributedString(strings.indexOf($0) == 1 ? operatorString : alphaString)
                }
            case 2:
                strings.forEach {
                    $0.appendAttributedString(strings.indexOf($0) == 2 ? operatorString : alphaString)
                }
            case 3:
                strings.forEach {
                    $0.appendAttributedString(strings.indexOf($0) == 3 ? operatorString : alphaString)
                }
            default:
                break
            }
            
            if i == 0 {
                strings.forEach {
                    $0.appendAttributedString(NSAttributedString(string: "\n"))
                }
            } else {
                strings.forEach {
                    $0.appendAttributedString(NSAttributedString(string: " "))
                }
            }
            
            i += 1
            
            if i == 30 {
                strings.forEach {
                    $0.appendAttributedString(NSAttributedString(string: "\n"))
                }
            }
        }
        
        return strings
    }
    
    private func _attributedOperatorString(op: Operator, p: NSMutableParagraphStyle, rnd: Int) -> NSMutableAttributedString {
        
        switch rnd {
        case 0:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoBoldItalic, size: 15),
                NSParagraphStyleAttributeName: p
                ])
        case 1:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoBold, size: 13),
                NSParagraphStyleAttributeName: p
                ])
        case 2:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoRegular, size: 13),
                NSParagraphStyleAttributeName: p
                ])
        case 3:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoItalic, size: 12),
                NSParagraphStyleAttributeName: p
                ])
        default:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoRegular, size: 11),
                NSParagraphStyleAttributeName: p
                ])
        }
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
    
    func exploreTransition() {
        _setOffsetAnimated(0)
    }
    
    func experimentTransition() {
        _setOffsetAnimated(1)
    }
    
    func shareTransition() {
        _setOffsetAnimated(2)
    }
    
    func rxTransition() {
        _setOffsetAnimated(3)
    }
    
    func aboutTransition() {
        _setOffsetAnimated(4)
    }
    
    func completedTransition() {
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