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
import Device

struct Link {
    static let anjlab            = NSURL(string: "http://anjlab.com/en")!
    static let rxSwift           = NSURL(string: "https://github.com/ReactiveX/RxSwift")!
    static let rxSwiftTwitter    = NSURL(string: "https://twitter.com/rxswiftlang")!
    static let erikMeijerTwitter = NSURL(string: "https://twitter.com/headinthebox")!
    static let kZaherTwitter     = NSURL(string: "https://twitter.com/KrunoslavZaher")!
    static let reactiveX         = NSURL(string: "http://reactivex.io")!
}

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        let count = Int(self.count)
        
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<Int(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            self.swapAt(i, j)
        }
    }
}

class HelpViewController: AnimatedPagingScrollViewController {
    
    var helpMode: Bool = true
    
    private let _disposeBag = DisposeBag()
    
    private let _logoImageView  = RxMarbles.Image.helpLogo.imageView()
    private let _reactiveXLogo  = RxMarbles.Image.rxLogo.imageView()
    private let _resultTimeline = RxMarbles.Image.timeLine.imageView()
    
    private let _closeButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.bgPrimary
        _configurePages()
    }
    
    private func _configurePages() {
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
        
        _logoImageView.transform = _logoImageView.transform.scaledBy(x: scale, y: scale)
        
        let centerY = _logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: helpMode ? -200 : 0)
        
        let centerX = _logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        
        view.addConstraints([centerY, centerX])
        
        let yAnimation = ConstraintConstantAnimation(superview: view, constraint: centerY)
        
        if !helpMode {
            UIView.animate(withDuration: 0.3) {
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
        
        let centerX = _reactiveXLogo.centerXAnchor.constraint(equalTo: _logoImageView.centerXAnchor)
        
        let centerY = _reactiveXLogo.centerYAnchor.constraint(equalTo: _logoImageView.centerYAnchor)
        
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
        _closeButton.setImage(RxMarbles.Image.cross, for: .normal)
        _closeButton.contentMode = .center
        
        _ = _closeButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        })
        
        view.addSubview(_closeButton)
        _closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        var top: NSLayoutConstraint
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            top = _closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0)
        } else {
           top = _closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        }
        
        let right = _closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        
        let width = _closeButton.widthAnchor.constraint(equalToConstant: 40)
        let height = _closeButton.heightAnchor.constraint(equalToConstant: 40)
        
        view.addConstraints([top, right, width, height])
    }
    
    private func _configureResultTimeline() {
        contentView.addSubview(_resultTimeline)
        _resultTimeline.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = _resultTimeline.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        
        let centerX = _resultTimeline.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        
        let width = _resultTimeline.widthAnchor.constraint(equalToConstant: 300)
        
        let height = _resultTimeline.heightAnchor.constraint(equalToConstant: 8)
        
        view.addConstraints([centerX, centerY, width, height])
    }
    
    private func _configureButtons() {
        let experimentNextButton = UIButton(type: .system)
        let shareNextButton      = UIButton(type: .system)
        let rxNextButton         = UIButton(type: .system)
        let aboutNextButton      = UIButton(type: .system)
        let completedButton      = UIButton(type: .system)
        
        shareNextButton.isHidden = true
        rxNextButton.isHidden = true
        aboutNextButton.isHidden = true
        completedButton.isHidden = true
        
        _configureButton(next: experimentNextButton, onPage: 0)
        _configureButton(next: shareNextButton, onPage: 1)
        if helpMode {
            _configureButton(next: rxNextButton, onPage: 2)
            _configureButton(next: aboutNextButton, onPage: 3)
            _configureButton(next: completedButton, onPage: 4)
        } else {
            _configureButton(next: completedButton, onPage: 2)
        }
        
        completedButton.setTitle("onCompleted()", for: .normal)
    }
    
    private func _configureButton(next: UIButton, onPage page: CGFloat) {
        next.titleLabel?.font = Font.code(.monoRegular, size: 14)
        next.setTitle("onNext(   )", for: .normal)
        next.rx.tap.subscribe { [unowned self] _ in
            self._setOffsetAnimated(page + 1)
            }
            .disposed(by: _disposeBag)
        
        next.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(next)
        
        let nextCenterX = next.centerXAnchor.constraint(equalTo: _resultTimeline.centerXAnchor)
        let nextBottom = next.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
        let explore     = EventView(recorded: RecordedType(time: 0, value: Event.next(ColoredType(value: "Explore", color: Color.nextGreen, shape: .circle))))
        let experiment  = EventView(recorded: RecordedType(time: 0, value: Event.next(ColoredType(value: "Experiment", color: Color.nextOrange, shape: .triangle))))
        let share       = EventView(recorded: RecordedType(time: 0, value: Event.next(ColoredType(value: "Share", color: Color.nextBlue, shape: .rect))))
        let rx          = EventView(recorded: RecordedType(time: 0, value: Event.next(ColoredType(value: "Rx", color: Color.nextDarkYellow, shape: .star))))
        let about       = EventView(recorded: RecordedType(time: 0, value: Event.next(ColoredType(value: "About", color: Color.nextLightBlue, shape: .star))))
        let completed   = EventView(recorded: RecordedType(time: 0, value: .completed))
        
        let helpEvents = [ explore, experiment, share, rx, about, completed ]
        let introEvents = [ explore, experiment, share, completed ]
        let events = helpMode ? helpEvents : introEvents
        
        events.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            let width   = $0.widthAnchor.constraint(equalToConstant: 20)
            let height  = $0.heightAnchor.constraint(equalToConstant: 50)
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
        
        let exploreX = explore.centerXAnchor.constraint(equalTo: _resultTimeline.centerXAnchor, constant: helpMode ? -130 : -111)
        let exploreY = explore.centerYAnchor.constraint(equalTo: _resultTimeline.centerYAnchor)
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
        
        completed.isHidden = true
        let showCompletedAnimation = HideAnimation(view: completed, showAt: helpMode ? 4.05 : 2.05)
        animator.addAnimation(showCompletedAnimation)
    }
    
    private func _configureEventViewAnimations(_ eventView: EventView, page: CGFloat, xOffset: CGFloat) {
        let x = eventView.centerXAnchor.constraint(equalTo: _resultTimeline.centerXAnchor, constant: page == 0 ? 25 : pageWidth + 25)
        let y = eventView.centerYAnchor.constraint(equalTo: _resultTimeline.centerYAnchor, constant: 48)
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

        let operatorsLabel: UILabel = {
            let label = UILabel()
            let attributedText = NSMutableAttributedString()
            attributedText.append(NSAttributedString(string: "\(operatorsCount)", attributes: [.font : Font.boldText(14)]))
            attributedText.append(NSAttributedString(string: NSLocalizedString("operators_to", comment: ""), attributes: [.font : Font.text(14)]))
            attributedText.append(NSAttributedString(string: NSLocalizedString("explore", comment: ""), attributes: [.font : Font.boldText(14)]))
            label.attributedText = attributedText
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        contentView.addSubview(operatorsLabel)
        let labelBottom = operatorsLabel.bottomAnchor.constraint(equalTo: _resultTimeline.topAnchor, constant: -50)
        let labelHeight = operatorsLabel.heightAnchor.constraint(equalToConstant: 20)
        contentView.addConstraints([labelBottom, labelHeight])
        keepView(operatorsLabel, onPage: 0)
        
        let cloudView = UIView()
        cloudView.clipsToBounds = false
        cloudView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cloudView)
        
        let centerX = cloudView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        let top     = cloudView.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -150)
        let bottom  = cloudView.bottomAnchor.constraint(equalTo: operatorsLabel.topAnchor, constant: -20)
        let width   = cloudView.widthAnchor.constraint(equalToConstant: 300)
        
        scrollView.addConstraints([centerX, top, bottom, width])
        
        var cloudLabels: [UILabel] = []
        for i in 0..<4 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.clipsToBounds = false
            label.numberOfLines = 0
            
            cloudLabels.append(label)
            cloudView.addSubview(label)
            
            let labelX  = label.centerXAnchor.constraint(equalTo: cloudView.centerXAnchor)
            let labelY  = label.centerYAnchor.constraint(equalTo: cloudView.centerYAnchor)
            let lWidth  = label.widthAnchor.constraint(equalTo: cloudView.widthAnchor)
            let lHeight = label.heightAnchor.constraint(equalTo: cloudView.heightAnchor)
            
            cloudView.addConstraints([labelX, labelY, lWidth, lHeight])
            
            if scrollView.contentOffset.x == 0 {
                label.center.x = pageWidth * CGFloat(i % 2 > 0 ? -2 : 2)
                UIView.animate(withDuration: 0.3, animations: {
                    label.center.x = 0
                }, completion: { _ in
                    let leftAnimation = ConstraintConstantAnimation(superview: cloudView, constraint: labelX)
                    leftAnimation[0] = 0
                    leftAnimation[1] = self.pageWidth / 2 * CGFloat(-i)
                    self.animator.addAnimation(leftAnimation)
                })
            }
            
            if i == 0 {
                let alphaAnimation = AlphaAnimation(view: label)
                alphaAnimation[0] = 1.0
                alphaAnimation[0.2] = 0.0
                animator.addAnimation(alphaAnimation)
            }
        }
        
        let attributedStrings = _operatorsCloud()
        
        cloudLabels.forEach {
            let index = cloudLabels.firstIndex(of: $0)
            $0.attributedText = attributedStrings[index!]
        }
    }
    
    private func _operatorsCloud() -> [NSMutableAttributedString] {
        var strings: [NSMutableAttributedString] = []
        for _ in 0..<4 {
            strings.append(NSMutableAttributedString())
        }
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .byWordWrapping
        p.lineSpacing = 8
        p.alignment = .center
        
        let allOperators = Operator.all.shuffle()
        
        var i = 0
        
        for op in allOperators[0...20] {
            let rnd = arc4random() % 4
            let operatorString = _attributedOperatorString(op: op, p: p, rnd: Int(rnd))
            let alphaString = NSMutableAttributedString(attributedString: operatorString)
            alphaString.addAttributes([.foregroundColor : UIColor.clear], range: NSMakeRange(0, operatorString.length))
            switch rnd {
            case 0:
                strings.forEach { $0.append(strings.firstIndex(of: $0) == 0 ? operatorString : alphaString) }
            case 1:
                strings.forEach { $0.append(strings.firstIndex(of: $0) == 1 ? operatorString : alphaString) }
            case 2:
                strings.forEach { $0.append(strings.firstIndex(of: $0) == 2 ? operatorString : alphaString) }
            case 3:
                strings.forEach { $0.append(strings.firstIndex(of: $0) == 3 ? operatorString : alphaString) }
            default:
                break
            }
            
            if i == 0 {
                strings.forEach { $0.append(NSAttributedString(string: "\n")) }
            } else {
                strings.forEach { $0.append(NSAttributedString(string: "   ")) }
            }
            
            i += 1
            
            if i == 20 {
                strings.forEach { $0.append(NSAttributedString(string: "\n")) }
            }
        }
        
        return strings
    }
    
    private func _attributedOperatorString(op: Operator, p: NSMutableParagraphStyle, rnd: Int) -> NSMutableAttributedString {
        let shadow = NSShadow()
        shadow.shadowColor = Color.white
        switch rnd {
        case 0: return NSMutableAttributedString(string: op.rawValue, attributes: [.font: Font.code(.monoItalic, size: 12), .paragraphStyle: p, .shadow: shadow])
        case 1: return NSMutableAttributedString(string: op.rawValue, attributes: [.font: Font.code(.monoRegular, size: 13), .paragraphStyle: p, .shadow: shadow])
        case 2: return NSMutableAttributedString(string: op.rawValue, attributes: [.font: Font.code(.monoBold, size: 13), .paragraphStyle: p, .shadow: shadow])
        case 3: return NSMutableAttributedString(string: op.rawValue, attributes: [.font: Font.code(.monoBoldItalic, size: 15), .paragraphStyle: p, .shadow: shadow])
        default: return NSMutableAttributedString(string: op.rawValue, attributes: [.font: Font.code(.monoItalic, size: 12), .paragraphStyle: p])
        }
    }
    
    private func _configureExperimentPage() {
        let navBar = RxMarbles.Image.navBarExperiment.imageView()

        let timeline = RxMarbles.Image.timelineExperiment.imageView()

        let editLabel: UILabel = {
            let label = UILabel()
            let attributedString = NSMutableAttributedString(
                string: NSLocalizedString("add_new_change_colors_and_values_in", comment: ""),
                attributes: [.font : Font.text(13)]
            )
            attributedString.append(NSAttributedString(string: "edit", attributes: [.font: Font.boldText(13)]))
            attributedString.append(NSAttributedString(string: " mode", attributes: [.font: Font.text(13)]))
            label.attributedText = attributedString
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let timelineLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = NSLocalizedString("move_events_around", comment: "")
            label.font = Font.text(13)
            return label
        }()

        let experimentLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = NSLocalizedString("edit_learn_experiment", comment: "")
            label.font = Font.text(14)
            return label
        }()

        let up   = RxMarbles.Image.upArrow.imageView()
        let down = RxMarbles.Image.downArrow.imageView()
        
        contentView.addSubview(navBar)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let navBarTop = navBar.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -160)
        contentView.addConstraint(navBarTop)
        keepView(navBar, onPage: 1)

        contentView.addSubview(editLabel)
        let editLabelTop = editLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 40)
        let editLabelCenterX = editLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor, constant: -25)
        contentView.addConstraints([editLabelTop, editLabelCenterX])
        
        timeline.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeline)
        let timelineTop = timeline.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 130)
        contentView.addConstraint(timelineTop)
        keepView(timeline, onPage: 1)
        
        up.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(up)
        let upTop = up.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10)
        let upCenterX = up.centerXAnchor.constraint(equalTo: navBar.centerXAnchor, constant: 110)
        contentView.addConstraints([upTop, upCenterX])
        
        let upCenterXPosition = Device.type() == .iPad ? pageWidth + 80 : ( scrollView.bounds.height > scrollView.bounds.width ? scrollView.bounds.width : scrollView.bounds.height ) + 80
        
        let upXAnimation = ConstraintConstantAnimation(superview: contentView, constraint: upCenterX)
        upXAnimation[1] = 110
        upXAnimation[2] = upCenterXPosition
        animator.addAnimation(upXAnimation)
        
        down.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(down)
        let downBottom = down.bottomAnchor.constraint(equalTo: timeline.topAnchor, constant: -10)
        let downCenterX = down.centerXAnchor.constraint(equalTo: navBar.centerXAnchor, constant: 110)
        contentView.addConstraints([downBottom, downCenterX])

        contentView.addSubview(timelineLabel)
        let timelineLabelTop = timelineLabel.topAnchor.constraint(equalTo: timeline.bottomAnchor, constant: 20)
        contentView.addConstraint(timelineLabelTop)
        keepView(timelineLabel, onPage: 1)

        contentView.addSubview(experimentLabel)
        let experimentLabelBottom = experimentLabel.bottomAnchor.constraint(equalTo: _resultTimeline.topAnchor, constant: -50)
        contentView.addConstraint(experimentLabelBottom)
        keepView(experimentLabel, onPage: 1)
    }
    
    private func _configureSharePage() {
        var navBar = RxMarbles.Image.navBarShare.imageView()
        

        let shareLabel: UILabel = {
            let label = UILabel()
            label.text = NSLocalizedString("share_your_diagrams", comment: "")
            label.font = Font.text(13)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let spreadTheWordLabel: UILabel = {
            let label = UILabel()
            label.text = NSLocalizedString("spread_the_world", comment: "")
            label.font = Font.text(14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        contentView.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let navBarTop = navBar.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -160)
        contentView.addConstraint(navBarTop)
        keepView(navBar, onPage: 2)
        
        contentView.addSubview(shareLabel)
        let shareLabelTop = shareLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 55)
        let shareLabelCenterX = shareLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor, constant: -10)
        contentView.addConstraints([shareLabelTop, shareLabelCenterX])
        
        
        contentView.addSubview(spreadTheWordLabel)
        let spreadTheWordLabelBottom = spreadTheWordLabel.bottomAnchor.constraint(equalTo: _resultTimeline.topAnchor, constant: -50)
        contentView.addConstraint(spreadTheWordLabelBottom)
        keepView(spreadTheWordLabel, onPage: 2)

        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconContainer)

        let iconContainerTop = iconContainer.topAnchor.constraint(equalTo: shareLabel.bottomAnchor, constant: 20)
        let iconContainerCenterX = iconContainer.centerXAnchor.constraint(equalTo: _logoImageView.centerXAnchor)
        
        let iconContainerWidth = iconContainer.widthAnchor.constraint(equalToConstant: 300)
        let iconContainerHeight = iconContainer.heightAnchor.constraint(equalToConstant: 100)
        contentView.addConstraints([iconContainerTop, iconContainerCenterX, iconContainerWidth, iconContainerHeight])
        
        _configureShareIcons(container: iconContainer)
        
        let alpha = AlphaAnimation(view: iconContainer)
        alpha[1] = 0.0
        alpha[1.05] = 0.0
        alpha[1.2] = 1.0
        alpha[2] = 1.0
        animator.addAnimation(alpha)
        
        let rotation = RotationAnimation(view: iconContainer)
        rotation[1] = -90
        rotation[2] = 0
        animator.addAnimation(rotation)
        
        let iconContainerTopAnimation = ConstraintConstantAnimation(superview: contentView, constraint: iconContainerTop)
        iconContainerTopAnimation[1.4] = -210
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
            RxMarbles.Image.facebook,
            RxMarbles.Image.twitter,
            RxMarbles.Image.trello,
            RxMarbles.Image.slack,
            RxMarbles.Image.mail,
            RxMarbles.Image.messenger,
            RxMarbles.Image.viber,
            RxMarbles.Image.skype,
            RxMarbles.Image.hanghout,
            RxMarbles.Image.evernote
            ]
            .map { $0.imageView() }
        
        let step = (2 * .pi) / Double(shareLogos.count);
        var i = 0
        shareLogos.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
            
            $0.transform = $0.transform.scaledBy(x: 0, y: 0)
            let scaleAnimation = ScaleAnimation(view: $0)
            scaleAnimation[1] = 0
            scaleAnimation[1.1] = 0.3
            scaleAnimation[1.5] = 1.3
            scaleAnimation[2] = 1.0
            scaleAnimation[2.6] = 0.5
            animator.addAnimation(scaleAnimation)
            
            let col = i % 5
            let row = i / 5
            
            let centerX = $0.centerXAnchor.constraint(
                equalTo: container.centerXAnchor,
                constant: 0
            )
            
            let centerY = $0.centerYAnchor.constraint(
                equalTo: container.centerYAnchor,
                constant: 0
            )
            
            container.addConstraints([centerX, centerY])
            let angle = CGFloat(Double(i + 5) * step)
            let r: CGFloat = 210
            
            let xAnimation = ConstraintConstantAnimation(superview: container, constraint: centerX)
            xAnimation[1] = 0
            xAnimation[1.6] = cos(angle) * r
            xAnimation[2] = (CGFloat(col - 2) * 54) * (row == 0 ? 1 : -1)
            animator.addAnimation(xAnimation)
            
            let yAnimation = ConstraintConstantAnimation(superview: container, constraint: centerY)
            
            yAnimation[1] = 0
            yAnimation[1.6] = sin(angle) * r
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
        let containerTop = container.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -140)
        let containerBottom = container.bottomAnchor.constraint(equalTo: _resultTimeline.topAnchor, constant: -50)
        let containerWidth = container.widthAnchor.constraint(equalToConstant: 300)
        contentView.addConstraints([containerTop, containerBottom, containerWidth])
        
		let manyLikeLabel: UILabel = {
			let label = UILabel()
			label.text = "Many ❤️👍🍻👋 to"
			label.font = Font.code(.malayalamSangamMN, size: 18)
			label.translatesAutoresizingMaskIntoConstraints = false
			return label
		}()

		let erikMeijerTwitter: UIImageView = {
			let imageView = RxMarbles.Image.twitter.imageView()
			imageView.alpha = 0.3
			imageView.translatesAutoresizingMaskIntoConstraints = false
			_scaleView(view: imageView)
			return imageView
		}()

		let erikMeijerTextView: UITextView = {
			let textView = UITextView()
			textView.attributedText = _erikMeijerText()
			textView.delegate = self
			textView.isEditable = false
			textView.isScrollEnabled = false
			textView.dataDetectorTypes = UIDataDetectorTypes.link
			textView.textAlignment = .center
            textView.backgroundColor = Color.bgPrimary
			textView.translatesAutoresizingMaskIntoConstraints = false
			return textView
		}()

		let krunoslavZaherTwitter: UIImageView = {
			let imageView = RxMarbles.Image.twitter.imageView()
			imageView.alpha = 0.3
			imageView.translatesAutoresizingMaskIntoConstraints = false
			_scaleView(view: imageView)
			return imageView
		}()

		let krunoslavZaherTextView: UITextView = {
			let textView = UITextView()
			textView.attributedText = _krunoslavZaherText()
			textView.delegate = self
			textView.isEditable = false
			textView.isScrollEnabled = false
			textView.dataDetectorTypes = UIDataDetectorTypes.link
			textView.textAlignment = .center
            textView.backgroundColor = Color.bgPrimary
			textView.translatesAutoresizingMaskIntoConstraints = false
			return textView
		}()

		let rxSwiftLabel: UILabel = {
			let label = UILabel()
			label.attributedText = {
				let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "⭐ ", attributes: [.font: Font.text(14)]))
				attributedString.append(NSAttributedString(string: "RxSwift", attributes: [.font: Font.boldText(14)]))
				attributedString.append(NSAttributedString(string: " on", attributes: [.font: Font.text(14)]))
				return attributedString
			}()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.isUserInteractionEnabled = true
			return label
		}()

		let githubButton: UIButton = {
			let button = UIButton(type: .custom)
			button.setImage(RxMarbles.Image.github, for: .normal)
			button.rx.tap.subscribe { [unowned self] _ in self.openURLinSafariViewController(url: Link.rxSwift) }.disposed(by: _disposeBag)
			button.translatesAutoresizingMaskIntoConstraints = false
			return button
		}()

		let andTwitterLabel: UILabel = {
			let label = UILabel()
			label.text = "and"
			label.font = Font.text(14)
			label.translatesAutoresizingMaskIntoConstraints = false
			return label
		}()

		let rxSwiftTwitterButton: UIButton = {
			let button = UIButton()
			button.setImage(RxMarbles.Image.twitter, for: .normal)
			button.alpha = 0.3
			button.rx.tap.subscribe { [unowned self] _ in self.openURLinSafariViewController(url: Link.rxSwiftTwitter) }.disposed(by: _disposeBag)
			button.translatesAutoresizingMaskIntoConstraints = false
			return button
		}()

		let alasLabel: UILabel = {
			let label = UILabel()
			label.text = "¯\\_(ツ)_/¯"
			label.translatesAutoresizingMaskIntoConstraints = false
			return label
		}()
        
        container.addSubview(manyLikeLabel)
        let manyLikeLabelTop = manyLikeLabel.topAnchor.constraint(equalTo: container.topAnchor)
        let manyLikeLabelCenterX = manyLikeLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        container.addConstraints([manyLikeLabelTop, manyLikeLabelCenterX])
        
        container.addSubview(erikMeijerTwitter)
        let erikMeijerTwitterTop = erikMeijerTwitter.topAnchor.constraint(lessThanOrEqualTo: manyLikeLabel.bottomAnchor, constant: 50)
        let erikMeijerTwitterGreaterTop = erikMeijerTwitter.topAnchor.constraint(greaterThanOrEqualTo: manyLikeLabel.bottomAnchor, constant: 10)
        let erikMeijerTwitterHeight = erikMeijerTwitter.heightAnchor.constraint(equalToConstant: RxMarbles.Image.twitter.size.height)
        let erikMeijerTwitterCenterX = erikMeijerTwitter.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -10)
        container.addConstraints([erikMeijerTwitterTop, erikMeijerTwitterGreaterTop, erikMeijerTwitterHeight, erikMeijerTwitterCenterX])
        
        container.insertSubview(erikMeijerTextView, belowSubview: erikMeijerTwitter)
        let erikMeijerTextViewTop = erikMeijerTextView.topAnchor.constraint(equalTo: erikMeijerTwitter.bottomAnchor, constant: -10)
        let erikMeijerTextViewCenterX = erikMeijerTextView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        container.addConstraints([erikMeijerTextViewTop, erikMeijerTextViewCenterX])
        
        container.addSubview(krunoslavZaherTwitter)
        let krunoslavZaherTwitterTop = krunoslavZaherTwitter.topAnchor.constraint(lessThanOrEqualTo: erikMeijerTextView.bottomAnchor, constant: 30)
        let krunoslavZaherTwitterGreaterTop = krunoslavZaherTwitter.topAnchor.constraint(greaterThanOrEqualTo: erikMeijerTextView.bottomAnchor)
        let krunoslavZaherTwitterHeight = krunoslavZaherTwitter.heightAnchor.constraint(equalToConstant: RxMarbles.Image.twitter.size.height)
        let krunoslavZaherTwitterCenterX = krunoslavZaherTwitter.centerXAnchor.constraint(lessThanOrEqualTo: container.centerXAnchor, constant: 15)
        container.addConstraints([krunoslavZaherTwitterTop, krunoslavZaherTwitterGreaterTop, krunoslavZaherTwitterHeight, krunoslavZaherTwitterCenterX])
        
        container.insertSubview(krunoslavZaherTextView, belowSubview: krunoslavZaherTwitter)
        let krunoslavZaherTextViewTop = krunoslavZaherTextView.topAnchor.constraint(equalTo: krunoslavZaherTwitter.bottomAnchor, constant: -10)
        let krunoslavZaherTextViewCenterX = krunoslavZaherTextView.centerXAnchor.constraint(lessThanOrEqualTo: container.centerXAnchor)
        container.addConstraints([krunoslavZaherTextViewTop, krunoslavZaherTextViewCenterX])
        
        container.addSubview(alasLabel)
        let alasLabelBottom = alasLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        let alasLabelCenterX = alasLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        container.addConstraints([alasLabelBottom, alasLabelCenterX])
        
        container.addSubview(rxSwiftLabel)
        let rxSwiftLabelTop = rxSwiftLabel.topAnchor.constraint(lessThanOrEqualTo: krunoslavZaherTextView.bottomAnchor, constant: 40)
        let rxSwiftLabelBottom = rxSwiftLabel.bottomAnchor.constraint(equalTo: alasLabel.topAnchor, constant: -15)
        let rxSwiftLabelCenterX = rxSwiftLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -60)
        container.addConstraints([rxSwiftLabelTop, rxSwiftLabelCenterX, rxSwiftLabelBottom])
        
        container.addSubview(githubButton)
        let githubButtonLeading = githubButton.leadingAnchor.constraint(equalTo: rxSwiftLabel.trailingAnchor, constant: 10)
        let githubButtonCenterY = githubButton.centerYAnchor.constraint(equalTo: rxSwiftLabel.centerYAnchor)
        container.addConstraints([githubButtonLeading, githubButtonCenterY])
        
        container.addSubview(andTwitterLabel)
        let andTwitterLabelCenterY = andTwitterLabel.centerYAnchor.constraint(equalTo: rxSwiftLabel.centerYAnchor)
        let andTwitterLabelLeading = andTwitterLabel.leadingAnchor.constraint(equalTo: githubButton.trailingAnchor, constant: 10)
        container.addConstraints([andTwitterLabelCenterY, andTwitterLabelLeading])
        
        container.addSubview(rxSwiftTwitterButton)
        let rxSwiftTwitterCenterY = rxSwiftTwitterButton.centerYAnchor.constraint(equalTo: andTwitterLabel.centerYAnchor)
        let rxSwiftTwitterLeading = rxSwiftTwitterButton.leadingAnchor.constraint(equalTo: andTwitterLabel.trailingAnchor, constant: 10)
        container.addConstraints([rxSwiftTwitterCenterY, rxSwiftTwitterLeading])
    }
    
    private func _erikMeijerText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "Erik ", attributes: [.font: Font.text(14)])
        let twitter = NSMutableAttributedString(string: "@headinthebox", attributes: [.link: Link.erikMeijerTwitter, .font: Font.boldText(14)])
        text.append(twitter)
        text.append(NSAttributedString(string: " Meijer\nfor his work on ", attributes: [.font: Font.text(14)]))
        let reactivex = NSMutableAttributedString(string: "Reactive Extensions", attributes: [.link: Link.reactiveX, .font: Font.boldText(14)])
        text.append(reactivex)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 8
        text.addAttributes([.paragraphStyle: paragraph], range: NSMakeRange(0, text.length))
        text.addAttribute(.foregroundColor, value: Color.label, range: NSMakeRange(0, text.length))
        return text
    }
    
    private func _krunoslavZaherText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "Krunoslav ", attributes: [.font: Font.text(14)])
        let twitter = NSMutableAttributedString(string: "@KrunoslavZaher", attributes: [.link: Link.kZaherTwitter, .foregroundColor: UIColor.black, .font: Font.boldText(14)])
        text.append(twitter)
        text.append(NSAttributedString(string: " Zaher\nfor ", attributes: [.font: Font.text(14)]))
        let reactivex = NSMutableAttributedString(string: "RxSwift", attributes: [.link: Link.rxSwift, .foregroundColor: UIColor.black, .font: Font.boldText(14)])
        text.append(reactivex)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 8
        text.addAttributes([.paragraphStyle: paragraph], range: NSMakeRange(0, text.length))
        text.addAttribute(.foregroundColor, value: Color.label, range: NSMakeRange(0, text.length))
        return text
    }
    
    private func _configureAboutPage() {

        let anjLabButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(RxMarbles.Image.anjlab, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

        let rxMarblesLabel: UILabel = {
            let label = UILabel()
            label.text = "RxMarbles"
            label.font = Font.text(25)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let versionLabel: UILabel = {
            let label = UILabel()
            label.text = _version()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let developedByLabel: UILabel = {
            let label = UILabel()
            label.text = "developed by"
            label.font = Font.text(12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        contentView.addSubview(rxMarblesLabel)
        let rxMarblesLabelCenterY = rxMarblesLabel.centerYAnchor.constraint(equalTo: _logoImageView.centerYAnchor, constant: -12)
        let rxMarblesLabelLeading = rxMarblesLabel.leadingAnchor.constraint(equalTo: _resultTimeline.centerXAnchor, constant: pageWidth)
        contentView.addConstraints([rxMarblesLabelCenterY, rxMarblesLabelLeading])
        
        let rxMarblesLabelLeadingAnimation = ConstraintConstantAnimation(superview: contentView, constraint: rxMarblesLabelLeading)
        rxMarblesLabelLeadingAnimation[3.5] = pageWidth
        rxMarblesLabelLeadingAnimation[4]   = -20
        rxMarblesLabelLeadingAnimation[5]   = pageWidth
        animator.addAnimation(rxMarblesLabelLeadingAnimation)

        contentView.addSubview(versionLabel)
        let versionLabelTop = versionLabel.topAnchor.constraint(equalTo: rxMarblesLabel.bottomAnchor)
        let versionLabelLeading = versionLabel.leadingAnchor.constraint(equalTo: rxMarblesLabel.leadingAnchor)
        contentView.addConstraints([versionLabelTop, versionLabelLeading])

        contentView.addSubview(developedByLabel)
        let developedByLabelTop = developedByLabel.topAnchor.constraint(lessThanOrEqualTo: versionLabel.bottomAnchor, constant: 68)
        contentView.addConstraint(developedByLabelTop)
        keepView(developedByLabel, onPage: 4)

        anjLabButton.rx.tap
            .subscribe { [unowned self] _ in self.openURLinSafariViewController(url: Link.anjlab) }
            .disposed(by: _disposeBag)

        contentView.addSubview(anjLabButton)
        let anjLabButtonTop = anjLabButton.topAnchor.constraint(lessThanOrEqualTo: developedByLabel.bottomAnchor, constant: 0)
        let anjLabButtonBottom = anjLabButton.bottomAnchor.constraint(lessThanOrEqualTo: _resultTimeline.topAnchor, constant: -30)
        contentView.addConstraints([anjLabButtonTop, anjLabButtonBottom])
        keepView(anjLabButton, onPage: 4)
        
        let ellipse1 = RxMarbles.Image.ellipse1.imageView()
        ellipse1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ellipse1)
        let ellipse1CenterX = ellipse1.centerXAnchor.constraint(equalTo: anjLabButton.centerXAnchor)
        let ellipse1CenterY = ellipse1.centerYAnchor.constraint(equalTo: anjLabButton.centerYAnchor)
        contentView.addConstraints([ellipse1CenterX, ellipse1CenterY])
        _addMotionEffectToView(view: ellipse1, relativity: (vertical: (min: -5, max: 5), horizontal: (min: -5, max: 5)))
        
        let ellipse2 = RxMarbles.Image.ellipse2.imageView()
        ellipse2.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ellipse2)
        let ellipse2CenterX = ellipse2.centerXAnchor.constraint(equalTo: anjLabButton.centerXAnchor)
        let ellipse2CenterY = ellipse2.centerYAnchor.constraint(equalTo: anjLabButton.centerYAnchor)
        contentView.addConstraints([ellipse2CenterX, ellipse2CenterY])
        _addMotionEffectToView(view: ellipse2, relativity: (vertical: (min: -5, max: 5), horizontal: (min: -5, max: 5)))
    }
    
    override func numberOfPages() -> Int {
        if helpMode {
            return 6
        }
        return 4
    }
    
    //    MARK: Navigation
    
    func _setOffsetAnimated(_ offset: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: self.pageWidth * offset, y: 0), animated: true)
    }
    
    func openURLinSafariViewController(url: NSURL) {
        let safariViewController = SFSafariViewController(url: url as URL)
        present(safariViewController, animated: true, completion: nil)
    }
    
    //    MARK: UIScrollViewDelegate methods
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.x == pageWidth * CGFloat(numberOfPages() - 1) {
            view.isUserInteractionEnabled = false
            if helpMode {
                // Delay before dismiss
                let delay = 0.4
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                Notifications.hideHelpWindow.post()
            }
        }
    }
    
    //    MARK: UIContentContainer
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let page = scrollView.contentOffset.x / pageWidth
        coordinator.animate(alongsideTransition: { _ in
            self.contentView.subviews.forEach { $0.removeFromSuperview() }
        }) { _ in
            self._configurePages()
            self.scrollView.setContentOffset(CGPoint(x: page * self.pageWidth, y: 0), animated: false)
        }
    }
    
    //    MARK: UIInterfaceOrientationMask Portrait only
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //    MARK: Helpers
    
    private func _addMotionEffectToView(view: UIView, relativity: (vertical: (min: Int, max: Int), horizontal: (min: Int, max: Int))) {
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                               type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = relativity.vertical.min
        verticalMotionEffect.maximumRelativeValue = relativity.vertical.max
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                                 type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = relativity.horizontal.min
        horizontalMotionEffect.maximumRelativeValue = relativity.horizontal.max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        view.addMotionEffect(group)
    }
    
    private func _tapRecognizerWithAction(_ eventView: UIView, page: CGFloat) {
        let tap = UITapGestureRecognizer()
        eventView.addGestureRecognizer(tap)
        tap.rx.event
            .subscribe { [unowned self] _ in
                self._setOffsetAnimated(page)
            }
            .disposed(by: _disposeBag)
    }
    
    private func _version() -> String {
        guard let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String,
            let build = info["CFBundleVersion"] as? String
            else { return "Unknwon" }
        
        return "v\(version) build \(build)"
    }
    
    private func _scaleView(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}

extension HelpViewController: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}
