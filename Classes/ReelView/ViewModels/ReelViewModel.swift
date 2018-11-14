//
//  ReelViewModel.swift
//  Slot
//
//  Created by Ven on 2018/11/2.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class ReelViewModel {
    var rowSize: CGSize = CGSize(width: 89, height: 75) {
        didSet {
            generateRowPositions()
        }
    }
    
    var numberOfVisibleRows: Int = 3 {
        didSet {
            generateRowPositions()
        }
    }
    
    var spinDuration: TimeInterval = 0.3
    var totalItemsSize = 100
    private(set) var rowPositions = [CGFloat]()
    private(set) var currentIndex = 0
    var isRunning = false
    
    var items = [ReelRowItem]()
    
    init() {
        randomItems()
        generateRowPositions()
    }
    
    func generateRowPositions() {
        rowPositions.removeAll()
        
        for i in 0 ..< numberOfVisibleRows {
            rowPositions.append(rowSize.height * CGFloat(numberOfVisibleRows - i - 1))
        }
    }
    
    func randomItems() {
        for i in 0...totalItemsSize {
            let item = ReelRowItem()
            item.name = "item\(i)"
            item.image = UIImage(named: "symbol\(Int.random(in: 1...10))")
            items.append(item)
        }
    }
    
    func autoIncreaseIndex() -> Int {
        let currentIndex = self.currentIndex
        self.currentIndex += 1
        if self.currentIndex >= self.totalItemsSize {
            self.currentIndex = 0
        }
        return currentIndex
    }
}
 
