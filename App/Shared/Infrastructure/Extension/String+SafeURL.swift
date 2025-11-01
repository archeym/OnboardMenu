//
//  Extension.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 01/11/2025.
//

import Foundation

extension String {
    /// Returns a properly trimmed and percent-encoded URL.
    /// - Handles whitespace, newline trimming, and invalid URL characters.
    /// - Returns `nil` if the string cannot form a valid URL.
    var asSafeURL: URL? {
        // Trim spaces/newlines
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        // Try direct initialization first
        if let direct = URL(string: trimmed) {
            return direct
        }

        // Fallback: add percent encoding for special characters
        if let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            return URL(string: encoded)
        }

        return nil
    }
}
