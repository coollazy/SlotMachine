//
//  ReelRowView.swift
//  Slot
//
//  Created by Ven on 2018/11/2.
//  Copyright © 2018年 Ven. All rights reserved.
//

import UIKit

class ReelRowView: UIView {

    @IBOutlet weak var imageView: UIImageView?

    func prepareForReuse() {
        imageView?.image = nil
    }
}
