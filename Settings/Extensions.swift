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
