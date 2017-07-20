//
//  SSScreenshotEditViewController.swift
//  ShareScreenshot
//
//  Created by Alexander Danilyak on 19/07/2017.
//

import UIKit

// This protocol used for updating editor parameters with values in menu
protocol SSEditMenuProtocol: class {
    // Weigt or color changed in settings
    func editSettingsChanged(newSettings: SSEditSettings)
    // Close without drawings
    func discardAndClose()
    // Save and close
    func saveAndClose()
}

class SSScreenshotEditViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var screenshotImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: Properties
    
    var info: SSInformationModel?
    var editSettings: SSEditSettings = SSEditSettings()
    
    weak var previewDelegate: SSPreviewInformationProtocol?
    var jotVC: JotViewController = JotViewController()
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jotVC.delegate = self
        
        addChildViewController(jotVC)
        view.insertSubview(jotVC.view, aboveSubview: screenshotImageView)
        jotVC.didMove(toParentViewController: self)

        jotVC.state = .drawing
        
        applyEditSettings()
        
        settingsButton.layer.shadowColor = UIColor.black.cgColor
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        settingsButton.layer.shadowRadius = 3.0
        settingsButton.layer.shadowOpacity = 0.21
        
        settingsButton.setTitle(String.localized(key: "ssscreenshot.edit.menu"),
                                for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenshotImageView.image = info?.screenshot
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        jotVC.view.frame = screenshotImageView.frame
    }
    
    // MARK: Edit Settings
    
    func applyEditSettings() {
        jotVC.drawingColor = editSettings.colors[editSettings.selectedColorIndex]
        jotVC.drawingStrokeWidth = CGFloat(editSettings.currentLineWeight)
    }
    
    // MARK: Status Bar
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Segue IDs
    
    enum SegueId: String {
        case onMenu
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.onMenu.rawValue {
            guard let editSettingsVC = segue.destination as? SSEditMenuViewController,
                let ppc = editSettingsVC.popoverPresentationController,
                let button = sender as? UIButton else {
                    return
            }
            
            editSettingsVC.editDelegate = self
            editSettingsVC.editSettings = editSettings
            editSettingsVC.preferredContentSize = CGSize(width: 240, height: 300)
            
            ppc.sourceView = button
            ppc.sourceRect = button.bounds
            ppc.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}

extension SSScreenshotEditViewController: SSEditMenuProtocol {
    
    func editSettingsChanged(newSettings: SSEditSettings) {
        editSettings = newSettings
        applyEditSettings()
    }
    
    func discardAndClose() {
        jotVC.clearAll()
        dismiss(animated: true, completion: nil)
    }
    
    func saveAndClose() {
        let imageWithDrawings = createResultImage()
        let newInfo = SSInformationModel(with: imageWithDrawings, and: info?.text)
        previewDelegate?.infoDidUpdate(newInfo: newInfo)
        dismiss(animated: true, completion: nil)
    }

    // Capturing drawings and merging with original image
    private func createResultImage() -> UIImage {
        let scale = UIScreen.main.scale
        let renderedDrawings = jotVC.renderImage(withScale: scale)
        
        let rect = view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size,
                                               false,
                                               scale)
        
        guard let screnshot = screenshotImageView.image else {
            return UIImage()
        }
        
        screnshot.draw(in: rect)
        renderedDrawings?.draw(in: rect, blendMode: .normal, alpha: 1.0)
        
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        return result
    }
    
}

extension SSScreenshotEditViewController: JotViewControllerDelegate {}

extension SSScreenshotEditViewController: UIPopoverPresentationControllerDelegate {}
