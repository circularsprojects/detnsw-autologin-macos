//
//  AppDelegate.swift
//  detnsw-autologin
//
//  Created by circularsprojects on 22/7/2022.
//

import Cocoa
import ServiceManagement
import Network

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let launcherAppId = "circularsprojects.detnsw-autologin-helper"
        SMLoginItemSetEnabled(launcherAppId as CFString, true)
        
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("We're connected!")
//            } else {
//                print("No connection.")
//            }
//            //print(path.isExpensive)
//        }
//        let queue = DispatchQueue(label: "Monitor")
//        monitor.start(queue: queue)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

