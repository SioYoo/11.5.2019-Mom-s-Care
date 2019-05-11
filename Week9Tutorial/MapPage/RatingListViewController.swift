//
//  RatingListViewController.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 2019/4/24.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit

class RatingListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataArray:[[String:Any]]?
    
    @IBOutlet weak var tabelview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabelview.delegate = self
        self.tabelview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray!.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let name:UILabel = cell.viewWithTag(100) as! UILabel
        let rating:UILabel = cell.viewWithTag(101) as! UILabel
        
        
        if indexPath.row != 0 {
            let dic:[String:Any] = self.dataArray![indexPath.row - 1]
            name.text = dic["name"] as? String
            rating.text = (dic["rating"] as? NSNumber)?.stringValue
            cell.backgroundColor = .white
            
        }
        else {
            name.text = NSLocalizedString("Name", comment: "")
            rating.text = NSLocalizedString("Rate", comment: "")
            name.font = UIFont.boldSystemFont(ofSize: 16)
            rating.font = UIFont.boldSystemFont(ofSize: 16)
            cell.backgroundColor = .white
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row != 0 {
            let vc:MapViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Map") as! MapViewController
            vc.dic = self.dataArray![indexPath.row - 1]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

