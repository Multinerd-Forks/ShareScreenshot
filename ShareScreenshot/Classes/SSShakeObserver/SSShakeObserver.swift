//
//  SSShakeObserver.swift
//  Pods
//
//  Created by Alexander Danilyak on 19/07/2017.
//
//

import UIKit

// MARK: - UIWindow extension that send notifications than device shaken occured
extension UIWindow {
    
    /// Detetcing motion shake and posting notification
    ///
    /// - Parameters:
    ///   - motion: any mothion that happens
    ///   - event: any event
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: SSShakeObserver.shakeNotificationName,
                                            object: self)
        }
        
        super.motionEnded(motion, with: event)
    }
    
    /// Capturing screenshot
    ///
    /// - Returns: screenshot
    func captureScreenshot() -> UIImage? {
        guard let rootVC = rootViewController else {
            return nil
        }
        
        let scale = UIScreen.main.scale
        let bounds = rootVC.view.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size,
                                               false,
                                               scale)

        guard let _ = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        rootVC.view.drawHierarchy(in: bounds,
                                  afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
    
}

class SSShakeObserver {
    
    static let shared: SSShakeObserver = SSShakeObserver()
    
    fileprivate static let shakeNotificationName = Notification.Name(rawValue: "SSShakeObserverOnShakeNotification")
    private var isObservingMotionShake = false
    
    func start() {
        isObservingMotionShake = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shakeOccured(notification:)),
                                               name: SSShakeObserver.shakeNotificationName,
                                               object: nil)
    }
    
    func stop() {
        isObservingMotionShake = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func shakeOccured(notification: Notification) {
        guard isObservingMotionShake,
            let window: UIWindow = notification.object as? UIWindow,
            let rootVC = window.rootViewController,
            let screenshot = window.captureScreenshot(),
            let shareScreenshotNav = UITools.shareScreenshotNavigation else {
                return
        }
        
        let info = SSInformationModel(with: screenshot)
        if let previewVC = shareScreenshotNav.viewControllers.first as? SSPreviewInformationViewController {
            previewVC.info = info
        }
        
        rootVC.present(shareScreenshotNav, animated: true, completion: nil)
    }
    
}
