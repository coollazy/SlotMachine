//
//  ReelsView.swift
//  Slot
//
//  Created by TWDT037 on 2018/11/5.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class ReelsView: UIView {
    
    let viewModel = ReelsViewModel()
    
    var isRunning: Bool {
        get {
            var isRunning = false
            for reelView in viewModel.reelViews {
                if reelView.viewModel.isRunning {
                    isRunning = true
                }
            }
            return isRunning
        }
        set {}
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            prepare()
        }
    }
    
    func prepare() {
        generateRowSize()
        for (i, reelView) in viewModel.reelViews.enumerated() {
            reelView.frame = CGRect(x: reelView.viewModel.rowSize.width * CGFloat(i),
                                    y: 0,
                                    width: reelView.viewModel.rowSize.width,
                                    height: reelView.viewModel.rowSize.height * CGFloat(viewModel.rows))
            addSubview(reelView)
        }
    }
    
    func generateRowSize() {
        let width = bounds.width / CGFloat(viewModel.columns)
        let height = bounds.height / CGFloat(viewModel.rows)
        for reelView in viewModel.reelViews {
            reelView.viewModel.rowSize = CGSize(width: width, height: height)
        }
    }
    
    func run(duration: TimeInterval = 5) -> Bool {
        guard isRunning != true else {
            return false
        }
        
        var stopDuration = duration
        for reelView in viewModel.reelViews {
            
            reelView.viewModel.spinDuration = Double.random(in: viewModel.spinDuration - 0.1 ... viewModel.spinDuration + 0.1)
            
            reelView.run(duration: stopDuration)
            stopDuration = Double.random(in: stopDuration ... stopDuration + viewModel.stopDuration)
        }
        
        return true
    }
    
    func stop(duration: TimeInterval = 0) {
        var stopDuration = duration
        for reelView in viewModel.reelViews {
            reelView.resetStop(duration: stopDuration)
            stopDuration = Double.random(in: stopDuration ... stopDuration + viewModel.stopDuration)
        }
    }
}
