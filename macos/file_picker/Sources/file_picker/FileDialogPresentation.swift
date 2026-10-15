import Cocoa

/// Sheet panels do not consistently display their window title. The message
/// keeps the caller's purpose visible inside both open and save panels.
func applyFileDialogTitle(_ panel: NSSavePanel, title: String?) {
    guard let title = title, !title.isEmpty else { return }
    panel.title = title
    panel.message = title
}
