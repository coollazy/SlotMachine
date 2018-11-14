//
//  UserData.swift
//  Slot
//
//  Created by TWDT037 on 2018/11/5.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class UserData {
    static let shared = UserData()
    
    var balance: Float?
}

extension Float {
    func decimalString() -> String {
        let formatter = NumberFormatter()
        formatter.positiveFormat = ",###.00"
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
