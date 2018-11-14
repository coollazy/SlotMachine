//
//  ViewController.swift
//  Slot
//
//  Created by Ven on 2018/11/2.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var reelsView: ReelsView?
    @IBOutlet weak var spinButton: UIButton?
    @IBOutlet weak var balanceLabel: UILabel?
    @IBOutlet weak var betAmountLabel: UILabel?
    
    let maxRunDuration: TimeInterval = 4
    let minRunDuration: TimeInterval = 1.5
    
    let betAmountDuration: Float = 5
    let maxBetAmount: Float = 100
    let minBetAmount: Float = 5
    
    let maxSpinSpeed: TimeInterval = 0.2
    let minSpinSpeed: TimeInterval = 0.4
    
    var currentRunDuration: TimeInterval = 4
    var currentBetAmount: Float = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reelsView?.viewModel.spinDuration = minSpinSpeed
        
        UserData.shared.balance = 1000
        updateBalanceLabel()
        updateBetAmountLabel()
    }
    
    private func updateBalanceLabel() {
        balanceLabel?.text = "£\(UserData.shared.balance?.decimalString() ?? "0.00")"
    }
    
    private func updateBetAmountLabel() {
        betAmountLabel?.text = "£\(currentBetAmount.decimalString())"
    }
    
    private func run() {
        if let balance = UserData.shared.balance, balance >= currentBetAmount, reelsView?.run(duration: currentRunDuration) ?? false {
            UserData.shared.balance = balance - currentBetAmount
            updateBalanceLabel()
            
            if UserData.shared.balance ?? 0 <= 0 {
                spinButton?.isEnabled = false
            }
        }
    }
    
    private func stop() {
        reelsView?.stop()
    }

    @IBAction func onSpinButtonClickHandler(_ sender: Any) {
        if reelsView?.isRunning ?? false {
            stop()
        } else {
            run()
        }
    }
    
    @IBAction func onIncreaseBetAmountButtonClickedHandler(_ sender: Any) {
        if currentBetAmount < maxBetAmount {
            currentBetAmount += betAmountDuration
            updateBetAmountLabel()
        }
    }
    
    @IBAction func onDecreaseBetAmountButtonClickedHandler(_ sender: Any) {
        if currentBetAmount > minBetAmount {
            currentBetAmount -= betAmountDuration
            updateBetAmountLabel()
        }
    }
    @IBAction func onSpinSpeedButtonClickedHandler(_ sender: Any) {
        if reelsView?.viewModel.spinDuration ?? maxSpinSpeed == maxSpinSpeed {
            reelsView?.viewModel.spinDuration = minSpinSpeed
            currentRunDuration = maxRunDuration
            (sender as? UIButton)?.isSelected = false
        } else {
            reelsView?.viewModel.spinDuration = maxSpinSpeed
            currentRunDuration = minRunDuration
            (sender as? UIButton)?.isSelected = true
        }
    }
}

