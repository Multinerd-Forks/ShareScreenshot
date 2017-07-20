//
//  SSPreviewInformationViewController.swift
//  ShareScreenshot
//
//  Created by Alexander Danilyak on 19/07/2017.
//

import UIKit

// Editor send information to Preview Controller with this protocol
protocol SSPreviewInformationProtocol: class {
    // Info was updated
    func infoDidUpdate(newInfo: SSInformationModel)
}

class SSPreviewInformationViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: Properties
    
    var info: SSInformationModel?
    
    var hasInfo: Bool {
        return info != nil
    }
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.title = String.localized(key: "ssscreenshot.cancel")
        shareButton.title = String.localized(key: "ssscreenshot.share")
        title = String.localized(key: "ssscreenshot.info")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Actions
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShare(_ sender: Any) {
        guard let i = info else {
            return
        }
        
        let shareVC = UIActivityViewController(activityItems: i.getActivityItems(),
                                               applicationActivities: SSShareScreenshotManager.shared.customActivities)
        present(shareVC, animated: true, completion: nil)
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.toEditor.rawValue {
            guard let editor = segue.destination as? SSScreenshotEditViewController else {
                return
            }
            
            editor.previewDelegate = self
            editor.info = info
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSourc
extension SSPreviewInformationViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return hasInfo ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasInfo ? 2 : 0
    }
    
    enum TableViewCellId: String {
        case screenshotCell
        case descriptionCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            guard let screenshotCell
                = tableView.dequeueReusableCell(withIdentifier: TableViewCellId.screenshotCell.rawValue,
                                                for: indexPath) as? ScreenshotCell else {
                                                    return UITableViewCell()
            }
            screenshotCell.screenshotImageView.image = info?.screenshot
            return screenshotCell
        case (0, 1):
            guard let descriptionCell
                = tableView.dequeueReusableCell(withIdentifier: TableViewCellId.descriptionCell.rawValue,
                                                for: indexPath) as? DescriptionCell else {
                                                    return UITableViewCell()
            }
            descriptionCell.descriptionTextView.text = info?.text
            descriptionCell.descriptionTextView.delegate = self
            return descriptionCell
        default:
            fatalError("[ShareScreenshot] Unexpected cell index")
        }
    }
    
    enum SegueId: String {
        case toEditor
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section, indexPath.row) == (0, 0) {
            performSegue(withIdentifier: SegueId.toEditor.rawValue, sender: self)
        }
    }
    
}

extension SSPreviewInformationViewController: UITextViewDelegate {
    
    // Saving new text
    func textViewDidChange(_ textView: UITextView) {
        info?.text = textView.text
    }
    
}

extension SSPreviewInformationViewController: SSPreviewInformationProtocol {
    
    // Saving new info after drawings
    func infoDidUpdate(newInfo: SSInformationModel) {
        info = newInfo
        tableView.reloadData()
    }
    
}
