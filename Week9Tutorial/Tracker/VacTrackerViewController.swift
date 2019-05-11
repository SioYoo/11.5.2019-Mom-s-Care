//
//  VacTrackerViewController.swift
//  Week9Tutorial
//
//  Created by Ziyi Deng on 7/5/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit



class VacTrackerViewController: UICollectionViewController {
    
    let imageList = [UIImage(named: "vacc1"),UIImage(named: "vacc2")]
    
    var segue = ["tracker1", "tracker2"]
    
    let titleLabelText = ["Do You Know?\nDifferent countries have different vaccination schedule","Do You Know?\nHow is your surburb in vaccination awarness and facilities"]
    let subTitleLabelText = ["Compare the vaccinations of China and Australia and stay updated","Find the previous year vaccination coverage rates of the suburb to know vaccination facilities in your area"]
    
    let buttonTitle = ["Compare", "Find More"]
    
    var placeId = [String]()
    
    var currentType = "Hospital"
    
    var tableViewDataDArray:[[String:Any]] = []

    var progressHUD:ProgressHUD?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        self.collectionView.delegate = self
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "VacCell")

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VacCell", for: indexPath) as! VacTrackerViewCell
        
        cell.imageView.image = imageList[indexPath.row]
        cell.titleLabel.text = self.titleLabelText[indexPath.row]
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.center.x = cell.center.x
        
        cell.subTitleLabel.text = self.subTitleLabelText[indexPath.row]
        cell.subTitleLabel.textAlignment = .center
        cell.subTitleLabel.center.x = cell.center.x
        
        cell.button.tag = indexPath.row
        cell.button.setTitle(buttonTitle[indexPath.row], for: .normal)
        
        cell.button.addTarget(self, action: #selector(jump), for: .touchUpInside)
        return cell
    }
    
    @objc func jump(sender: UIButton) {
        performSegue(withIdentifier: segue[sender.tag], sender: "")
    }
    
    @IBAction func findHospital(_ sender: Any) {
        weak var weakSelf = self
        let alertvc = UIAlertController.init(title: "Please Entre a Postcode", message: nil, preferredStyle: .alert)
        let alertAction0 = UIAlertAction.init(title: "Confirm", style: .default) { (action) in
            
            weakSelf?.searchLoaction(alertvc.textFields![0].text!)
            weakSelf?.currentType = (weakSelf?.currentType)!
            
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
    
    //sort
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
    
    func searchLoaction(_ postCode:String) {
        var locationArray:[String] = []
        
        for dic:[String:Any] in self.getJson("Hospital") {
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
