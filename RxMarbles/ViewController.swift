//
//  ViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    var currentScene: TemplateScene?
    var currentOperator = ["id" : "delay", "title": NSLocalizedString("delay", comment: "")]
    var operatorTableViewController: OperatorTableViewController?
    var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentOperator["title"]
        view.backgroundColor = .whiteColor()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addElement")
        self.navigationItem.leftBarButtonItem = addButton
        
        let operatorButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "showOperatorView")
        self.navigationItem.rightBarButtonItem = operatorButton
        
        setupSpriteKitView()
    }
    
    override func viewWillAppear(animated: Bool) {
        if operatorTableViewController != nil {
            currentOperator = (operatorTableViewController?.selectedOperator)! as! [String : String]
            title = currentOperator["title"]
            let scene = currentOperator["id"]! as String
            
            let newScene: TemplateScene!
            
            switch scene {
            case "delay":
                newScene = DelayScene(size: view.frame.size)
            case "map":
                newScene = MapScene(size: view.frame.size)
            case "scan":
                newScene = ScanScene(size: view.frame.size)
            case "debounce":
                newScene = DebounceScene(size: view.frame.size)
                
            case "startWith":
                newScene = StartWithScene(size: view.frame.size)
                
            case "distinctUntilChanged":
                newScene = DistinctUntilChangedScene(size: view.frame.size)
            case "elementAt":
                newScene = ElementAtScene(size: view.frame.size)
            case "filter":
                newScene = FilterScene(size: view.frame.size)
            case "skip":
                newScene = SkipScene(size: view.frame.size)
            case "take":
                newScene = TakeScene(size: view.frame.size)
            case "takeLast":
                newScene = TakeLastScene(size: view.frame.size)
                
            case "reduce":
                newScene = ReduceScene(size: view.frame.size)
                
            default:
                newScene = DelayScene(size: view.frame.size)
            }
            
            self.currentScene = newScene
            skView.presentScene(newScene)
        }
    }
    
    private func setupSpriteKitView() {
        skView = SKView()
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.backgroundColor = SKColor.whiteColor()
        
        self.view.addSubview(skView)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-6-[skView]-6-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["skView" : skView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[skView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["skView" : skView]))
        
        let delayScene = DelayScene(size: view.frame.size)
        self.currentScene = delayScene
        skView.presentScene(delayScene)
    }
    
    func addElement() {
        self.currentScene?.addElement()
    }
    
    func showOperatorView() {
        operatorTableViewController = OperatorTableViewController()
        operatorTableViewController?.selectedOperator = currentOperator
        self.presentViewController(operatorTableViewController!, animated: true) { () -> Void in }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}