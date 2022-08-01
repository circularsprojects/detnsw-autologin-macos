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
        let usernamestored = defaults.string(forKey: "username")!
        //password.stringValue = username ?? "null"
        let passwordstored = String(decoding: kread(service: "detnsw-autologin", account: usernamestored)!, as: UTF8.self)
        print(usernamestored)
        print(passwordstored)
        
        let url = URL(string:"https://edgeportal.forti.net.det.nsw.edu.au/portal/selfservice/IatE_CP/")
        //let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let poststring = "csrfmiddlewaretoken=&username=\(username.stringValue)&password=\(password.stringValue)"
        request.httpBody = poststring.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                //print("Response data string:\n \(dataString)")
                //print(response.statusCode)
            }
        }
        task.resume()
    }
    
    @IBAction func saveButton(_ sender: NSButton) {
        let usernamestored = defaults.string(forKey: "username")
        if (username.stringValue == usernamestored) {
            let utf8p = password.stringValue.utf8
            ksave(Data(utf8p), service: "detnsw-autologin", account: username.stringValue)
        } else {
            kdelete(service: "detnsw-autologin", account: usernamestored!)
            defaults.set(username.stringValue, forKey: "username")
            let utf8p = password.stringValue.utf8
            ksave(Data(utf8p), service: "detnsw-autologin", account: username.stringValue)
        }
    }
}

