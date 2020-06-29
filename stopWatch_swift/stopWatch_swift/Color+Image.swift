//
//  Color+Image.swift
//  stopWatch_swift
//
//  Created by ynfMac on 2020/6/29.
//  Copyright © 2020 ynfMac. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func createImage() -> UIImage{
    let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(self.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
    }
}
