//
//  string+time.swift
//  stopWatch_swift
//
//  Created by ynfMac on 2020/6/29.
//  Copyright © 2020 ynfMac. All rights reserved.
//

import Foundation

extension Int {
    func convertToTimeFormat() ->String {
        guard self > 0 else { return "00:00.00" }
        
        return String(format: "%02ld:%02ld.%02ld",self / 100 / 60, self / 100 % 60, self % 100)
    }
}
