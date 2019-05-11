//
//  MileSecondViewCell.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 28/4/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit

class MileSecondListCell: UITableViewCell {

    fileprivate lazy var titleNameLabel:UILabel = {
        var titleNameLabel:UILabel = UILabel()
        titleNameLabel.textColor = .black
        titleNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleNameLabel.textAlignment = .left
        titleNameLabel.numberOfLines = 1
        titleNameLabel.frame = CGRect(x: 45.0, y: 0.0, width: UIScreen.main.bounds.width - 45.0, height: 50.0)
        return titleNameLabel
    }()
    fileprivate lazy var intervalBackView:UIView = {
        var intervalBackView = UIView()
        intervalBackView.backgroundColor = .gray
        intervalBackView.frame = CGRect(x: 45.0, y: 49.5, width: UIScreen.main.bounds.width - 45.0, height: 0.5)
        return intervalBackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCreatUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configCreatUI() {
        contentView.addSubview(titleNameLabel)
        contentView.addSubview(intervalBackView)
        
    }
    func cellModel(title: String) {
        titleNameLabel.text = title
    }
    
}
