//
//  ViewController.swift
//  Settings
//
//  Created by Sergey Vishnyov on 20.01.22.
//

import UIKit

public enum ButtonType: Int {
    case typeAirmode = 1
    case typeCellular = 2
    case typeWiFi = 3
    case typeBluetooth = 4
    case typeAirdrop = 5
    case typeHotspot = 6
}

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet private var blockView: UIView!
//    @IBOutlet private var blockViewWidth: NSLayoutConstraint!
//    @IBOutlet private var blockViewHeight: NSLayoutConstraint!
//    @IBOutlet private var blockViewRight: NSLayoutConstraint!

    @IBOutlet private var airmodeView: UIView!
    @IBOutlet private var airmodeLabelsView: UIView!
    
    @IBOutlet private var celluralView: UIView!
    @IBOutlet private var celluralLabelsView: UIView!

    @IBOutlet private var wifiView: UIView!
    @IBOutlet private var wifiLabelsView: UIView!

    @IBOutlet private var bluetoothView: UIView!
    @IBOutlet private var bluetoothButton: UIButton!
    @IBOutlet private var bluetoothLabelsView: UIView!

    @IBOutlet private var airdropView: UIView!
//    @IBOutlet private var airdropLabelsView: UIView!

    @IBOutlet private var hotspotView: UIView!
//    @IBOutlet private var hotspotLabelsView: UIView!

    var animator = UIViewPropertyAnimator()
    let leading = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapPress))
        view.addGestureRecognizer(tapPressRecognizer)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 0.2
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.delegate = self
        blockView.addGestureRecognizer(longPressRecognizer)
        
//        let longPressRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        longPressRecognizer1.minimumPressDuration = 0.2
//        longPressRecognizer1.delaysTouchesBegan = true
//        longPressRecognizer1.delegate = self
//        bluetoothButton.addGestureRecognizer(longPressRecognizer1)

        animate(isFull: false, animated: false)
    }
    
    // MARK: - Actions
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let gestureReconizerView = gestureReconizer.view
        print(gestureReconizerView)
        if gestureReconizer.state == .began {
            print("longpressed began")
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
                gestureReconizerView!.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }
            animator.addCompletion { position in
                print("animator.addCompletion")
                UIView.animate(withDuration: 0.25, animations: {
                    gestureReconizerView!.transform = CGAffineTransform.identity
                }, completion: { complete in
                    self.animate(isFull: true)
                })
            }
            animator.startAnimation()
        }
        if gestureReconizer.state == .ended {
            animator.stopAnimation(true)
            UIView.animate(withDuration: 0.25) {
                gestureReconizerView!.transform = CGAffineTransform.identity
            }
            print("longpressed ended")
            
//            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.impactOccurred()
        }
    }

    @objc func handleTapPress() {
        animate(isFull: false)
    }

    func animate(isFull: Bool, animated: Bool = true) {
        var blockWidth = 0.0
        var blockHeight = 0.0
        var cellWidth = 0.0
        var cellHeight = 0.0
        if isFull {
            blockWidth = 320.0
            blockHeight = 480.0
            cellWidth = 160.0
            cellHeight = 160.0
        } else {
            blockWidth = 160.0
            blockHeight = 160.0
            cellWidth = 80.0
            cellHeight = 80.0
        }
        UIView.animate(withDuration: animated ? 0.25 : 0) { [self] in
            blockView.viewSet(width: blockWidth)
            blockView.viewSet(height: blockHeight)
            if isFull {
                blockView.center = view.center
            }
            
            airmodeView.viewSet(x: 0)
            airmodeView.viewSet(y: 0)
            airmodeView.viewSet(width: cellWidth)
            airmodeView.viewSet(height: cellHeight)
            airmodeLabelsView.alpha = isFull ? 1 : 0
            
            celluralView.viewSet(x: cellWidth)
            celluralView.viewSet(y: 0)
            celluralView.viewSet(width: cellWidth)
            celluralView.viewSet(height: cellHeight)
            celluralLabelsView.alpha = isFull ? 1 : 0

            wifiView.viewSet(x: 0)
            wifiView.viewSet(y: cellWidth)
            wifiView.viewSet(width: cellWidth)
            wifiView.viewSet(height: cellHeight)
            wifiLabelsView.alpha = isFull ? 1 : 0

            bluetoothView.viewSet(x: cellWidth)
            bluetoothView.viewSet(y: cellWidth)
            bluetoothView.viewSet(width: cellWidth)
            bluetoothView.viewSet(height: cellHeight)
            bluetoothLabelsView.alpha = isFull ? 1 : 0
            
            airdropView.alpha = isFull ? 1 : 0
            hotspotView.alpha = isFull ? 1 : 0

//                self.blockView.center = self.view.center
//                self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case ButtonType.typeAirmode.rawValue:
            sender.backgroundColor = sender.isSelected ? .orange : .gray
            
            
////            self.blockViewRight.constant = sender.isSelected ? 40 : CGFloat.greatestFiniteMagnitude
//            self.blockViewWidth.constant = self.view.viewWidth - leading * 2
//            self.blockViewHeight.constant = 300
//            UIView.animate(withDuration: 1) {
//                self.blockView.center = self.view.center
////                self.blockView.center = self.view.center
//                self.view.layoutIfNeeded()
//            }

        case ButtonType.typeCellular.rawValue:
            sender.backgroundColor = sender.isSelected ? .systemGreen : .gray
        case ButtonType.typeWiFi.rawValue:
            sender.backgroundColor = sender.isSelected ? .systemBlue : .white
            sender.setTintColor(sender.isSelected ? .white : .gray)
        case ButtonType.typeBluetooth.rawValue:
            sender.backgroundColor = sender.isSelected ? .systemBlue : .white
            sender.setTintColor(sender.isSelected ? .white : .gray)
        default:
            break
        }
        print("bluetoothButtonPressed")
    }
    
    
}
