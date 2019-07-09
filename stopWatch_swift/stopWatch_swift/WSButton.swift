//
//  WSButton.swift
//  stopWatch_swift
//
//  Created by ynfMac on 2019/7/9.
//  Copyright © 2019 ynfMac. All rights reserved.
//

import UIKit

class WSButton: UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if super.point(inside: point, with: event) {
            let path = UIBezierPath.init(ovalIn: self.bounds)
            return path.contains(point)
        }
        
        return false
    }
    
    override var isHighlighted: Bool {
        
        set {
            
        }
        get {
            return false
        }
    }
    

}
