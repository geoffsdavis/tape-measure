//
//  Comparable+Additions.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/8/22.
//

import Foundation


extension Comparable {

    func clamped(min: Self, max: Self)  ->  Self {
        var value = self
        if value < min { value = min }
        if value > max { value = max }
        return value
    }
    
}
