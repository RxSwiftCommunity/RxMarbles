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
    
    var helpMode: Bool = true
    
    private let _logoImageView  = Image.helpLogo.imageView()
    private let _reactiveXLogo  = Image.rxLogo.imageView()
    private let _resultTimeline = Image.timeLine.imageView()
    
    private let _closeButton = UIButton(type: .Custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        _configureLogoImageView()
        _configureReactiveXLogo()
        _configureResultTimeline()
        _configureButtons()
        _configureEventViews()
        
        _configureExplorePage()
        _configureExperimentPage()
        _configureSharePage()
        
        if helpMode {
            _configureRxPage()
            _configureAboutPage()
            _configureCloseButton()
        }
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
        if helpMode {
            yAnimation[3] = -200
            yAnimation[4] = -60
            yAnimation[5] = 0
        } else {
            yAnimation[2] = -200
            yAnimation[3] = 0
        }
        
        animator.addAnimation(yAnimation)
       
        let xAnimation = ConstraintConstantAnimation(superview: view, constraint: centerX)
        
        xAnimation[3] = 0
        xAnimation[4] = -60
        xAnimation[5] = 0
        
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
        
        if helpMode {
            let alphaAnimation = AlphaAnimation(view: _reactiveXLogo)
            alphaAnimation[0] = 0.0
            alphaAnimation[2.5] = 0.0
            alphaAnimation[3] = 1.0
            alphaAnimation[3.5] = 0.0
            animator.addAnimation(alphaAnimation)
        }
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
        if helpMode {
            _configureButton(rxNextButton, onPage: 2, action: "rxTransition")
            _configureButton(aboutNextButton, onPage: 3, action: "aboutTransition")
            _configureButton(completedButton, onPage: 4, action: "completedTransition")
        } else {
            _configureButton(completedButton, onPage: 2, action: "rxTransition")
        }
        
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
        
        let helpEvents = [ explore, experiment, share, rx, about, completed ]
        let introEvents = [ explore, experiment, share, completed ]
        let events = helpMode ? helpEvents : introEvents
        
        events.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            let width   = $0.widthAnchor.constraintEqualToConstant(20)
            let height  = $0.heightAnchor.constraintEqualToConstant(50)
            contentView.addConstraints([width, height])
        }
        
        _tapRecognizerWithAction(explore, action: "exploreTransition")
        _tapRecognizerWithAction(experiment, action: "experimentTransition")
        _tapRecognizerWithAction(share, action: "shareTransition")
        if helpMode {
            _tapRecognizerWithAction(rx, action: "rxTransition")
            _tapRecognizerWithAction(about, action: "aboutTransition")
            _tapRecognizerWithAction(completed, action: "completedTransition")
        } else {
            _tapRecognizerWithAction(completed, action: "rxTransition")
        }
        
        let exploreX = explore.centerXAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor, constant: helpMode ? -140 : -111)
        let exploreY = explore.centerYAnchor.constraintEqualToAnchor(_resultTimeline.centerYAnchor)
        contentView.addConstraints([exploreX, exploreY])
        
        if helpMode {
            _configureEventViewAnimations(experiment, page: 0, xOffset: nil)
            _configureEventViewAnimations(share, page: 1, xOffset: nil)
            _configureEventViewAnimations(rx, page: 2, xOffset: nil)
            _configureEventViewAnimations(about, page: 3, xOffset: nil)
            _configureEventViewAnimations(completed, page: 4, xOffset: 135)
        } else {
            _configureEventViewAnimations(experiment, page: 0, xOffset: -37)
            _configureEventViewAnimations(share, page: 1, xOffset: 37)
            _configureEventViewAnimations(completed, page: 2, xOffset: 105)
        }
        
        completed.hidden = true
        let showCompletedAnimation = HideAnimation(view: completed, showAt: helpMode ? 4.1 : 2.1)
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
        let navBar = Image.navBarExperiment.imageView()
        let timeline = Image.timelineExperiment.imageView()
        let editLabel = UILabel()
        let timelineLabel = UILabel()
        let experimentLabel = UILabel()
        let up   = Image.upArrow.imageView()
        let down = Image.downArrow.imageView()
        
        contentView.addSubview(navBar)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let navBarTop = navBar.topAnchor.constraintEqualToAnchor(_logoImageView.bottomAnchor, constant: 30)
        contentView.addConstraint(navBarTop)
        keepView(navBar, onPage: 1)
        
        editLabel.text = "Add new,\nchange colors and values in edit mode"
        editLabel.numberOfLines = 2
        editLabel.font = Font.text(13)
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(editLabel)
        let editLabelTop = editLabel.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor, constant: 40)
        let editLabelCenterX = editLabel.centerXAnchor.constraintEqualToAnchor(navBar.centerXAnchor, constant: -25)
        contentView.addConstraints([editLabelTop, editLabelCenterX])

        timeline.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeline)
        let timelineTop = timeline.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor, constant: 130)
        contentView.addConstraint(timelineTop)
        keepView(timeline, onPage: 1)
        
        up.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(up)
        let upTop = up.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor, constant: 10)
        let upCenterX = up.centerXAnchor.constraintEqualToAnchor(navBar.centerXAnchor, constant: 110)
        contentView.addConstraints([upTop, upCenterX])
        
        let upXAnimation = ConstraintConstantAnimation(superview: contentView, constraint: upCenterX)
        upXAnimation[1] = 110
        upXAnimation[2] = pageWidth + 80
        animator.addAnimation(upXAnimation)
        
        down.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(down)
        let downBottom = down.bottomAnchor.constraintEqualToAnchor(timeline.topAnchor, constant: -10)
        let downCenterX = down.centerXAnchor.constraintEqualToAnchor(navBar.centerXAnchor, constant: 110)
        contentView.addConstraints([downBottom, downCenterX])

        timelineLabel.translatesAutoresizingMaskIntoConstraints = false
        timelineLabel.text = "move events around"
        timelineLabel.font = Font.text(13)
        contentView.addSubview(timelineLabel)
        let timelineLabelTop = timelineLabel.topAnchor.constraintEqualToAnchor(timeline.bottomAnchor, constant: 20)
        contentView.addConstraint(timelineLabelTop)
        keepView(timelineLabel, onPage: 1)

        experimentLabel.translatesAutoresizingMaskIntoConstraints = false
        experimentLabel.text = "Edit. Learn. Experiment."
        experimentLabel.font = Font.text(14)
        contentView.addSubview(experimentLabel)
        let experimentLabelBottom = experimentLabel.bottomAnchor.constraintEqualToAnchor(_resultTimeline.topAnchor, constant: -50)
        contentView.addConstraint(experimentLabelBottom)
        keepView(experimentLabel, onPage: 1)
    }
    
    private func _configureSharePage() {
        let navBar = Image.navBarShare.imageView()
        let shareLabel = UILabel()
        let iconContainer = UIView()
        let spreadTheWordLabel = UILabel()
        
        contentView.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let navBarTop = navBar.topAnchor.constraintEqualToAnchor(_logoImageView.bottomAnchor, constant: 30)
        contentView.addConstraint(navBarTop)
        keepView(navBar, onPage: 2)
        
        shareLabel.text = "Share you diagrams"
        shareLabel.font = Font.text(13)
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shareLabel)
        let shareLabelTop = shareLabel.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor, constant: 55)
        let shareLabelCenterX = shareLabel.centerXAnchor.constraintEqualToAnchor(navBar.centerXAnchor, constant: -10)
        contentView.addConstraints([shareLabelTop, shareLabelCenterX])
        
        spreadTheWordLabel.text = "Spread the word"
        spreadTheWordLabel.font = Font.text(14)
        spreadTheWordLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spreadTheWordLabel)
        let spreadTheWordLabelBottom = spreadTheWordLabel.bottomAnchor.constraintEqualToAnchor(_resultTimeline.topAnchor, constant: -50)
        contentView.addConstraint(spreadTheWordLabelBottom)
        keepView(spreadTheWordLabel, onPage: 2)
        
        contentView.addSubview(iconContainer)
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        let iconContainerTop = iconContainer.topAnchor.constraintEqualToAnchor(shareLabel.bottomAnchor, constant: 20)
        let iconContainerWidth = iconContainer.widthAnchor.constraintEqualToConstant(300)
        let iconContainerHeight = iconContainer.heightAnchor.constraintEqualToConstant(100)
        contentView.addConstraints([iconContainerTop, iconContainerWidth, iconContainerHeight])
        keepView(iconContainer, onPage: 2)
        
        _configureShareIcons(iconContainer)
    }
    
    private func _configureShareIcons(container: UIView) {
        let evernote     = Image.evernote.imageView()
        let facebook     = Image.facebook.imageView()
        let hanghout     = Image.hanghout.imageView()
        let mail         = Image.mail.imageView()
        let messenger    = Image.messenger.imageView()
        let skype        = Image.skype.imageView()
        let slack        = Image.slack.imageView()
        let trello       = Image.trello.imageView()
        let twitter      = Image.twitter.imageView()
        let viber        = Image.viber.imageView()
        
        let shareLogos = [
            facebook,
            twitter,
            trello,
            slack,
            mail,
            messenger,
            viber,
            skype,
            hanghout,
            evernote
        ]
        
        shareLogos.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
            
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
        
        for i in 0..<10 {
            let icon = shareLogos[i]
            let iconTop = icon.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: i < 5 ? 0 : 50)
            let iconLeading = icon.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor, constant: 34 + 50.0 * CGFloat(i < 5 ? i : i - 5))
            container.addConstraints([iconTop, iconLeading])
        }
    }
    
    private func _configureRxPage() {
        let manyLikeLabel = UILabel()
        let erikMeijerTwitter = Image.twitter.imageView()
        let erikMeijerTextView = UITextView()
        let krunoslavZaherTwitter = Image.twitter.imageView()
        let krunoslavZaherTextView = UITextView()
        let rxSwiftLabel = UILabel()
        let githubButton = UIButton(type: .Custom)
        let alasLabel = UILabel()
        
        manyLikeLabel.text = "Many ❤️👍🍻👋 to"
        manyLikeLabel.font = Font.text(18)
        contentView.addSubview(manyLikeLabel)
        let manyLikeLabelTop = manyLikeLabel.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 180)
        contentView.addConstraint(manyLikeLabelTop)
        keepView(manyLikeLabel, onPage: 3)
        
        erikMeijerTwitter.alpha = 0.3
        contentView.addSubview(erikMeijerTwitter)
        let erikMeijerTwitterTop = erikMeijerTwitter.topAnchor.constraintEqualToAnchor(manyLikeLabel.bottomAnchor, constant: 40)
        contentView.addConstraint(erikMeijerTwitterTop)
        keepView(erikMeijerTwitter, onPage: 3)

        erikMeijerTextView.attributedText = _erikMeijerText()
        erikMeijerTextView.delegate = self
        erikMeijerTextView.editable = false
        erikMeijerTextView.scrollEnabled = false
        erikMeijerTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        erikMeijerTextView.textAlignment = .Center
        contentView.addSubview(erikMeijerTextView)
        let erikMeijerTextViewTop = erikMeijerTextView.topAnchor.constraintEqualToAnchor(erikMeijerTwitter.bottomAnchor, constant: 10)
        let erikMeijerTextViewWidht = erikMeijerTextView.widthAnchor.constraintEqualToConstant(250)
        let erikMeijerTextViewHeight = erikMeijerTextView.heightAnchor.constraintEqualToConstant(50)
        contentView.addConstraints([erikMeijerTextViewTop, erikMeijerTextViewWidht, erikMeijerTextViewHeight])
        keepView(erikMeijerTextView, onPage: 3)

        krunoslavZaherTwitter.alpha = 0.3
        contentView.addSubview(krunoslavZaherTwitter)
        let krunoslavZaherTwitterTop = krunoslavZaherTwitter.topAnchor.constraintEqualToAnchor(erikMeijerTextView.bottomAnchor, constant: 35)
        contentView.addConstraint(krunoslavZaherTwitterTop)
        keepView(krunoslavZaherTwitter, onPage: 3)

        krunoslavZaherTextView.attributedText = _krunoslavZaherText()
        krunoslavZaherTextView.delegate = self
        krunoslavZaherTextView.editable = false
        krunoslavZaherTextView.scrollEnabled = false
        krunoslavZaherTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        krunoslavZaherTextView.textAlignment = .Center
        contentView.addSubview(krunoslavZaherTextView)
        let krunoslavZaherTextViewTop = krunoslavZaherTextView.topAnchor.constraintEqualToAnchor(krunoslavZaherTwitter.bottomAnchor, constant: 10)
        let krunoslavZaherTextViewWidht = krunoslavZaherTextView.widthAnchor.constraintEqualToConstant(250)
        let krunoslavZaherTextViewHeight = krunoslavZaherTextView.heightAnchor.constraintEqualToConstant(50)
        contentView.addConstraints([krunoslavZaherTextViewTop, krunoslavZaherTextViewWidht, krunoslavZaherTextViewHeight])
        keepView(krunoslavZaherTextView, onPage: 3)

        rxSwiftLabel.text = "⭐ RxSwift on"
        rxSwiftLabel.font = Font.text(14)
        rxSwiftLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rxSwiftLabel)
        let rxSwiftLabelTop = rxSwiftLabel.topAnchor.constraintEqualToAnchor(krunoslavZaherTextView.bottomAnchor, constant: 40)
        let rxSwiftLabelCenterX = rxSwiftLabel.centerXAnchor.constraintEqualToAnchor(manyLikeLabel.centerXAnchor, constant: -25)
        contentView.addConstraints([rxSwiftLabelTop, rxSwiftLabelCenterX])

        githubButton.setImage(Image.github, forState: .Normal)
        githubButton.addTarget(self, action: "openRxSwiftOnGithub", forControlEvents: .TouchUpInside)
        githubButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(githubButton)
        let githubButtonLeading = githubButton.leadingAnchor.constraintEqualToAnchor(rxSwiftLabel.trailingAnchor, constant: 10)
        let githubButtonCenterY = githubButton.centerYAnchor.constraintEqualToAnchor(rxSwiftLabel.centerYAnchor)
        contentView.addConstraints([githubButtonLeading, githubButtonCenterY])

        alasLabel.text = "¯\\_(ツ)_/¯"
        contentView.addSubview(alasLabel)
        let alasLabelTop = alasLabel.topAnchor.constraintEqualToAnchor(rxSwiftLabel.bottomAnchor, constant: 10)
        contentView.addConstraint(alasLabelTop)
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
    
    private func _configureAboutPage() {
        let anjLabButton       = UIButton(type: .Custom)
        let rxMarblesLabel     = UILabel()
        let versionLabel       = UILabel()
        let developedByLabel   = UILabel()
        
        rxMarblesLabel.text = "RxMarbles"
        rxMarblesLabel.font = Font.text(25)
        rxMarblesLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rxMarblesLabel)
        let rxMarblesLabelTop = rxMarblesLabel.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 248)
        let rxMarblesLabelLeading = rxMarblesLabel.leadingAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor, constant: pageWidth)
        contentView.addConstraints([rxMarblesLabelTop, rxMarblesLabelLeading])
        
        let rxMarblesLabelLeadingAnimation = ConstraintConstantAnimation(superview: contentView, constraint: rxMarblesLabelLeading)
        rxMarblesLabelLeadingAnimation[3.5] = pageWidth
        rxMarblesLabelLeadingAnimation[4]   = -20
        rxMarblesLabelLeadingAnimation[5]   = pageWidth
        animator.addAnimation(rxMarblesLabelLeadingAnimation)
        
        versionLabel.text = "v1.0.0"
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(versionLabel)
        let versionLabelTop = versionLabel.topAnchor.constraintEqualToAnchor(rxMarblesLabel.bottomAnchor)
        let versionLabelLeading = versionLabel.leadingAnchor.constraintEqualToAnchor(rxMarblesLabel.leadingAnchor)
        contentView.addConstraints([versionLabelTop, versionLabelLeading])

        developedByLabel.text = "developed by"
        developedByLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(developedByLabel)
        let developedByLabelTop = developedByLabel.topAnchor.constraintEqualToAnchor(versionLabel.bottomAnchor, constant: 57)
        contentView.addConstraint(developedByLabelTop)
        keepView(developedByLabel, onPage: 4)

        anjLabButton.setImage(Image.anjlab, forState: .Normal)
        anjLabButton.addTarget(self, action: "openAnjLab", forControlEvents: .TouchUpInside)
        anjLabButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(anjLabButton)
        let anjLabButtonTop = anjLabButton.topAnchor.constraintEqualToAnchor(developedByLabel.bottomAnchor, constant: 32)
        contentView.addConstraint(anjLabButtonTop)
        keepView(anjLabButton, onPage: 4)
    }
    
    override func numberOfPages() -> Int {
        if helpMode {
            return 6
        }
        return 4
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
        _openURLinSafariViewController(url!)
    }
    
    func openAnjLab() {
        let url = NSURL(string: Link.anjlab)
        _openURLinSafariViewController(url!)
    }
    
    private func _openURLinSafariViewController(url: NSURL) {
        let safariViewController = SFSafariViewController(URL: url)
        presentViewController(safariViewController, animated: true, completion: nil)
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    MARK: UIScrollViewDelegate methods
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.x == pageWidth * CGFloat(numberOfPages() - 1) {
            if helpMode {
                close()
            } else {
                UIView.animateWithDuration(0.6, animations: { () -> Void in
                    self.view.alpha = 0.0
                    }, completion: { _ in
                        self.close()
                })
            }
        }
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