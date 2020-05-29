//
//  stopWatchData.swift
//  stopWatch_swift
//
//  Created by ynfMac on 2020/5/25.
//  Copyright © 2020 ynfMac. All rights reserved.
//

import Foundation

class stopWatchData {
    var isReset:Bool = true
    var times:[Int] = []
    
    var maxTime:Int? {
        get {
            if times.count <= 2 {
                return nil;
            }
            
            var maxIndex = 1
            
            for index in 2..<times.count {
                if(times[index] > times[maxIndex]){
                    maxIndex = index
                }
            }
            return maxIndex
        }
    }
    
    var minTime:Int? {
        get {
            if times.count <= 2 {
                return nil;
            }
            
            var minIndex = 1
            
            for index in 2..<times.count {
                if(times[index] < times[minIndex]){
                    minIndex = index
                }
            }
            return minIndex
        }
    }
    
    init() {
        reset()
    }
    
    func reset() {
        isReset = true
        times = []
    }
    
    
    func timing(time:Int) {
        times[0] = time
    }
    
    func beginingNewTime(comletion:(() ->())? = nil){
        times.insert(0, at: 0)
        isReset = false
        
        if let comletion = comletion {
            comletion()
        }
    }
    
    
}
