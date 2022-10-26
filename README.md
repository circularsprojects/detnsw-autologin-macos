# detnsw-autologin-macos
a version of detnsw-autologin made for macos\
now made in xcode swift and not xamarin.mac because it sucked
## to-dos (basically just notes for me):
 - check macos version (`ProcessInfo.processInfo.operatingSystemVersion.majorVersion`)
    - 12: use SMLoginItem...
    - 13: use register()
    - will be done when macos 13 releases (because i dont want to update to a beta right now)
nvm all that is kind of garbage because it works on ventura anyways
