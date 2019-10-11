//
//  OpenFlutterTabViewController.swift
//  SwiftFlutter
//
//  Created by Abraao on 11/10/19.
//  Copyright © 2019 Abraao Levi. All rights reserved.
//

import UIKit
import Flutter

class OpenFlutterTabViewController: UIViewController {
    
    let flutterEngine = (UIApplication.shared.delegate as? AppDelegate)?.flutterEngine
    var flutterViewController: FlutterViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)!
        
        if let flutterViewController = flutterViewController {
            DispatchQueue.main.async(execute: {
                // flutterViewController.modalPresentationStyle = .overFullScreen
                // self.present(flutterViewController, animated: true, completion: nil)
                self.addChild(flutterViewController)
                self.view.addSubview(flutterViewController.view)
                flutterViewController.view.frame = self.view.bounds
                flutterViewController.view.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
                
                print(self.children)
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillDisappear")

        if let flutterViewController = flutterViewController {
            flutterViewController.removeFromParent()
        }
    }

}
