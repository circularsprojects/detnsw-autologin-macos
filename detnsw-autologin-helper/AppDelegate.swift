//
// AppDelegate.swift
// detnsw-autologin
//
// Created by circular on 27/6/2025
// https://circulars.dev/
//

import Network
import Cocoa
import os.log

class AppDelegate: NSObject, NSApplicationDelegate {
    let defaults = UserDefaults.init(suiteName: "QX9LC82293.com.circularsprojects.detnsw-autologin-group")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        os_log(.info, "App launched")
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                os_log(.info, "Internet connected")
                let usernamestored = defaults!.string(forKey: "username")!
                let passwordstored = String(decoding: kread(service: "detnsw-autologin", account: usernamestored)!, as: UTF8.self)
                
                Utils.login(username: usernamestored, password: passwordstored) { result in
                    if let result = result as? any Error {
                        os_log(.error, "Login failed: \(result.localizedDescription)")
                    } else if let result = result as? Int {
                        os_log(.info, "Logged in with status code: \(result)")
                    }
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
