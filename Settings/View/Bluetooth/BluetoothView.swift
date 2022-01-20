//
//  BluetoothView.swift
//  Settings
//
//  Created by Sergey Vishnyov on 20.01.22.
//

import UIKit

struct Bluetooth {
    var name: String!
    var status: String!
}

class BluetoothView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!
    
    let dataArray = [
        Bluetooth(name: "AirPods Pro (Александр)", status: "Connected"),
        Bluetooth(name: "MI Band 2", status: "Connected")
    ]

    override func draw(_ rect: CGRect) {
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.move(to: CGPoint(x: tableView.viewX, y: tableView.viewY))
        cgContext?.addLine(to: CGPoint(x: tableView.viewWidth, y: tableView.viewY))
        cgContext?.move(to: CGPoint(x: tableView.viewX, y: tableView.viewHeight_Y))
        cgContext?.addLine(to: CGPoint(x: tableView.viewWidth, y: tableView.viewHeight_Y))
        cgContext?.setStrokeColor(UIColor.white.cgColor)
        cgContext?.setLineWidth(0.5)
        cgContext?.strokePath()
    }
    
    // MARK: - Actions
    @IBAction func settingsPressed(_ sender: UIButton) {
//        iOS has never publicly supported any URL scheme to launching any Settings page except your own app's page
        UIApplication.shared.open(URL(string: "App-Prefs:root=General&path=Bluetoth")!)
    }

    // MARK: - UITableView Delegate
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 46
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        let bluetooth = dataArray[indexPath.row]
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.text = bluetooth.name
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = bluetooth.status
        cell.detailTextLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
