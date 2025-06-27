//
// Main.swift
// detnsw-autologin
//
// Created by circular on 10/4/2025
// https://circulars.dev/
//

import SwiftUI
import ServiceManagement

@main
struct detnsw_autologin: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        
    }
    var body: some Scene {
        WindowGroup("detnsw-autologin") {
            Main()
        }
        .windowResizabilityContentSize()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
            if let window = NSApplication.shared.windows.first {
                window.delegate = self
            }
        }
    
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(nil)
    }
}

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
    var state: NSVisualEffectView.State = .active

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = state
    }
}

struct BlurModifier: ViewModifier {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
    var state: NSVisualEffectView.State = .active

    func body(content: Content) -> some View {
        content
            .background(
                VisualEffectView(material: material, blendingMode: blendingMode, state: state)
            )
    }
}

extension View {
    func blurBackground(
        material: NSVisualEffectView.Material = .sidebar,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        state: NSVisualEffectView.State = .active
    ) -> some View {
        self.modifier(
            BlurModifier(material: material, blendingMode: blendingMode, state: state)
        )
    }
}

struct Main: View {
    let defaults = UserDefaults.init(suiteName: "QX9LC82293.com.circularsprojects.detnsw-autologin-group")
    let AppService = SMAppService.loginItem(identifier: "circularsprojects.detnsw-autologin-helper")
    @State var username: String = ""
    @State var password: String = ""
    @State var autoStart: Bool = false
    @State var autoStartLoaded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("detnsw-autologin")
                .font(.title)
                .bold()
            Form {
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            
            Text("Username and password should match your department login (the login you usually use on detnsw.net)")
                .font(.footnote)
                .multilineTextAlignment(.leading)
            
            HStack {
                Button {
                    Utils.login(username: username, password: password) { result in
                        if let result = result as? any Error {
                            Utils.displayAlert(message: result.localizedDescription)
                        }
                    }
                } label: {
                    Text("Login")
                }
                
                Button {
                    Utils.save(username: username, password: password)
                } label: {
                    Text("Save")
                }
                .buttonStyle(.borderedProminent)
            }
            
            Toggle(isOn: autoStartBinding) {
                Text("Start at login")
            }
            .disabled(AppService.status == .requiresApproval)
            if AppService.status == .requiresApproval {
                HStack(spacing: 2) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.multicolor)
                    Text("Requires approval in System Preferences")
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .blurBackground(material: .hudWindow, blendingMode: .behindWindow, state: .active)
        .task {
            username = defaults!.string(forKey: "username") ?? ""
            password = String(decoding: kread(service: "detnsw-autologin", account: username) ?? Data("".utf8), as: UTF8.self)
            let status = AppService.status
            switch status {
            case .enabled:
                autoStart = true
                print("enabled")
            case .notFound:
                print("not found")
                Utils.displayAlert(message: "Something went wrong getting the auto-start status, checking \"Start at login\" may not work.")
                break
            case .notRegistered:
                print("not registered")
                break
            case .requiresApproval:
                print("requires approval")
                break
            @unknown default:
                fatalError()
            }
            autoStartLoaded = true
        }
    }
    
    private var autoStartBinding: Binding<Bool> {
        Binding(
            get: { autoStart },
            set: { newValue in
                // Only run registration logic if initial load is complete
                if autoStartLoaded {
                    if newValue {
                        do {
                            try AppService.register()
                            Utils.displayAlert(title: "Success", message: "Helper app registered successfully.")
                        } catch {
                            Utils.displayAlert(message: "Failed to register helper app.\n\(error.localizedDescription)")
                        }
                    } else {
                        do {
                            try AppService.unregister()
                            Utils.displayAlert(title: "Success", message: "Helper app unregistered successfully.")
                        } catch {
                            Utils.displayAlert(message: "Failed to unregister helper app.\n\(error.localizedDescription)")
                        }
                    }
                }
                // Always update the actual state
                autoStart = newValue
            }
        )
    }
}

#Preview {
    Main()
}
