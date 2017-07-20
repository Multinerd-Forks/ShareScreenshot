//
//  SSInformationModel.swift
//  ShareScreenshot
//
//  Created by Alexander Danilyak on 19/07/2017.
//

import UIKit

// Model of information that we gonna share
struct SSInformationModel {
    
    // Additional text
    var text: String?
    
    // Screenshot with annotations
    var screenshot: UIImage?
    
    init(with screenshot: UIImage?,
         and text: String? = nil) {
        self.screenshot = screenshot
        self.text = text
    }
    
    // Items to share using UIActivityViewController
    func getActivityItems() -> [Any] {
        return ([text, screenshot] as [Any?]).flatMap { $0 }
    }
    
}


