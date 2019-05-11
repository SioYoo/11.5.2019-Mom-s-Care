//
//  DemoCell.swift
//  FolderDemo
//
//  Created by Ziyi Deng on 6/5/19.
//  Copyright © 2019 Ziyi Deng. All rights reserved.
//

import FoldingCell
import UIKit

class DemoCell: FoldingCell {
    
    @IBOutlet weak var expandImage: UIImageView!
    
    @IBOutlet var closeNumberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var findMoreButton: UIButton!
    @IBOutlet weak var thirdLabel: UILabel!
    
    var number: Int = 0 {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension DemoCell {
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}

