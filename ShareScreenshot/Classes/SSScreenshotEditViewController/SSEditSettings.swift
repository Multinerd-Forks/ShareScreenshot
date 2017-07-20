//
//  SSEditSettings.swift
//  ShareScreenshot
//
//  Created by Alexander Danilyak on 19/07/2017.
//

import UIKit

// Model for editor params
struct SSEditSettings {
    
    // Index of selected color to draw
    var selectedColorIndex: Int = 0
    // Fixed number of colors
    var colors: [UIColor] = [
        UIColor(hexString: "f60056"), // red-pink
        UIColor(hexString: "f98000"), // orange
        UIColor(hexString: "fcc100"), // yellow
        UIColor(hexString: "5fd51c"), // green
        UIColor(hexString: "269df9"), // blue
        UIColor(hexString: "ba59dd"), // magenta
        UIColor(hexString: "000000"), // black
        UIColor(hexString: "ffffff") // white
    ]
    
    // Default line weight
    var currentLineWeight: Float = 6
    // Min weight
    var minLineWeight: Float = 2.0
    // Max weight
    var maxLineWeight: Float = 14.0
    
}
