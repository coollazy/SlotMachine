//
//  ReelsViewModel.swift
//  Slot
//
//  Created by TWDT037 on 2018/11/5.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class ReelsViewModel: NSObject {
    
    var spinDuration: TimeInterval = 0.5
    var stopDuration: Double = 1.2
    
    var rows = 3 {
        didSet {
           generateReelView()
        }
    }
    var columns = 5 {
        didSet {
            generateReelView()
        }
    }
    
    var reelViews = [ReelView]()
    
    override init() {
        super.init()
        generateReelView()
    }
    
    private func generateReelView() {
        for view in reelViews {
            view.removeFromSuperview()
        }
        
        reelViews.removeAll()
        
        for _ in 0 ..< columns {
            let reelView = ReelView(frame: CGRect.zero)
            reelView.viewModel.numberOfVisibleRows = rows
            reelViews.append(reelView)
        }
    }
}
