//
//  AppDelegate.swift
//  detnsw-autologin
//
//  Created by Levi Rigger on 22/7/2022.
//

import Cocoa
import ServiceManagement

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let launcherAppId = "com.circularsprojects.detnsw-autologin-helper"
        SMLoginItemSetEnabled(launcherAppId as CFString, true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

