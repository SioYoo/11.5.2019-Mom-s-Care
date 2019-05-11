//
//  ProgressHUD.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 2019/4/28.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit

class ProgressHUD: UIView {

    @IBOutlet weak var hud: UIActivityIndicatorView!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var prompBox: ProgressHUD? = nil
    
    func show() -> ProgressHUD {
        let HUD = Bundle.main.loadNibNamed("ProgressHUD", owner: nil, options: nil)?.first as? ProgressHUD
        HUD?.contentLabel.isHidden = true
        HUD?.hud.isHidden = false
        HUD?.layer.cornerRadius = 5
        HUD?.layer.masksToBounds = true
        let window:UIWindow =  ((UIApplication.shared.delegate?.window)!)!
        window.addSubview(HUD!)
        HUD?.center = window.center
        HUD?.hud.startAnimating()
        return HUD!
    }
    
    func showWithContent(_ text:String) {
        let HUD = Bundle.main.loadNibNamed("ProgressHUD", owner: nil, options: nil)?.first as? ProgressHUD
        HUD?.contentLabel.isHidden = false
        HUD?.hud.isHidden = true
        HUD?.contentLabel.text = text
        HUD?.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        HUD?.layer.cornerRadius = 5
        HUD?.layer.masksToBounds = true
        let window:UIWindow =  ((UIApplication.shared.delegate?.window)!)!
        window.addSubview(HUD!)
        HUD?.center = window.center
        
        weak var weakHUD = HUD
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            weakHUD?.removeFromSuperview()
        })
    }
    
    func dismiss() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf!.removeFromSuperview()
        }
    }

}
