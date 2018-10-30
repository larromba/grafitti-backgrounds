import Cocoa

private func main() {
    let app = NSApplication.shared
    NSApp = app
    app.delegate = AppDelegateFactory.make(for: app)
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

main()
