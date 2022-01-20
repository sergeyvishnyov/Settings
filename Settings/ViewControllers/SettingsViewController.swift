//
//  ViewController.swift
//  Settings
//
//  Created by Sergey Vishnyov on 20.01.22.
//

import UIKit

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet private var blockView: UIView!

    @IBOutlet private var airmodeView: UIView!
    @IBOutlet private var celluralView: UIView!
    @IBOutlet private var wifiView: UIView!
    @IBOutlet private var bluetoothView: UIView!
    @IBOutlet private var airdropView: UIView!
    @IBOutlet private var hotspotView: UIView!

    var cellViews = [CellView]()
    private var cellView: CellView!

    private var settingsBluetoothView: BluetoothView!

    var animator = UIViewPropertyAnimator()
    let animateViewTime = 0.25
    let animateTapTime = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockView.backgroundColor = .darkGray
        
        add(.typeAirmode, toView: airmodeView)
        add(.typeCellular, toView: celluralView)
        add(.typeWiFi, toView: wifiView)
        add(.typeBluetooth, toView: bluetoothView)
        add(.typeAirdrop, toView: airdropView)
        add(.typeHotspot, toView: hotspotView)

        let tapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapPress))
        view.addGestureRecognizer(tapPressRecognizer)

        let longPressRecognizerBlock = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressBlock))
        longPressRecognizerBlock.minimumPressDuration = 0.2
        longPressRecognizerBlock.delaysTouchesBegan = true
        longPressRecognizerBlock.delegate = self
        blockView.addGestureRecognizer(longPressRecognizerBlock)
        
        let longPressRecognizerBluetooth = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressBluetooth))
        longPressRecognizerBluetooth.minimumPressDuration = 0.2
        longPressRecognizerBluetooth.delaysTouchesBegan = true
        longPressRecognizerBluetooth.delegate = self
        bluetoothButton().addGestureRecognizer(longPressRecognizerBluetooth)

        animateBlockView(isFull: false, animated: false)
    }
    
    func add(_ cellType: CellType, toView: UIView) {
        cellView = UINib(nibName: "CellView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CellView?
        cellView.set(cellType: cellType)
        cellView.frame = toView.bounds
        cellView.labelsView.alpha = 0
        toView.addSubview(cellView)
        cellViews.append(cellView)
    }
        
    func bluetoothButton() -> UIButton {
        let cellView = cellViews.first(where: { $0.cellType == .typeBluetooth })
        return cellView!.button
    }

    // MARK: - UIGestureRecognizer Methods
    @objc func handleTapPress(gestureReconizer: UITapGestureRecognizer) {
        if settingsBluetoothView != nil {
            hideView(settingsBluetoothView)
            showView(blockView)
        } else {
            animateBlockView(isFull: false)
        }
    }

    @objc func handleLongPressBluetooth(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            UIView.animate(withDuration: animateTapTime) {
                self.bluetoothButton().transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            } completion: { [self] complete in
                bluetoothButton().transform = CGAffineTransform.identity
                settingsBluetoothView = UINib(nibName: "BluetoothView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BluetoothView?
                settingsBluetoothView.isUserInteractionEnabled = true
                settingsBluetoothView.center = view.center
                settingsBluetoothView.alpha = 0
                view.addSubview(settingsBluetoothView)
                hideView(blockView)
                showView(settingsBluetoothView)
            }
        }
    }
    
    @objc func handleLongPressBlock(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            animator = UIViewPropertyAnimator(duration: animateTapTime, curve: .easeOut){
                self.blockView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }
            animator.addCompletion { position in
                UIView.animate(withDuration: self.animateViewTime, animations: {
                    self.blockView.transform = CGAffineTransform.identity
                })
                self.animateBlockView(isFull: true)
            }
            animator.startAnimation()
        }
        if gestureReconizer.state == .ended {
            animator.stopAnimation(true)
            UIView.animate(withDuration: animateTapTime) {
                self.blockView.transform = CGAffineTransform.identity
            }
            
//            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.impactOccurred()
        }
    }

    // MARK: - Animate
    func showView(_ view: UIView!) {
        view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        UIView.animate(withDuration: animateViewTime) {
            view.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
            view.alpha = 1
        } completion: { complete in
            UIView.animate(withDuration: self.animateViewTime) {
                view.transform = CGAffineTransform.identity
            }
        }
    }
    
    func hideView(_ view: UIView!) {
        UIView.animate(withDuration: self.animateViewTime) {
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
            view.alpha = 0
        } completion: { [self] complete in
            if view == settingsBluetoothView {
                settingsBluetoothView.removeFromSuperview()
                settingsBluetoothView = nil
            }
        }
    }

    func animateBlockView(isFull: Bool, animated: Bool = true) {
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
        UIView.animate(withDuration: animated ? animateViewTime : 0) { [self] in
            blockView.viewSet(width: blockWidth)
            blockView.viewSet(height: blockHeight)
            if isFull {
                blockView.center = view.center
            }
            
            airmodeView.viewSet(x: 0)
            airmodeView.viewSet(y: 0)
            airmodeView.viewSet(width: cellWidth)
            airmodeView.viewSet(height: cellHeight)
            
            celluralView.viewSet(x: cellWidth)
            celluralView.viewSet(y: 0)
            celluralView.viewSet(width: cellWidth)
            celluralView.viewSet(height: cellHeight)

            wifiView.viewSet(x: 0)
            wifiView.viewSet(y: cellWidth)
            wifiView.viewSet(width: cellWidth)
            wifiView.viewSet(height: cellHeight)

            bluetoothView.viewSet(x: cellWidth)
            bluetoothView.viewSet(y: cellWidth)
            bluetoothView.viewSet(width: cellWidth)
            bluetoothView.viewSet(height: cellHeight)
            
            airdropView.alpha = isFull ? 1 : 0
            hotspotView.alpha = isFull ? 1 : 0
            
            for cellView in cellViews {
                cellView.labelsView.alpha = isFull ? 1 : 0
            }
        }
    }
}
