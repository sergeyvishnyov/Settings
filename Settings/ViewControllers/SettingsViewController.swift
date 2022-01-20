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
    let animateTime = 0.25

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
        tapPressRecognizer.delaysTouchesBegan = false
        view.addGestureRecognizer(tapPressRecognizer)

        let longPressRecognizerBlock = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressBlock))
        longPressRecognizerBlock.minimumPressDuration = 0.2
        longPressRecognizerBlock.delaysTouchesBegan = true
        blockView.addGestureRecognizer(longPressRecognizerBlock)
        
        let longPressRecognizerBluetooth = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressBluetooth))
        longPressRecognizerBluetooth.minimumPressDuration = 0.2
        longPressRecognizerBluetooth.delaysTouchesBegan = true
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
            let point = gestureReconizer.location(in: view)
            if !settingsBluetoothView.frame.contains(point) {
                hideView(settingsBluetoothView)
                showView(blockView)
            }
        } else {
            animateBlockView(isFull: false)
        }
    }

    @objc func handleLongPressBluetooth(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            UIView.animate(withDuration: animateTime) {
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
                haptic()
            }
        }
    }
    
    @objc func handleLongPressBlock(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            animator = UIViewPropertyAnimator(duration: animateTime, curve: .easeOut){
                self.blockView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }
            animator.addCompletion { [self] position in
                UIView.animate(withDuration: self.animateTime, animations: {
                    self.blockView.transform = CGAffineTransform.identity
                })
                animateBlockView(isFull: true)
                haptic()
            }
            animator.startAnimation()
        }
        if gestureReconizer.state == .ended {
            animator.stopAnimation(true)
            UIView.animate(withDuration: animateTime) {
                self.blockView.transform = CGAffineTransform.identity
            }
        }
    }
    
    // MARK: - Animate
    func showView(_ view: UIView!) {
        view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        UIView.animate(withDuration: animateTime) {
            view.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
            view.alpha = 1
        } completion: { complete in
            UIView.animate(withDuration: self.animateTime) {
                view.transform = CGAffineTransform.identity
            }
        }
    }
    
    func hideView(_ view: UIView!) {
        UIView.animate(withDuration: animateTime) {
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
        var cellWidth = 80.0
        var cellHeight = 80.0
        var blockWidth = cellWidth * 2
        var blockHeight = cellHeight * 2
        if isFull {
            blockWidth = blockWidth * 2
            blockHeight = blockHeight * 3
            cellWidth = cellWidth * 2
            cellHeight = cellHeight * 2
        }
        UIView.animate(withDuration: animated ? animateTime : 0) { [self] in
            blockView.viewSet(width: blockWidth)
            blockView.viewSet(height: blockHeight)
            if isFull {
                blockView.center = view.center
            }
            
            viewSet(airmodeView, x: 0, y: 0, width: cellWidth, height: cellHeight)
            viewSet(celluralView, x: cellWidth, y: 0, width: cellWidth, height: cellHeight)
            viewSet(wifiView, x: 0, y: cellWidth, width: cellWidth, height: cellHeight)
            viewSet(bluetoothView, x: cellWidth, y: cellWidth, width: cellWidth, height: cellHeight)

            airdropView.alpha = isFull ? 1 : 0
            hotspotView.alpha = isFull ? 1 : 0
            
            for cellView in cellViews {
                cellView.labelsView.alpha = isFull ? 1 : 0
            }
        }
    }
    
    func viewSet(_ view: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        view.viewSet(x: x)
        view.viewSet(y: y)
        view.viewSet(width: width)
        view.viewSet(height: height)
    }
    
    func haptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
