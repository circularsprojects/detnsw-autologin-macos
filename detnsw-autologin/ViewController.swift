//
//  ViewController.swift
//  detnsw-autologin
//
//  Created by Levi Rigger on 22/7/2022.
//

import Cocoa

class ViewController: NSViewController {
    let defaults = UserDefaults.standard
    @IBOutlet var username: NSTextField!
    @IBOutlet var password: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func loginButton(_ sender: NSButton) {
        let username = defaults.string(forKey: "username")
        password.stringValue = username ?? "null"
    }
    
    @IBAction func saveButton(_ sender: NSButton) {
        defaults.set(username.stringValue, forKey: "username")
    }
    
}

