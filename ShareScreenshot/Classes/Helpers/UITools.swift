//
//  UITools.swift
//  ShareScreenshot
//
//  Created by Alexander Danilyak on 19/07/2017.
//

import UIKit

extension Bundle {
    
    // Shortcut for accessing Pod's bundle
    static func podBundle(for anyClass: AnyClass = UITools.self) -> Bundle? {
        let rootBundle = Bundle(for: anyClass)
        guard let url = rootBundle.url(forResource: "ShareScreenshot", withExtension: "bundle") else {
            return nil
        }
        
        return Bundle(url: url)
    }
    
}

// All UI helpers
class UITools {
    // Main Pod's Storyboard name
    private static let shareScreenshotStoryboard: String = "ShareScreenshot"
    
    // Initial Nav Controller
    static var shareScreenshotNavigation: UINavigationController? {
        return UIStoryboard(name: shareScreenshotStoryboard, bundle: Bundle.podBundle()).instantiateInitialViewController() as? UINavigationController
    }
}

extension UIColor {
    
    // Shortcut for creating UIColor with a hex string like this "ff00ff"
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    // Default Apple's blue color
    static var standardBlue: UIColor = UIColor(hexString: "007AFF")
    
}

extension String {
    
    // Shortcut for localized string
    static func localized(key: String) -> String {
        guard let bundle = Bundle.podBundle() else {
            return key
        }
        
        return NSLocalizedString(key,
                                 tableName: "Localizable",
                                 bundle: bundle,
                                 value: "",
                                 comment: "")
    }
    
}
