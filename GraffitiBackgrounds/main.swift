import Cocoa

// using custom NSApplicationMain as this is a UIElement app
private func main() {
    let app = NSApplication.shared
    NSApp = app
    if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
        app.delegate = AppDelegateFactory.make(for: app)
    }
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

main()
