//
//  ViewController.swift
//  detnsw-autologin
//
//  Created by circularsprojects on 22/7/2022.
//

import Cocoa
import ServiceManagement

class ViewController: NSViewController, NSWindowDelegate {
    let defaults = UserDefaults.init(suiteName: "QX9LC82293.com.circularsprojects.detnsw-autologin-group")
    @IBOutlet var username: NSTextField!
    @IBOutlet var password: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let usernamestored = defaults!.string(forKey: "username") ?? ""
        let passwordstored = String(decoding: kread(service: "detnsw-autologin", account: usernamestored) ?? Data("".utf8), as: UTF8.self)
        username.stringValue = usernamestored
        password.stringValue = passwordstored
    }
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        exit(1)
    }

    override var representedObject: Any? {
        didSet {}
    }

    @IBAction func loginButton(_ sender: NSButton) {
        let url = URL(string:"https://edgeportal.forti.net.det.nsw.edu.au/portal/selfservice/IatE_CP/")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let poststring = "csrfmiddlewaretoken=&username=\(username.stringValue)&password=\(password.stringValue)"
        request.httpBody = poststring.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                let alert = NSAlert()
                alert.messageText = "An error occurred"
                alert.informativeText = error.localizedDescription
                alert.addButton(withTitle: "OK")
                alert.addButton(withTitle: "Cancel")
                alert.alertStyle = .warning
                alert.runModal()
                return
            }
            if let data = data, let _ = String(data: data, encoding: .utf8) {}
        }
        task.resume()
    }
    
    @IBAction func saveButton(_ sender: NSButton) {
        let usernamestored = defaults!.string(forKey: "username")
        if (username.stringValue == usernamestored) {
            let utf8p = password.stringValue.utf8
            ksave(Data(utf8p), service: "detnsw-autologin", account: username.stringValue)
        } else {
            if (usernamestored == nil) {
                defaults!.set(username.stringValue, forKey: "username")
                let utf8p = password.stringValue.utf8
                ksave(Data(utf8p), service: "detnsw-autologin", account: username.stringValue)
            } else {
                kdelete(service: "detnsw-autologin", account: usernamestored!)
                defaults!.set(username.stringValue, forKey: "username")
                let utf8p = password.stringValue.utf8
                ksave(Data(utf8p), service: "detnsw-autologin", account: username.stringValue)
            }
        }
    }
    @IBAction func enableLogin(_ sender: NSButton) {
        let launcherAppId = "circularsprojects.detnsw-autologin-helper"
        SMLoginItemSetEnabled(launcherAppId as CFString, true)
    }
    @IBAction func disableLogin(_ sender: NSButton) {
        let launcherAppId = "circularsprojects.detnsw-autologin-helper"
        SMLoginItemSetEnabled(launcherAppId as CFString, false)
    }
}

