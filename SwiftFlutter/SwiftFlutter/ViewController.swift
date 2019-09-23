//
//  ViewController.swift
//  SwiftFlutter
//
//  Created by Abraao Levi on 21/09/19.
//  Copyright © 2019 Abraao Levi. All rights reserved.
//

import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.handleButtonAction), for: .touchUpInside)
        button.setTitle("Press me", for: .normal)
        button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
        button.backgroundColor = .blue
        
        self.view.addSubview(button)
    }

    @objc func handleButtonAction() {
        let flutterEngine = (UIApplication.shared.delegate as? AppDelegate)?.flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)!
        
        self.present(flutterViewController, animated: false, completion: nil)
    }
}

