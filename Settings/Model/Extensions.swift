//
//  Extensions.swift
//  Settings
//
//  Created by Sergey Vishnyov on 20.01.22.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib <T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}

extension UIView {
    var viewWidth: CGFloat {
        return frame.size.width
    }
    var viewHeight: CGFloat {
        return frame.size.height
    }
    var viewX: CGFloat {
        return frame.origin.x
    }
    var viewY: CGFloat {
        return frame.origin.y
    }
    var viewWidth_X: CGFloat {
        return frame.origin.x + frame.size.width
    }
    var viewHeight_Y: CGFloat {
        return frame.origin.y + frame.size.height
    }
    func viewSet(x: CGFloat) {
        frame = CGRect(x: x, y: viewY, width: viewWidth, height: viewHeight)
    }
    func viewSet(y: CGFloat) {
        frame = CGRect(x: viewX, y: y, width: viewWidth, height: viewHeight)
    }
    func viewSet(width: CGFloat) {
        frame = CGRect(x: viewX, y: viewY, width: width, height: viewHeight)
    }
    func viewSet(height: CGFloat) {
        frame = CGRect(x: viewX, y: viewY, width: viewWidth, height: height)
    }
}

extension UIImage {
    func imageWithColor(_ color: UIColor) -> UIImage { // For iOS <= 12
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        context?.clip(to: rect, mask: cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension UIButton {
    func setTintColor(_ color: UIColor) { // For iOS <= 12
        setImage(imageView?.image?.imageWithColor(color), for: .normal)
    }
}
