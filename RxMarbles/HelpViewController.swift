//
//  HelpViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 10.02.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RazzleDazzle
import SafariServices

struct Link {
    static let anjlab = NSURL(string: "http://anjlab.com/en")!
    static let rxSwift = NSURL(string: "https://github.com/ReactiveX/RxSwift")!
    static let erikMeijerTwitter = NSURL(string: "https://twitter.com/headinthebox")!
    static let kZaherTwitter = NSURL(string: "https://twitter.com/KrunoslavZaher")!
    static let reactiveX = NSURL(string: "http://reactivex.io")!
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
    
    let _disposeBag = DisposeBag()
    
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
       
        let centerY = _logoImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: helpMode ? -200 : 0)
        
        let centerX = _logoImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0)
        
        view.addConstraints([centerY, centerX])
        
        let yAnimation = ConstraintConstantAnimation(superview: view, constraint: centerY)
        
        if !helpMode {
            UIView.animateWithDuration(0.3) {
                var center = self._logoImageView.center
                center.y = center.y - 200
                self._logoImageView.center = center
            }
        }
        
        if helpMode {
            yAnimation[3] = -200
            yAnimation[3.2] = -200
            yAnimation[4] = -60
            yAnimation[5] = 0
        } else {
            yAnimation[2.4] = -200
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
        scaleAnimation[3.5] = scale
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
    
    private func _configureResultTimeline() {
        contentView.addSubview(_resultTimeline)
        _resultTimeline.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = _resultTimeline.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -80)
        
        let centerX = _resultTimeline.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0)
        
        let width = _resultTimeline.widthAnchor.constraintEqualToConstant(300)
        
        let height = _resultTimeline.heightAnchor.constraintEqualToConstant(8)
        
        view.addConstraints([centerX, centerY, width, height])
    }
    
    private func _configureButtons() {
        let experimentNextButton   = UIButton(type: .System)
        let shareNextButton  = UIButton(type: .System)
        let rxNextButton  = UIButton(type: .System)
        let aboutNextButton   = UIButton(type: .System)
        let completedButton    = UIButton(type: .System)
        
        shareNextButton.hidden = true
        rxNextButton.hidden = true
        aboutNextButton.hidden = true
        completedButton.hidden = true
        
        _configureButton(experimentNextButton, onPage: 0)
        _configureButton(shareNextButton, onPage: 1)
        if helpMode {
            _configureButton(rxNextButton, onPage: 2)
            _configureButton(aboutNextButton, onPage: 3)
            _configureButton(completedButton, onPage: 4)
        } else {
            _configureButton(completedButton, onPage: 2)
        }
        
        completedButton.setTitle("onCompleted()", forState: .Normal)
    }
    
    private func _configureButton(next: UIButton, onPage page: CGFloat) {
        next.titleLabel?.font = Font.code(.MonoRegular, size: 14)
        next.setTitle("onNext(   )", forState: .Normal)
        next.rx_tap.subscribeNext { [unowned self] _ in
            self._setOffsetAnimated(page + 1)
        }.addDisposableTo(_disposeBag)
        
        next.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(next)
        
        let nextCenterX = next.centerXAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor)
        let nextBottom = next.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -20)
        contentView.addConstraints([nextCenterX, nextBottom])
        
        let nextCenterXAnimation = ConstraintConstantAnimation(superview: contentView, constraint: nextCenterX)
        if page > 0 {
            nextCenterXAnimation[page - 1] = pageWidth
        }
        nextCenterXAnimation[page] = 0
        animator.addAnimation(nextCenterXAnimation)
        
        let nextBottomAnimation = ConstraintConstantAnimation(superview: contentView, constraint: nextBottom)
        nextBottomAnimation[page] = -20
        nextBottomAnimation[page + 1] = 100
        animator.addAnimation(nextBottomAnimation)
        
        let nextShowAnimation = HideAnimation(view: next, showAt: page - 1)
        animator.addAnimation(nextShowAnimation)
    }
    
    private func _configureEventViews() {
        let explore     = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Explore", color: Color.nextGreen, shape: .Circle))))
        let experiment  = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Experiment", color: Color.nextOrange, shape: .Triangle))))
        let share       = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Share", color: Color.nextBlue, shape: .Rect))))
        let rx          = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "Rx", color: Color.nextDarkYellow, shape: .Star))))
        let about       = EventView(recorded: RecordedType(time: 0, event: .Next(ColoredType(value: "About", color: Color.nextLightBlue, shape: .Star))))
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
        
        _tapRecognizerWithAction(explore, page: 0)
        _tapRecognizerWithAction(experiment, page: 1)
        _tapRecognizerWithAction(share, page: 2)
        if helpMode {
            _tapRecognizerWithAction(rx, page: 3)
            _tapRecognizerWithAction(about, page: 4)
            _tapRecognizerWithAction(completed, page: 5)
        } else {
            _tapRecognizerWithAction(completed, page: 3)
        }
        
        let exploreX = explore.centerXAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor, constant: helpMode ? -130 : -111)
        let exploreY = explore.centerYAnchor.constraintEqualToAnchor(_resultTimeline.centerYAnchor)
        contentView.addConstraints([exploreX, exploreY])
        
        if helpMode {
            _configureEventViewAnimations(experiment, page: 0, xOffset: -75)
            _configureEventViewAnimations(share, page: 1, xOffset: -20)
            _configureEventViewAnimations(rx, page: 2, xOffset: 35)
            _configureEventViewAnimations(about, page: 3, xOffset: 85)
            _configureEventViewAnimations(completed, page: 4, xOffset: 125)
        } else {
            _configureEventViewAnimations(experiment, page: 0, xOffset: -37)
            _configureEventViewAnimations(share, page: 1, xOffset: 37)
            _configureEventViewAnimations(completed, page: 2, xOffset: 105)
        }
        
        completed.hidden = true
        let showCompletedAnimation = HideAnimation(view: completed, showAt: helpMode ? 4.05 : 2.05)
        animator.addAnimation(showCompletedAnimation)
    }
    
    private func _configureEventViewAnimations(eventView: EventView, page: CGFloat, xOffset: CGFloat) {
        let x = eventView.centerXAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor, constant: page == 0 ? 25 : pageWidth + 25)
        let y = eventView.centerYAnchor.constraintEqualToAnchor(_resultTimeline.centerYAnchor, constant: 48)
        contentView.addConstraints([x, y])
        let xAnimation = ConstraintConstantAnimation(superview: contentView, constraint: x)
        if page > 0 {
            xAnimation[page - 1] = pageWidth + 25
        }
        xAnimation[page] = eventView.isCompleted ? 42 : 25
        xAnimation[page + 1] = xOffset
        animator.addAnimation(xAnimation)
        let yAnimation = ConstraintConstantAnimation(superview: contentView, constraint: y)
        yAnimation[page] = 48
        yAnimation[page + 1] = 0
        animator.addAnimation(yAnimation)
    }
    
    private func _configureExplorePage() {
        let operatorsCount = Operator.all.count
        
        let operatorsLabelText = NSMutableAttributedString()
        operatorsLabelText.appendAttributedString(
            NSAttributedString(string: "\(operatorsCount)", attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(14)])
        )
        operatorsLabelText.appendAttributedString(
            NSAttributedString(string: " RX operators to ", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14)])
        )
        operatorsLabelText.appendAttributedString(
            NSAttributedString(string: "explore", attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(14)])
        )
        let operatorsLabel = UILabel()
        operatorsLabel.attributedText = operatorsLabelText
        operatorsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(operatorsLabel)
        let labelBottom = operatorsLabel.bottomAnchor.constraintEqualToAnchor(_resultTimeline.topAnchor, constant: -50)
        let labelHeight = operatorsLabel.heightAnchor.constraintEqualToConstant(20)
        contentView.addConstraints([labelBottom, labelHeight])
        keepView(operatorsLabel, onPage: 0)
        
        let cloudView = UIView()
        cloudView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cloudView)
        
        let centerX = cloudView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor)
        let top     = cloudView.topAnchor.constraintEqualToAnchor(contentView.centerYAnchor, constant: -150)
        let bottom  = cloudView.bottomAnchor.constraintEqualToAnchor(operatorsLabel.topAnchor, constant: -20)
        let width   = cloudView.widthAnchor.constraintEqualToConstant(300)
        
        scrollView.addConstraints([centerX, top, bottom, width])
        
        var cloudLabels: [UILabel] = []
        for i in 0..<4 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.clipsToBounds = false
            label.numberOfLines = 0
            
            cloudLabels.append(label)
            cloudView.addSubview(label)
            
            let labelX  = label.centerXAnchor.constraintEqualToAnchor(cloudView.centerXAnchor)
            let labelY  = label.centerYAnchor.constraintEqualToAnchor(cloudView.centerYAnchor)
            let lWidth  = label.widthAnchor.constraintEqualToAnchor(cloudView.widthAnchor)
            let lHeight = label.heightAnchor.constraintEqualToAnchor(cloudView.heightAnchor)
            
            cloudView.addConstraints([labelX, labelY, lWidth, lHeight])
            
            label.center.x = pageWidth * CGFloat(i % 2 > 0 ? -2 : 2)
            UIView.animateWithDuration(0.3, animations: {
                label.center.x = 0
            }, completion: { _ in
                let leftAnimation = ConstraintConstantAnimation(superview: cloudView, constraint: labelX)
                leftAnimation[0] = 0
                leftAnimation[1] = self.pageWidth / 2 * CGFloat(-i)
                self.animator.addAnimation(leftAnimation)
            })
            
            if i == 0 {
                let alphaAnimation = AlphaAnimation(view: label)
                alphaAnimation[0] = 1.0
                alphaAnimation[0.2] = 0.0
                animator.addAnimation(alphaAnimation)
            }
        }
        
        let attributedStrings = _operatorsCloud()
        
        cloudLabels.forEach {
            let index = cloudLabels.indexOf($0)
            $0.attributedText = attributedStrings[index!]
        }
    }
    
    private func _operatorsCloud() -> [NSMutableAttributedString] {
        var strings: [NSMutableAttributedString] = []
        for _ in 0..<4 {
            strings.append(NSMutableAttributedString())
        }
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .ByWordWrapping
        p.lineSpacing = 10
        p.alignment = .Center
        
        let allOperators = Operator.all.shuffle()
        
        var i = 0
        
        for op in allOperators[0...30] {
            let rnd = random() % 4
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
                    $0.appendAttributedString(NSAttributedString(string: "   "))
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
        
        let shadow = NSShadow()
//        shadow.shadowBlurRadius = 1.0
        shadow.shadowColor = UIColor.whiteColor()
//        shadow.shadowOffset = CGSizeMake(2, 2)
        
        switch rnd {
        case 0:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoItalic, size: 12),
                NSParagraphStyleAttributeName: p,
                NSShadowAttributeName : shadow
                ])
        case 1:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoRegular, size: 13),
                NSParagraphStyleAttributeName: p,
                NSShadowAttributeName : shadow
                ])
        case 2:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoBold, size: 13),
                NSParagraphStyleAttributeName: p,
                NSShadowAttributeName : shadow
                ])
        case 3:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoBoldItalic, size: 15),
                NSParagraphStyleAttributeName: p,
                NSShadowAttributeName : shadow
                ])
        default:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoItalic, size: 12),
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
        let navBarTop = navBar.topAnchor.constraintEqualToAnchor(contentView.centerYAnchor, constant: -160)
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
        let navBarTop = navBar.topAnchor.constraintEqualToAnchor(contentView.centerYAnchor, constant: -160)
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
        let iconContainerCenterX = iconContainer.centerXAnchor.constraintEqualToAnchor(_logoImageView.centerXAnchor)

        let iconContainerWidth = iconContainer.widthAnchor.constraintEqualToConstant(300)
        let iconContainerHeight = iconContainer.heightAnchor.constraintEqualToConstant(100)
        contentView.addConstraints([iconContainerTop, iconContainerCenterX, iconContainerWidth, iconContainerHeight])
        
        _configureShareIcons(iconContainer)
        let rotation = RotationAnimation(view: iconContainer)
        rotation[1] = -180
        rotation[2] = 0
        animator.addAnimation(rotation)

        let iconContainerTopAnimation = ConstraintConstantAnimation(superview: contentView, constraint: iconContainerTop)
        iconContainerTopAnimation[1.3] = -210
        iconContainerTopAnimation[2] = 20
        animator.addAnimation(iconContainerTopAnimation)
        
        let iconContainerCenterXAnimation = ConstraintConstantAnimation(superview: contentView, constraint: iconContainerCenterX)
        iconContainerCenterXAnimation[1] = 0
        iconContainerCenterXAnimation[2] = 0
        iconContainerCenterXAnimation[3] = -pageWidth
        animator.addAnimation(iconContainerCenterXAnimation)
    }
    
    private func _configureShareIcons(container: UIView) {
        let shareLogos = [
            Image.facebook,
            Image.twitter,
            Image.trello,
            Image.slack,
            Image.mail,
            Image.messenger,
            Image.viber,
            Image.skype,
            Image.hanghout,
            Image.evernote
        ]
        .map { $0.imageView() }
       
        let step = (2*M_PI) / Double(shareLogos.count);
        var i = 0
        shareLogos.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
           
            $0.transform = CGAffineTransformScale($0.transform, 0, 0)
            let scaleAnimation = ScaleAnimation(view: $0)
            scaleAnimation[1] = 0
            scaleAnimation[2] = 1.0
            scaleAnimation[2.6] = 0.5
            animator.addAnimation(scaleAnimation)
            
            let col = i % 5
            let row = i / 5

            let centerX = $0.centerXAnchor.constraintEqualToAnchor(
                container.centerXAnchor,
                constant: 0
            )

            let centerY = $0.centerYAnchor.constraintEqualToAnchor(
                container.centerYAnchor,
                constant: 0
            )

            container.addConstraints([centerX, centerY])
            let angle = CGFloat(Double(i) * step)
            let r: CGFloat = 210

            let xAnimation = ConstraintConstantAnimation(superview: container, constraint: centerX)
            xAnimation[1] = 0
            xAnimation[1.4] = cos(angle) * r
            xAnimation[2] = CGFloat(col - 2) * 54
            animator.addAnimation(xAnimation)

            let yAnimation = ConstraintConstantAnimation(superview: container, constraint: centerY)

            yAnimation[1] = 0
            yAnimation[1.4] = sin(angle) * r
            yAnimation[2] = row == 0 ? -25 : 25

            animator.addAnimation(yAnimation)

            i += 1
        }
    }
    
    private func _configureRxPage() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        keepView(container, onPage: 3)
        let containerTop = container.topAnchor.constraintEqualToAnchor(contentView.centerYAnchor, constant: -150)
        let containerBottom = container.bottomAnchor.constraintEqualToAnchor(_resultTimeline.topAnchor, constant: -40)
        let containerWidth = container.widthAnchor.constraintEqualToConstant(300)
        contentView.addConstraints([containerTop, containerBottom, containerWidth])
        
        let manyLikeLabel = UILabel()
        
        let erikMeijerTwitter = Image.twitter.imageView()
        let erikMeijerTextView = UITextView()
        
        let krunoslavZaherTwitter = Image.twitter.imageView()
        let krunoslavZaherTextView = UITextView()
        
        let rxSwiftLabel = UILabel()
        let githubButton = UIButton(type: .Custom)
        let alasLabel = UILabel()
        
        manyLikeLabel.text = "Many ❤️👍🍻👋 to"
        manyLikeLabel.font = Font.code(.MalayalamSangamMN, size: 18)
        manyLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(manyLikeLabel)
        let manyLikeLabelTop = manyLikeLabel.topAnchor.constraintEqualToAnchor(container.topAnchor)
        let manyLikeLabelCenterX = manyLikeLabel.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor)
        container.addConstraints([manyLikeLabelTop, manyLikeLabelCenterX])
        
        erikMeijerTwitter.alpha = 0.3
        erikMeijerTwitter.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(erikMeijerTwitter)
        let erikMeijerTwitterTop = erikMeijerTwitter.topAnchor.constraintLessThanOrEqualToAnchor(manyLikeLabel.bottomAnchor, constant: 40)
        let erikMeijerTwitterGreaterTop = erikMeijerTwitter.topAnchor.constraintGreaterThanOrEqualToAnchor(manyLikeLabel.bottomAnchor, constant: 10)
        let erikMeijerTwitterHeight = erikMeijerTwitter.heightAnchor.constraintEqualToConstant(Image.twitter.size.height)
        let erikMeijerTwitterCenterX = erikMeijerTwitter.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor, constant: -10)
        container.addConstraints([erikMeijerTwitterTop, erikMeijerTwitterGreaterTop, erikMeijerTwitterHeight, erikMeijerTwitterCenterX])
        
        erikMeijerTextView.attributedText = _erikMeijerText()
        erikMeijerTextView.delegate = self
        erikMeijerTextView.editable = false
        erikMeijerTextView.scrollEnabled = false
        erikMeijerTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        erikMeijerTextView.textAlignment = .Center
        erikMeijerTextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(erikMeijerTextView)
        let erikMeijerTextViewTop = erikMeijerTextView.topAnchor.constraintEqualToAnchor(erikMeijerTwitter.bottomAnchor)
        let erikMeijerTextViewGreaterTop = erikMeijerTextView.topAnchor.constraintGreaterThanOrEqualToAnchor(erikMeijerTwitter.bottomAnchor)
        let erikMeijerTextViewCenterX = erikMeijerTextView.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor)
        container.addConstraints([erikMeijerTextViewTop, erikMeijerTextViewGreaterTop, erikMeijerTextViewCenterX])
        
        krunoslavZaherTwitter.alpha = 0.3
        krunoslavZaherTwitter.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(krunoslavZaherTwitter)
        let krunoslavZaherTwitterTop = krunoslavZaherTwitter.topAnchor.constraintLessThanOrEqualToAnchor(erikMeijerTextView.bottomAnchor, constant: 35)
        let krunoslavZaherTwitterGreaterTop = krunoslavZaherTwitter.topAnchor.constraintGreaterThanOrEqualToAnchor(erikMeijerTextView.bottomAnchor)
        let krunoslavZaherTwitterHeight = krunoslavZaherTwitter.heightAnchor.constraintEqualToConstant(Image.twitter.size.height)
        let krunoslavZaherTwitterCenterX = krunoslavZaherTwitter.centerXAnchor.constraintLessThanOrEqualToAnchor(container.centerXAnchor, constant: 15)
        container.addConstraints([krunoslavZaherTwitterTop, krunoslavZaherTwitterGreaterTop, krunoslavZaherTwitterHeight, krunoslavZaherTwitterCenterX])
        
        krunoslavZaherTextView.attributedText = _krunoslavZaherText()
        krunoslavZaherTextView.delegate = self
        krunoslavZaherTextView.editable = false
        krunoslavZaherTextView.scrollEnabled = false
        krunoslavZaherTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        krunoslavZaherTextView.textAlignment = .Center
        krunoslavZaherTextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(krunoslavZaherTextView)
        let krunoslavZaherTextViewTop = krunoslavZaherTextView.topAnchor.constraintEqualToAnchor(krunoslavZaherTwitter.bottomAnchor)
        let krunoslavZaherTextViewCenterX = krunoslavZaherTextView.centerXAnchor.constraintLessThanOrEqualToAnchor(container.centerXAnchor)
        container.addConstraints([krunoslavZaherTextViewTop, krunoslavZaherTextViewCenterX])
        
        alasLabel.text = "¯\\_(ツ)_/¯"
        alasLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(alasLabel)
        let alasLabelBottom = alasLabel.bottomAnchor.constraintLessThanOrEqualToAnchor(container.bottomAnchor)
        let alasLabelCenterX = alasLabel.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor)
        container.addConstraints([alasLabelBottom, alasLabelCenterX])
        
        let rxSwiftLabelText = NSMutableAttributedString(attributedString:
            NSAttributedString(string: "⭐ ", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14)])
        )
        rxSwiftLabelText.appendAttributedString(
            NSAttributedString(
                string: "RxSwift",
                attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(14)]
            )
        )
        rxSwiftLabelText.appendAttributedString(
            NSAttributedString(string: " on", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14)])
        )
        rxSwiftLabel.attributedText = rxSwiftLabelText
        rxSwiftLabel.translatesAutoresizingMaskIntoConstraints = false
        rxSwiftLabel.userInteractionEnabled = true
        container.addSubview(rxSwiftLabel)
        let rxSwiftLabelTop = rxSwiftLabel.topAnchor.constraintLessThanOrEqualToAnchor(krunoslavZaherTextView.bottomAnchor, constant: 40)
        let rxSwiftLabelBottom = rxSwiftLabel.bottomAnchor.constraintEqualToAnchor(alasLabel.topAnchor, constant: -10)
        let rxSwiftLabelCenterX = rxSwiftLabel.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor, constant: -25)
        container.addConstraints([rxSwiftLabelTop, rxSwiftLabelCenterX, rxSwiftLabelBottom])
        
        let tap = UITapGestureRecognizer()
        rxSwiftLabel.addGestureRecognizer(tap)
        tap.rx_event
            .subscribeNext { [unowned self] _ in self.openURLinSafariViewController(Link.rxSwift) }
            .addDisposableTo(_disposeBag)
        
        githubButton.setImage(Image.github, forState: .Normal)
        githubButton.rx_tap.subscribeNext { [unowned self] _ in self.openURLinSafariViewController(Link.rxSwift) }
            .addDisposableTo(_disposeBag)
        githubButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(githubButton)
        let githubButtonLeading = githubButton.leadingAnchor.constraintEqualToAnchor(rxSwiftLabel.trailingAnchor, constant: 10)
        let githubButtonCenterY = githubButton.centerYAnchor.constraintEqualToAnchor(rxSwiftLabel.centerYAnchor)
        container.addConstraints([githubButtonLeading, githubButtonCenterY])
    }
    
    private func _erikMeijerText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "Erik ", attributes: [NSFontAttributeName : Font.text(14)])
        let twitter = NSMutableAttributedString(string: "@headinthebox", attributes:
            [
                NSLinkAttributeName             : Link.erikMeijerTwitter,
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(twitter)
        text.appendAttributedString(NSAttributedString(string: " Meijer\nfor his work on ", attributes: [NSFontAttributeName : Font.text(14)]))
        let reactivex = NSMutableAttributedString(string: "Reactive Extensions", attributes:
            [
                NSLinkAttributeName             : Link.reactiveX,
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(reactivex)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        text.addAttributes([NSParagraphStyleAttributeName : paragraph], range: NSMakeRange(0, text.length))
        return text
    }
    
    private func _krunoslavZaherText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "Krunoslav ", attributes: [NSFontAttributeName : Font.text(14)])
        let twitter = NSMutableAttributedString(string: "@KrunoslavZaher", attributes:
            [
                NSLinkAttributeName             : Link.kZaherTwitter,
                NSForegroundColorAttributeName  : UIColor.blackColor(),
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(twitter)
        text.appendAttributedString(NSAttributedString(string: " Zaher\nfor ", attributes: [NSFontAttributeName : Font.text(14)]))
        let reactivex = NSMutableAttributedString(string: "RxSwift", attributes:
            [
                NSLinkAttributeName             : Link.rxSwift,
                NSForegroundColorAttributeName  : UIColor.blackColor(),
                NSFontAttributeName             : UIFont.boldSystemFontOfSize(14)
            ]
        )
        text.appendAttributedString(reactivex)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        text.addAttributes([NSParagraphStyleAttributeName : paragraph], range: NSMakeRange(0, text.length))
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
        let rxMarblesLabelCenterY = rxMarblesLabel.centerYAnchor.constraintEqualToAnchor(_logoImageView.centerYAnchor, constant: -12)
        let rxMarblesLabelLeading = rxMarblesLabel.leadingAnchor.constraintEqualToAnchor(_resultTimeline.centerXAnchor, constant: pageWidth)
        contentView.addConstraints([rxMarblesLabelCenterY, rxMarblesLabelLeading])
        
        let rxMarblesLabelLeadingAnimation = ConstraintConstantAnimation(superview: contentView, constraint: rxMarblesLabelLeading)
        rxMarblesLabelLeadingAnimation[3.5] = pageWidth
        rxMarblesLabelLeadingAnimation[4]   = -20
        rxMarblesLabelLeadingAnimation[5]   = pageWidth
        animator.addAnimation(rxMarblesLabelLeadingAnimation)
        
        versionLabel.text = _version()
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(versionLabel)
        let versionLabelTop = versionLabel.topAnchor.constraintEqualToAnchor(rxMarblesLabel.bottomAnchor)
        let versionLabelLeading = versionLabel.leadingAnchor.constraintEqualToAnchor(rxMarblesLabel.leadingAnchor)
        contentView.addConstraints([versionLabelTop, versionLabelLeading])

        developedByLabel.text = "developed by"
        developedByLabel.font = Font.text(12)
        developedByLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(developedByLabel)
        let developedByLabelTop = developedByLabel.topAnchor.constraintLessThanOrEqualToAnchor(versionLabel.bottomAnchor, constant: 68)
        contentView.addConstraint(developedByLabelTop)
        keepView(developedByLabel, onPage: 4)

        anjLabButton.setImage(Image.anjlab, forState: .Normal)
        
        anjLabButton.rx_tap.subscribeNext { [unowned self] _ in self.openURLinSafariViewController(Link.anjlab) }
        .addDisposableTo(_disposeBag)
        
        anjLabButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(anjLabButton)
        let anjLabButtonTop = anjLabButton.topAnchor.constraintLessThanOrEqualToAnchor(developedByLabel.bottomAnchor, constant: 0)
        let anjLabButtonBottom = anjLabButton.bottomAnchor.constraintLessThanOrEqualToAnchor(_resultTimeline.topAnchor, constant: -30)
        contentView.addConstraints([anjLabButtonTop, anjLabButtonBottom])
        keepView(anjLabButton, onPage: 4)
        
        let ellipse1 = Image.ellipse1.imageView()
        ellipse1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ellipse1)
        let ellipse1CenterX = ellipse1.centerXAnchor.constraintEqualToAnchor(anjLabButton.centerXAnchor)
        let ellipse1CenterY = ellipse1.centerYAnchor.constraintEqualToAnchor(anjLabButton.centerYAnchor)
        contentView.addConstraints([ellipse1CenterX, ellipse1CenterY])
        _addMotionEffectToView(ellipse1, relativity: (vertical: (min: -5, max: 5), horizontal: (min: -5, max: 5)))
        
        let ellipse2 = Image.ellipse2.imageView()
        ellipse2.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ellipse2)
        let ellipse2CenterX = ellipse2.centerXAnchor.constraintEqualToAnchor(anjLabButton.centerXAnchor)
        let ellipse2CenterY = ellipse2.centerYAnchor.constraintEqualToAnchor(anjLabButton.centerYAnchor)
        contentView.addConstraints([ellipse2CenterX, ellipse2CenterY])
        _addMotionEffectToView(ellipse2, relativity: (vertical: (min: -5, max: 5), horizontal: (min: -5, max: 5)))
    }
    
    override func numberOfPages() -> Int {
        if helpMode {
            return 6
        }
        return 4
    }
    
//    MARK: Navigation
    
    func _setOffsetAnimated(offset: CGFloat) {
        scrollView.setContentOffset(CGPointMake(self.pageWidth * offset, 0), animated: true)
    }
    
    func openURLinSafariViewController(url: NSURL) {
        let safariViewController = SFSafariViewController(URL: url)
        presentViewController(safariViewController, animated: true, completion: nil)
    }
    
//    MARK: UIScrollViewDelegate methods
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.x == pageWidth * CGFloat(numberOfPages() - 1) {
            view.userInteractionEnabled = false
            if helpMode {
//                MARK: Delay before dismiss
                let sec = 0.3
                let delay = sec * Double(NSEC_PER_SEC)
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(Names.hideHelpWindow, object: nil)
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
    
//    MARK: Helpers
    
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
    
    private func _tapRecognizerWithAction(eventView: UIView, page: CGFloat) {
        let tap = UITapGestureRecognizer()
        eventView.addGestureRecognizer(tap)
        tap.rx_event.subscribeNext { [unowned self] _ in
            self._setOffsetAnimated(page)
        }.addDisposableTo(_disposeBag)
    }
    
    private func _version() -> String {
        guard let info = NSBundle.mainBundle().infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String,
            let build = info["CFBundleVersion"] as? String
        else { return "Unknwon" }
        
        return "v\(version) build \(build)"
    }
}