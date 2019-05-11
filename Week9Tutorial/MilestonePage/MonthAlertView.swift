//
//  MonthAlertView.swift
//  MonthProject
//
//  Created by Daniel Dz on 2019/4/26.
//  Copyright © 2019 Daniel Dz 24. All rights reserved.
//

import UIKit

class MonthAlertView: UIView {
    
    lazy var backImageView:UIImageView = {
        var backImageView = UIImageView()
        backImageView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 200) * 0.5, y: 60, width: 200, height: 200)
        //        backImageView.image = UIImage.init(named: "BGWonLose")
        return backImageView
    }()
    lazy var cancleBtn:UIButton = {
        var cancleBtn = UIButton(type: .custom)
        cancleBtn.frame = CGRect(x: (UIScreen.main.bounds.size.width - 200) * 0.5 + 20, y: 300.0, width: 40, height: 40)
        cancleBtn.setImage(UIImage(named: "X"), for: .normal)
        cancleBtn.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
        return cancleBtn
    }()
    lazy var enterBtn:UIButton = {
        var enterBtn = UIButton(type: .custom)
        enterBtn.frame = CGRect(x: (UIScreen.main.bounds.size.width - 200) * 0.5 + 140.0, y: 300.0, width: 40, height: 40)
        enterBtn.setImage(UIImage(named: "checkbox_pic"), for: .normal)
        enterBtn.addTarget(self, action: #selector(enterAction(_:)), for: .touchUpInside)
        return enterBtn
    }()
    var enterClickBtnAction:(() -> Swift.Void)?//点击事件
    var closeImageBlock:(() -> Swift.Void)?//关闭弹框
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configBaseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension MonthAlertView {
    //MARK: 初始化页面
    fileprivate func configBaseView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        backBtn.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
        self.addSubview(backBtn)
        
        self.addSubview(backImageView)
        self.addSubview(cancleBtn)
        self.addSubview(enterBtn)
    }
    //MARK: 关系弹框
    @objc private func closeView(_ sender:UIButton) {
        
        if self.closeImageBlock != nil {
            self.closeImageBlock!()
        }
        self.removeFromSuperview()
    }
    //MARK: 提交选择
    @objc private func enterAction(_ sender:UIButton) {
        
        if self.enterClickBtnAction != nil {
            self.enterClickBtnAction!()
        }
        self.removeFromSuperview()
    }
    
    func configDataWithImage(_ name:String) {
        self.backImageView.image = UIImage(named: name)
    }
}
