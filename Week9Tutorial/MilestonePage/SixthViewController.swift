//
//  ViewController.swift
//  MonthProject
//
//  Created by Daniel Dz 24 on 2019/4/23.
//  Copyright © 2019 Daniel Dz 24. All rights reserved.
//

import UIKit
import LocalAuthentication

class SixthViewController: UIViewController {
    
    var view1 = UIView()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configBaseView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        view1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view1.backgroundColor = .white
        self.view.addSubview(view1)
        authenticationWithTouchID()
    }
    
    var dataArray = [
        ["title":"0-3 Months","open":"0","detail":[
            ["title":"Checklist","open":"0","detail":[
                ["title":"While lying on their tummy Pushes up on arms","type":"0","image":"Physical0-3.png"],
                ["title":"While lying on their tummy Lifts and head up","type":"0","image":"Physical0-3.png"],
                ["title":"Warning: Difficulty lifting head","type":"0","image":"Warning0-3(1).png"],
                ["title":"Warning: Keeps hands fisted","type":"0","image":"Warning0-3(2).png"]
                ]]
            ]],
        ["title":"3-6 Months","open":"0","detail":[
            ["title":"Checklist","open":"0","detail":[
                ["title":"Uses hands to support self while sitting","type":"0","image":"Physical3-6.png"],
                ["title":"Rolls from back to tummy and tummy to back","type":"0","image":"Physical3-6.png"],
                ["title":"accepts entire weight with legs","type":"0","image":"Physical3-6.png"],
                ["title":"Warning:Rounded back","type":"0","image":"Warning3-6(1)"],
                ["title":"Warning: Difficult to bring arms forward","type":"0","image":"Warning3-6(2)"]
                ]]
            ]],
        ["title":"6-9 Months","open":"0","detail":[
            ["title":"Checklist","open":"0","detail":[
                ["title":"Sits and reaches for toys without falling","type":"0","image":"Physical6-9.png"],
                ["title":"Moves from tummy or back into sitting","type":"0","image":"Physical6-9.png"],
                ["title":"Starts to move with alternate leg arm movement","type":"0","image":"Physical6-9.png"],
                ["title":"Keeps hands fisted and lacks arm movement","type":"0","image":"Physical6-9.png"],
                ["title":"Warning: Uses one hand predominately","type":"0","image":"Warning6-9(1)"],
                ["title":"Warning: Poor use of arms in sitting","type":"0","image":"Warning6-9(1)"],
                ["title":"Warning: Difficulty crawling","type":"0","image":"Warning6-9(2)"],
                ["title":"Warning: Inability to straighten back","type":"0","image":"Warning6-9(3)"],
                ["title":"Warning: Cannot take weight on legs","type":"0","image":"Warning6-9(3)"]
                
                ]]
            ]],
        ["title":"9-12 Months","open":"0","detail":[
            ["title":"Checklist","open":"0","detail":[
                ["title":"Pulls to stand and cruises along furniture","type":"0","image":"Physical9-12.png"],
                ["title":"Stands alone and takes independent steps","type":"0","image":"Physica9-12.png"],
                ["title":"Warning: Sits with weight to one side","type":"0","image":"Warning9-12(2)"],
                ["title":"Warning: Only use arm to pull up to standing","type":"0","image":"Warning9-12(1)"],
                ["title":"Warning: Needs to use hand to maintain sitting","type":"0","image":"Warning9-12(2)"]
                ]]
            ]],
        ["title":"12-15 Months","open":"0","detail":[
            ["title":"Checklist","open":"0","detail":[
                ["title":"Walks independently and seldom falls","type":"0","image":"Physical12-15.png"],
                ["title":"Squats to pick up toy","type":"0","image":"Physical12-15.png"],
                ["title":"Warning: Unable to take steps","type":"0","image":"Warning12-15"],
                ["title":"Warning: Walks on toes","type":"0","image":"Warning12-15"],
                ["title":"Warning: Poor standing balance","type":"0","image":"Warning12-15"]
                
                ]]
            ]]
    ]
    
    
    
    fileprivate func configBaseView() {
        
        self.navigationItem.title = "Track Your Baby's Growth"
        self.view.backgroundColor = .white
        self.mainTableView.backgroundColor = .white
        self.mainTableView.register(MileMonthListCell.classForCoder(), forCellReuseIdentifier: "MileMonthListCell")
        self.mainTableView.register(MileFirstListCell.classForCoder(), forCellReuseIdentifier: "MileFirstListCell")
        self.mainTableView.register(MileSecondListCell.classForCoder(), forCellReuseIdentifier: "MileSecondListCell")
        
        self.mainTableView.separatorStyle = .none
        //ios11 防止跳动
        self.mainTableView.estimatedRowHeight = 0
        self.mainTableView.estimatedSectionFooterHeight = 0
        self.mainTableView.estimatedSectionHeaderHeight = 0
        
    }
    
    
}

