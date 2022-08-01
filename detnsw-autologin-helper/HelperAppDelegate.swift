//
//  AppDelegate.swift
//  detnsw-autologin-helper
//
//  Created by circularsprojects on 26/7/2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let defaults = UserDefaults.standard
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let usernamestored = defaults.string(forKey: "username")!
        let passwordstored = String(decoding: kread(service: "detnsw-autologin", account: usernamestored)!, as: UTF8.self)
        
        let url = URL(string:"https://edgeportal.forti.net.det.nsw.edu.au/portal/selfservice/IatE_CP/")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let poststring = "csrfmiddlewaretoken=&username=\(usernamestored)&password=\(passwordstored)"
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

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
