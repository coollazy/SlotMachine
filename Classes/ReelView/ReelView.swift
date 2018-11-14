//
//  ReelView.swift
//  Slot
//
//  Created by Ven on 2018/11/2.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class ReelView: UIView {
    
    private let contentView = UIView()
    
    let viewModel = ReelViewModel()
    private var pool = ReelRowViewPool()
    
    private var currentRowView = [ReelRowView]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        contentView.frame = bounds
        contentView.backgroundColor = .clear
        addSubview(contentView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        contentView.frame = bounds
        contentView.backgroundColor = .clear
        addSubview(contentView)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            prepare()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewModel.generateRowPositions()
    }
    
    func run(duration: TimeInterval = 5) {
        guard viewModel.isRunning == false else {
            return
        }
        viewModel.isRunning = true
        
        viewModel.randomItems()
        
        // let current row view move to bottom
        for (i, view) in currentRowView.enumerated() {
            moveView(view,
                     duration: viewModel.spinDuration * Double(i + 1) / Double(viewModel.numberOfVisibleRows + 1),
                     from: view.frame.origin,
                     to: CGPoint(x: 0, y: viewModel.rowSize.height * CGFloat(viewModel.numberOfVisibleRows)))
        }
        currentRowView.removeAll()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(rowViewAnimation), object: nil)
        rowViewAnimation()
        
        perform(#selector(stop), with: nil, afterDelay: duration)
    }
    
    func resetStop(duration: TimeInterval = 0) {
        guard viewModel.isRunning == true else {
            return
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stop), object: nil)
        perform(#selector(stop), with: nil, afterDelay: duration)
    }
    
    private func prepare() {
        pool.setCapacity(viewModel.numberOfVisibleRows + 2)
        
        guard viewModel.numberOfVisibleRows < viewModel.items.count else {
            print("[ERROR] items count should greater than number of ")
            return
        }
        
        for i in 0 ..< viewModel.rowPositions.count {
            let item = viewModel.items[i]
            let view = pool.dequeueReuseableView()
            view.frame = CGRect(x: 0, y: viewModel.rowPositions[i], width: viewModel.rowSize.width, height: viewModel.rowSize.height)
            view.setItem(item)
            contentView.addSubview(view)
            currentRowView.append(view)
        }
    }
    
    private func moveView(_ view:UIView, duration: TimeInterval, from: CGPoint, to: CGPoint, completion: ((Bool) -> Void)? = nil) {
        view.frame = CGRect(x: from.x, y: from.y, width: viewModel.rowSize.width, height: viewModel.rowSize.height)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            view.frame = CGRect(x: to.x, y: to.y, width: weakSelf.viewModel.rowSize.width, height: weakSelf.viewModel.rowSize.height)
            }, completion: completion)
    }
    
    @discardableResult private func viewWithAnimation(duration: TimeInterval, from: CGPoint, to: CGPoint, completion: ((Bool) -> Void)? = nil) -> ReelRowView {
        let item = viewModel.items[viewModel.autoIncreaseIndex()]
        let view = pool.dequeueReuseableView()
        view.setItem(item)
        contentView.addSubview(view)
        moveView(view, duration: duration, from: from, to: to, completion: completion)
        return view
    }
    
    @objc private func rowViewAnimation() {
        viewWithAnimation(duration: viewModel.spinDuration, from: CGPoint(x: 0, y: -viewModel.rowSize.height), to: CGPoint(x: 0, y: viewModel.rowSize.height * CGFloat(viewModel.numberOfVisibleRows)))
        perform(#selector(rowViewAnimation), with: nil, afterDelay: viewModel.spinDuration / Double(viewModel.numberOfVisibleRows + 1))
    }
    
    @objc private func stop(duration: TimeInterval = 0) {
        guard viewModel.isRunning == true else {
            return
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(rowViewAnimation), object: nil)
        
        perform(#selector(stopLastIndex), with: viewModel.numberOfVisibleRows as NSNumber, afterDelay: duration)
    }
    
    @objc private func stopLastIndex(lastIndex: NSNumber) {
        let view = viewWithAnimation(duration: viewModel.spinDuration * Double(truncating: lastIndex) / Double(viewModel.numberOfVisibleRows + 1),
                                     from: CGPoint(x: 0, y: -viewModel.rowSize.height),
                                     to: CGPoint(x: 0, y: viewModel.rowSize.height * CGFloat(Int(truncating: lastIndex) - 1)))
        currentRowView.append(view)
        if Int(truncating: lastIndex) > 1 {
            perform(#selector(stopLastIndex), with: (Int(truncating: lastIndex) - 1) as NSNumber, afterDelay: viewModel.spinDuration / Double(viewModel.numberOfVisibleRows + 1))
        } else {
            viewModel.isRunning = false
        }
    }
}

