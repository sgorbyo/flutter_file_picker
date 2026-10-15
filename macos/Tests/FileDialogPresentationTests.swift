import Cocoa

@main
struct FileDialogPresentationTests {
    static func main() {
        _ = NSApplication.shared
        for panel in [NSOpenPanel(), NSSavePanel()] {
            let title = "Recover documents — choose \"backup\"\n(.igenbackup)"
            applyFileDialogTitle(panel, title: title)
            precondition(panel.title == title)
            precondition(panel.message == title)
            applyFileDialogTitle(panel, title: nil)
            precondition(panel.message == title)
        }
        print("Open and save panel purpose tests passed")
    }
}
