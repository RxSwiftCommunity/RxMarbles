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
    
    private var _currentScene: Scene?
    private var _currentOperator = Operator.Delay
    private var _operatorTableViewController: OperatorTableViewController?
    private var _skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = _currentOperator.description
        view.backgroundColor = .whiteColor()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addElement")
        self.navigationItem.leftBarButtonItem = addButton
        
        let operatorButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "showOperatorView")
        self.navigationItem.rightBarButtonItem = operatorButton
        
        setupSpriteKitView()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let newOperator = _operatorTableViewController?.selectedOperator {
            _currentOperator = newOperator
        }
        title = _currentOperator.description
        
        let newScene = Scene(size: view.frame.size, op: _currentOperator)
        
        _currentScene = newScene
        _skView.presentScene(newScene)
    }
    
    private func setupSpriteKitView() {
        _skView = SKView()
        _skView.translatesAutoresizingMaskIntoConstraints = false
        _skView.backgroundColor = SKColor.whiteColor()
        
        view.addSubview(_skView)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-6-[skView]-6-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["skView" : _skView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[skView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["skView" : _skView]))
    }
    
    func addElement() {
        _currentScene?.addElement()
    }
    
    func showOperatorView() {
        _operatorTableViewController = OperatorTableViewController()
        _operatorTableViewController?.selectedOperator = _currentOperator
        _operatorTableViewController?.title = "Select Operator"
        navigationController?.pushViewController(_operatorTableViewController!, animated: true)
    }
}