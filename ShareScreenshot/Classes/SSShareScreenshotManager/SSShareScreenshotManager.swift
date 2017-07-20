//
//  SSShareScreenshotManager.swift
//  ShareScreenshot
//
//  Created by Alexander Danilyak on 20/07/2017.
//

import Foundation

// Entry point to framework
public class SSShareScreenshotManager {
    
    @nonobjc
    public static let shared = SSShareScreenshotManager()
    
    // Custom activities, used for sharing
    public var customActivities: [UIActivity] = []
    
    // Start observing motion shake
    public func start() {
        SSShakeObserver.shared.start()
    }
    
    // Stop observing motion shake
    public func stop() {
        SSShakeObserver.shared.stop()
    }
    
}
