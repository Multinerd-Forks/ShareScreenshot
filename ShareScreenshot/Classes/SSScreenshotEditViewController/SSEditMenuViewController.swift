//
//  SSEditMenuViewController.swift
//  ShareScreenshot
//
//  Created by Alexander Danilyak on 19/07/2017.
//

import UIKit

class SSEditMenuViewController: UITableViewController {

    // MARK: Properties
    
    var editSettings: SSEditSettings = SSEditSettings()
    weak var editDelegate: SSEditMenuProtocol?
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Slider
        weightSlider.minimumValue = editSettings.minLineWeight
        weightSlider.maximumValue = editSettings.maxLineWeight
        weightSlider.value = editSettings.currentLineWeight
        
        // Colors
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        
    }
    
    // MARK: Weight
    
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBAction func weightChanged(_ sender: Any) {
        editSettings.currentLineWeight = weightSlider.value
        editDelegate?.editSettingsChanged(newSettings: editSettings)
    }
    
    // MARK: Colors
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
}

extension SSEditMenuViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 3.0
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            dismiss(animated: true) { [weak self] in
                self?.editDelegate?.discardAndClose()
            }
        case (1, 1):
            dismiss(animated: true) { [weak self] in
                self?.editDelegate?.saveAndClose()
            }
        default:
            return
        }
    }
    
}

extension SSEditMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editSettings.colors.count
    }
    
    enum CollectionCellId: String {
        case colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellId.colorCell.rawValue,
                                                                 for: indexPath) as? ColorCollectionCell else {
                                                                    return UICollectionViewCell()
        }
        
        colorCell.colorView.layer.borderColor = UIColor.standardBlue.cgColor
        colorCell.colorView.layer.borderWidth = indexPath.row == editSettings.selectedColorIndex ? 2.5 : 0.0
            
        colorCell.colorView.backgroundColor = editSettings.colors[indexPath.row]
        
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        editSettings.selectedColorIndex = indexPath.row
        collectionView.reloadData()
        editDelegate?.editSettingsChanged(newSettings: editSettings)
    }
    
}
