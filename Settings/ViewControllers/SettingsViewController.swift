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
}

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet private var view4: UIView!
    
    var animator = UIViewPropertyAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 0.2
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.delegate = self
        view4.addGestureRecognizer(longPressRecognizer)

    }
    
    // MARK: - Actions
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            print("longpressed began")
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
                self.view4.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }
            animator.addCompletion { position in
                print("animator.addCompletion")
            }
            animator.startAnimation()
        }
        if gestureReconizer.state == .ended {
            animator.stopAnimation(true)
            UIView.animate(withDuration: 0.25) {
                self.view4.transform = CGAffineTransform.identity
            }
            print("longpressed ended")
            
//            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.impactOccurred()
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case ButtonType.typeAirmode.rawValue:
            sender.backgroundColor = sender.isSelected ? .orange : .gray
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