extension SixthViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let dic = dataArray[section - 1]
            var rowNumber = 1
            if let open = dic["open"] {
                if open is String {
                    let changeOpen = open as? String
                    if changeOpen == "1" {
                        //展开
                        let firstAry = dic["detail"] as? Array<Dictionary<String,Any>>
                        rowNumber = rowNumber + firstAry!.count
                        for firstDic in firstAry! {
                            if let firstOpen = firstDic["open"] {
                                let changeFirstOpen = firstOpen as? String
                                if changeFirstOpen == "1" {
                                    let secondAry = firstDic["detail"] as? Array<Dictionary<String,Any>>
                                    rowNumber = rowNumber + secondAry!.count
                                }
                            }
                        }
                    }
                }
            }
            return rowNumber
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MileMonthListCell",
                                                     for: indexPath) as! MileMonthListCell
            
            let title = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.frame.height))
            title.text = "Tap and Check Your Baby's Growth"
            title.center.x = self.view.center.x
            title.textAlignment = .center
            title.font = UIFont.boldSystemFont(ofSize: 14)
            cell.addSubview(title)
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MileMonthListCell",
                                                         for: indexPath) as! MileMonthListCell
                let dic = dataArray[indexPath.section - 1]
                let title = dic["title"] as? String
                let open = dic["open"] as? String
                cell.cellModel(title: title ?? "", detialOpen: true,isOpen: open == "1")
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MileFirstListCell",
                                                         for: indexPath) as! MileFirstListCell
                let dic = dataArray[indexPath.section - 1]
                if let open = dic["open"] {
                    if open is String {
                        let changeOpen = open as? String
                        if changeOpen == "1" {
                            //展开
                            let firstAry = dic["detail"] as? Array<Dictionary<String,Any>>
                            let firstDic = firstAry?.first
                            let title = firstDic!["title"] as? String
                            let open = firstDic!["open"] as? String
                            cell.cellModel(title: title ?? "", detialOpen: true,isOpen:open == "1" )
                        }
                    }
                }
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MileSecondListCell",
                                                         for: indexPath) as! MileSecondListCell
                let dic = dataArray[indexPath.section - 1]
                if let open = dic["open"] {
                    if open is String {
                        let changeOpen = open as? String
                        if changeOpen == "1" {
                            //展开
                            let firstAry = dic["detail"] as? Array<Dictionary<String,Any>>
                            let firstDic = firstAry?.first
                            let sectionAry = firstDic!["detail"] as? Array<Dictionary<String,Any>>
                            let sectionDic = sectionAry![indexPath.row - 2]
                            let title = sectionDic["title"] as? String
                            let type = sectionDic["type"] as? String
                            if type == "1" {
                                cell.backgroundColor = .green
                            } else {
                                cell.backgroundColor = .white
                            }
                            cell.cellModel(title: title ?? "")
                        }
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        
        
        
    }
    
}
extension SixthViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //        view.backgroundColor = STBackViewBackViewColor
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            //修改参数
            configChangeDataWith(indexPath: indexPath)
        }
    }
    
}

extension SixthViewController {
    fileprivate func configChangeDataWith(indexPath: IndexPath) {
        var changeDic = dataArray[indexPath.section - 1]
        if indexPath.row == 0 {
            if let open = changeDic["open"] {
                if open is String {
                    let changeOpen = open as? String
                    if changeOpen == "0" {
                        changeDic["open"] = "1"
                    } else if changeOpen == "1" {
                        changeDic["open"] = "0"
                    }
                }
            }
            dataArray[indexPath.section - 1] = changeDic
            self.mainTableView.reloadSections([indexPath.section], with: .none)
        } else if indexPath.row == 1 {
            
            var firstAry = changeDic["detail"] as? Array<Dictionary<String,Any>>
            var firstDic = firstAry![0]
            
            if let open = firstDic["open"] {
                if open is String {
                    let changeOpen = open as? String
                    if changeOpen == "0" {
                        firstDic["open"] = "1"
                    } else if changeOpen == "1" {
                        firstDic["open"] = "0"
                    }
                }
            }
            firstAry![0] = firstDic
            changeDic["detail"] = firstAry
            dataArray[indexPath.section - 1] = changeDic
            self.mainTableView.reloadSections([indexPath.section], with: .none)
        } else {
            var firstAry = changeDic["detail"] as? Array<Dictionary<String,Any>>
            var firstDic = firstAry![0]
            var sectionAry = firstDic["detail"] as? Array<Dictionary<String,Any>>
            var sectionDic = sectionAry![indexPath.row - 2]
            var type = sectionDic["type"] as? String
            let image = sectionDic["image"] as? String

            //显示弹框 --
            let view = MonthAlertView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            view.configDataWithImage(image ?? "")
            view.enterClickBtnAction = {[unowned self] in
                type = "1"
                sectionDic["type"] = type
                sectionAry![indexPath.row - 2] = sectionDic
                firstDic["detail"] = sectionAry
                firstAry![0] = firstDic
                changeDic["detail"] = firstAry
                self.dataArray[indexPath.section - 1] = changeDic
                self.mainTableView.reloadSections([indexPath.section], with: .none)
            }
            view.closeImageBlock = {[unowned self] in
                type = "0"
                sectionDic["type"] = type
                sectionAry![indexPath.row - 2] = sectionDic
                firstDic["detail"] = sectionAry
                firstAry![0] = firstDic
                changeDic["detail"] = firstAry
                self.dataArray[indexPath.section - 1] = changeDic
                self.mainTableView.reloadSections([indexPath.section], with: .none)
            }
            UIApplication.shared.keyWindow?.addSubview(view)
        }
    }
    
}

extension SixthViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async {
                        self.view1.removeFromSuperview()
                    }
                    
                    
                } else {
                    
                    
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))

        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            //self.navigationController?.popToRootViewController(animated: true)
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}


