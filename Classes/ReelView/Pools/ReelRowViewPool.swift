//
//  ReelRowViewPool.swift
//  Slot
//
//  Created by TWDT037 on 2018/11/5.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class ReelRowViewPool: NSObject {
    var currentIndex = 0
    
    var rowViewPool = [ReelRowView]()
    
    func setCapacity(_ capacity: Int) {
        for _ in 0..<capacity {
            let rowView: ReelRowView = Bundle.main.loadNibNamed("ReelRowView", owner: self, options: nil)?.first as? ReelRowView ?? ReelRowView()
            rowViewPool.append(rowView)
        }
    }
    
    func dequeueReuseableView() -> ReelRowView {
        // Get the reuse view
        let reuseableView = rowViewPool[currentIndex]
        
        // Reset the view
        reuseableView.removeFromSuperview()
        reuseableView.prepareForReuse()
        
        // Increase the reuse index
        currentIndex += 1
        if currentIndex >= rowViewPool.count {
            currentIndex = 0
        }
        
        return reuseableView
    }
}
