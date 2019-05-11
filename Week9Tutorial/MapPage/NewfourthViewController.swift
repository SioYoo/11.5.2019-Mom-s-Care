//
//  NewfourthViewController.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 2019/4/24.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewfourthViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    var ref: DatabaseReference?
    var tableViewDataDArray:[[String:Any]] = []
    var placeId = [String]()
    
    var currentType = ""
    
    let rowDataArray = ["Hospital","Childcare","Kindergarten","Toilet","Parks"]
    let imageNames = ["stethoscope-840125_1280.jpg","young-409197_1280.jpg","colored-pencils-656178_1280.jpg","wc-265279_1280.jpg","bench-560435_1280.jpg"]
    
    var progressHUD:ProgressHUD?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Locations"
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label:UILabel = cell.viewWithTag(100) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(101) as! UIImageView
        
        label.text = self.rowDataArray[indexPath.row]
        imageView.image = UIImage(named: self.imageNames[indexPath.row])
        
        cell.layer.borderWidth = CGFloat(10)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        weak var weakSelf = self
        let alertvc = UIAlertController.init(title: "Please Entre a Postcode", message: nil, preferredStyle: .alert)
        let alertAction0 = UIAlertAction.init(title: "Confirm", style: .default) { (action) in
            
            weakSelf?.searchLoaction(alertvc.textFields![0].text!, indexPath)
            weakSelf?.currentType = (weakSelf?.rowDataArray[indexPath.row])!
            
        }
        let alertAction1 = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            //no code
        }
        alertvc.addAction(alertAction0)
        alertvc.addAction(alertAction1)
        alertvc.addTextField(configurationHandler: nil)
        self.present(alertvc, animated: true, completion: nil)
    }
    
    func placeid(_ loactions:[String]) {
        var placeidArray:[String] = []
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "requestPlaceid_queue")
        
        weak var weakSelf = self
        self.progressHUD = ProgressHUD().show()
        for loaction:String in loactions {
            workingGroup.enter()
            workingQueue.async {
                let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(loaction)&radius=100&type=\(self.currentType)&keyword=\(self.currentType)&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA"
                HttpServerManager().getServerData(url) { (data) in
                    
                    let dataArray:[[String:Any]] = data["results"] as! [[String : Any]]
                    for dic:[String:Any] in dataArray {
                        let placeId:String = dic["place_id"]! as! String
                        if placeidArray.contains(placeId) == false {
                            placeidArray.append(placeId)
                        }
                    }
                    //print(placeidArray)
                    self.placeId = placeidArray
                    workingGroup.leave()
                }
            }
        }
        
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async(execute: {
                if placeidArray.count == 0 {
                    weakSelf?.progressHUD?.removeFromSuperview()
                    ProgressHUD().showWithContent("No Data For This Postcode")
                    return
                }
                weakSelf!.getRatings(placeidArray)
            })
        }
        //        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA"
        //        HttpServerManager().getServerData(url) { (data) in
        //            let dataArray:[[String:Any]] = data["results"] as! [[String : Any]]
        //            for dic:[String:Any] in dataArray {
        //                placeidArray.append(dic["place_id"]! as! String)
        //            }
        //            self.getRatings(placeidArray)
        //        }
    }
    
    func getRatings(_ placeidArray:[String]) {
        
        self.tableViewDataDArray.removeAll()
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        weak var weakself = self
        for placeid:String in placeidArray {
            workingGroup.enter()
            workingQueue.async {
                let url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeid)&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA"
                HttpServerManager().getServerData(url) { (data) in
                    
                    var dic:[String:Any] = data["result"] as! [String : Any]
                    if let _:NSNumber = dic["rating"] as? NSNumber {
                        //print(dic["rating"]!)
                    }else {
                        dic["rating"] = NSNumber(0)
                    }
                    weakself?.tableViewDataDArray.append(dic)
                    workingGroup.leave()
                }
            }
        }
        
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async(execute: {
                weakself?.progressHUD?.removeFromSuperview()
                if weakself?.tableViewDataDArray.count == 0 {
                    ProgressHUD().showWithContent("No Rating Data For this Postcode")
                    return
                }
            })
            weakself?.bubble_SortArr(array: &weakself!.tableViewDataDArray)
        }
    }
    
    //排序
    func bubble_SortArr(array :inout[[String:Any]]) {
        
        for i in 0..<array.count - 1{
            for j in 0..<array.count - i - 1{
                
                let dic:[String:Any] = array[j]
                let rating:Float = (dic["rating"] as! NSNumber).floatValue
                
                let dic1:[String:Any] = array[j+1]
                let rating1:Float = (dic1["rating"] as! NSNumber).floatValue
                
                if rating < rating1{
                    array.swapAt(j, j+1)
                }
            }
        }
        weak var weakself = self
        DispatchQueue.main.async {
            let vc:RatingListViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingList") as! RatingListViewController
            vc.dataArray = weakself?.tableViewDataDArray
            weakself?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func searchLoaction(_ postCode:String, _ indexPath:IndexPath) {
        var locationArray:[String] = []
        
        for dic:[String:Any] in self.getJson(self.rowDataArray[indexPath.row]) {
            if "\(dic["postcode"]!)" == postCode {
                locationArray.append("\(String(describing: dic["lat"]!)),\(String(describing: dic["long"]!))")
            }
        }
        if locationArray.count == 0 {
            ProgressHUD().showWithContent("Sorry, No Records")
            return
        }
        self.placeid(locationArray)
    }
    
    func getJson(_ jsonName:String) ->[[String:Any]] {
        let path = Bundle.main.path(forResource: jsonName, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! [[String:Any]]
            return jsonArr
        } catch let error as Error? {
            print("An Error Occur",error as Any)
        }
        return [[:]]
    }
    
}
