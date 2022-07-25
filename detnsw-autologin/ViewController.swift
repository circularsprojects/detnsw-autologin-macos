//
//  ViewController.swift
//  detnsw-autologin
//
//  Created by Levi Rigger on 22/7/2022.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    let defaults = UserDefaults.standard
    @IBOutlet var username: NSTextField!
    @IBOutlet var password: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        exit(1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func loginButton(_ sender: NSButton) {
        let username = defaults.string(forKey: "username")!
        //password.stringValue = username ?? "null"
        let password = String(decoding: kread(service: "detnsw-autologin", account: username)!, as: UTF8.self)
        print(password)
    }
    
    @IBAction func saveButton(_ sender: NSButton) {
        defaults.set(username.stringValue, forKey: "username")
        let utf8p = password.stringValue.utf8
        ksave(Data(utf8p), service: "detnsw-autologin", account: username.stringValue)
    }
    
}

