//
//  CalculatorViewController.swift
//  SwiftFlutter
//
//  Created by Abraao on 11/10/19.
//  Copyright © 2019 Abraao Levi. All rights reserved.
//

import UIKit
import Flutter

class CalculatorViewController: UIViewController {

    @IBOutlet weak var firstNumberTextField: UITextField!
    @IBOutlet weak var secondNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        firstNumberTextField.keyboardType = .numberPad
//        secondNumberTextField.keyboardType = .numberPad
    }

    @IBAction func validateInputs(_ sender: Any) {
        let ( firstNumber, secondNumber ) = isINputValid()
        if firstNumber > 0, secondNumber > 0 {
            sendDataToFlutterModule(firstNumber, secondNumber)
        }
    }
    
    func sendDataToFlutterModule(_ first: Int, _ second: Int) {

        // Workaround to routes, create new flutterEngine with entrypoint to start in `main.dart`
        // WARNINING: its create a momory leak
        let flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
        flutterEngine.run(withEntrypoint: "openCalculator")

        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)!;

        self.present(flutterViewController, animated: true, completion: nil)
        
        // Set up data channel to send/receive data from flutter_module
        let flutterDataChannel = FlutterMethodChannel(name: "com.myCustomChannelData/data",
                                                  binaryMessenger: flutterViewController.binaryMessenger)
        
        // setting up method call handler to receive data from flutter_module
        flutterDataChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            
            // receiving data from flutter_module and showing results in UI
            guard call.method == "FromClientToHost" else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            flutterViewController.dismiss(animated: true, completion: nil)
            
            if let dictonary = call.arguments as? NSDictionary {
                self?.resultLabel.text = "\((dictonary["operation"] as! String)=="Add" ? "Addition" : "Multiplication"): \(dictonary["result"]!)"
            } else {
                self?.resultLabel.text = "Could not perform the operation"
            }
        }
        
        // Sending data to flutter_module
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(first, forKey: "first")
        jsonObject.setValue(second, forKey: "second")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            let jsonString = String(data: json, encoding: .utf8)
            flutterDataChannel.invokeMethod("fromHostToClient", arguments: jsonString)
        } catch let error {
            print(error)
        }
    }
    
    func isINputValid() -> (Int, Int) {
        let firstNumber = firstNumberTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let secondNumber = secondNumberTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if firstNumber.isEmpty {
            showMessage(msg: "Enter value first number")
        } else if secondNumber.isEmpty {
            showMessage(msg: "Enter value second number")
        } else {
            return (Int(firstNumber)!, Int(secondNumber)!)
        }
        
        return (0, 0)
    }
    
    func showMessage(msg: String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
