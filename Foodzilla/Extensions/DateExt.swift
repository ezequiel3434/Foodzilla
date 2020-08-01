//
//  DateExt.swift
//  Foodzilla
//
//  Created by Ezequiel Parada Beltran on 01/08/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import Foundation

extension Date {
    
    func isLessThan(_ date: Date) -> Bool{
        if self.timeIntervalSince(date) < date.timeIntervalSinceNow {
            return true
        } else {
            return false
        }
    }
}
