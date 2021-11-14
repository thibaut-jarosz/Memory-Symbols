import Foundation

extension AttributedString {
    /// Creates an attributed string from a Localized Markdown-formatted string.
    /// - Parameter localizedMarkdown: The string that contains the localization key of the Markdown-formatted string.
    ///
    /// If markdown formatting fails, it falls back to localized string without markdown formatting
    init(localizedMarkdown: String.LocalizationValue) {
        do {
            try self.init(markdown: .init(localized: localizedMarkdown))
        }
        catch {
            self.init(localized: localizedMarkdown)
        }
    }
}
