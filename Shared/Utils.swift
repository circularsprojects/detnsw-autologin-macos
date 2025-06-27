//
// api.swift
// detnsw-autologin
//
// Created by circular on 26/6/2025
// https://circulars.dev/
//

import Foundation
import AppKit
        
class Utils {
    static let defaults = UserDefaults.init(suiteName: "QX9LC82293.com.circularsprojects.detnsw-autologin-group")
    
    static func login(username: String, password: String, completion: @escaping (Any) -> Void) {
        let url = URL(string:"https://edgeportal.forti.net.det.nsw.edu.au/portal/selfservice/IatE_CP/")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        let poststring = "csrfmiddlewaretoken=&username=\(username)&password=\(password)"
        request.httpBody = poststring.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(error ?? URLError(.badServerResponse))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            if let data = data, let _ = String(data: data, encoding: .utf8) {}
            
            completion(response.statusCode)
        }
        task.resume()
    }
    
    static func save(username: String, password: String) {
        let usernamestored = defaults!.string(forKey: "username")
        let utf8p = password.utf8
        if (username == usernamestored) { /// If entered username matches stored username, then overwrite
            ksave(Data(utf8p), service: "detnsw-autologin", account: username)
        } else {
            if (usernamestored == nil) { /// If entered username does not match stored username and there wasn't a username stored to begin with
                defaults!.set(username, forKey: "username")
                ksave(Data(utf8p), service: "detnsw-autologin", account: username)
            } else { /// If entered username does not match stored username but stored username *does* exist
                kdelete(service: "detnsw-autologin", account: usernamestored!)
                defaults!.set(username, forKey: "username")
                ksave(Data(utf8p), service: "detnsw-autologin", account: username)
            }
        }
    }
    
    static func displayAlert(title: String = "An error occurred", message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.addButton(withTitle: "OK")
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
}
