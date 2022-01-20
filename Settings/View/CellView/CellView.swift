//
//  CellView.swift
//  Settings
//
//  Created by Sergey Vishnyov on 20.01.22.
//

public enum CellType {
    case typeAirmode
    case typeCellular
    case typeWiFi
    case typeBluetooth
    case typeAirdrop
    case typeHotspot
}

import UIKit

class CellView: UIView {
    var cellType: CellType!
    @IBOutlet var button: UIButton!
    @IBOutlet var labelsView: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func set(cellType: CellType!) {
        self.cellType = cellType
        var image = UIImage()
        button.isSelected = true
        switch cellType {
        case .typeAirmode:
            image = #imageLiteral(resourceName: "airmode")
            nameLabel.text = "Airplane Mode"
            button.isSelected = false
        case .typeCellular:
            image = #imageLiteral(resourceName: "cellular")
            nameLabel.text = "Mobile Data"
        case .typeWiFi:
            image = #imageLiteral(resourceName: "wifi")
            nameLabel.text = "Wi-Fi"
            statusLabel.text = "ZTE"
        case .typeBluetooth:
            image = #imageLiteral(resourceName: "bluetooth")
            nameLabel.text = "Bluetooth"
        case .typeAirdrop:
            image = #imageLiteral(resourceName: "airdrop")
            nameLabel.text = "AirDrop"
            button.isSelected = false
        case .typeHotspot:
            image = #imageLiteral(resourceName: "hotspot")
            nameLabel.text = "Personal Hotspot"
            statusLabel.text = "Not Discoverable"
            button.isSelected = false
        default:
            break
        }
        button.setImage(image, for: .normal)
        updateUI()
    }
    
    // MARK: - UI
    func updateUI() {
        switch cellType {
        case .typeAirmode:
            button.backgroundColor = button.isSelected ? .orange : .gray
        case .typeCellular:
            button.backgroundColor = button.isSelected ? .systemGreen : .gray
        case .typeWiFi, .typeBluetooth, .typeAirdrop, .typeHotspot:
            button.backgroundColor = button.isSelected ? .systemBlue : .white
            button.setTintColor(button.isSelected ? .white : .gray)
        default:
            break
        }
        
        switch cellType {
        case .typeAirmode, .typeCellular, .typeBluetooth:
            statusLabel.text = button.isSelected ? "On" : "Off"
        case .typeAirdrop:
            statusLabel.text = "Receiving " + (button.isSelected ? "on" : "off")
        default:
            break
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateUI()
    }
}
