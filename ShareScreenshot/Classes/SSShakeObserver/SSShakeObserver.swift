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
        let scale = UIScreen.main.scale
        let bounds = layer.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size,
                                               false,
                                               scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
    
        layer.render(in: context)
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    fileprivate class func topViewController(base: UIViewController?) -> UIViewController? {
        if let navigation = base as? UINavigationController {
            return topViewController(base: navigation)
        }
        
        if let tab = base as? UITabBarController,
            let selected = tab.selectedViewController {
                return topViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
}

class SSShakeObserver {
    
    @nonobjc
    static let shared: SSShakeObserver = SSShakeObserver()
    
    @nonobjc
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
        
        guard let topVC = UIWindow.topViewController(base: rootVC) else {
            return
        }
        
        topVC.present(shareScreenshotNav, animated: true, completion: nil)
    }
    
}
