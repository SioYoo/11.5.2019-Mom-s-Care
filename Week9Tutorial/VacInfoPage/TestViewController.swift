//
//  TestViewController.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 15/4/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit

class TestViewController: UITableViewController {
    var selection: String!
    let sectionName = [NSLocalizedString("Vaccination Comparison by Country", comment: ""), NSLocalizedString("Vaccination Description", comment: "")]
    var data = [[[String]]]()
    
    override func viewDidLoad() {
        self.title = "Result"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpData()
    }
    
    func setUpData() {
        
        var vacInfo = [[String]]()
        var dataDescription = [[String]]()
        var unique = [String]()
        
        dataDescription.append([NSLocalizedString("BCG", comment: ""), NSLocalizedString("Bacille Calmette-Guérin  vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("DTaP", comment: ""), NSLocalizedString("Diphtheria, tetanus and pertussis vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("DTaPHibHepBIPV", comment: ""), NSLocalizedString("6 in 1 vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("HepA_Pediatric", comment: ""), NSLocalizedString("Hepatitis A pediatric vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("HepB_Pediatric", comment: ""), NSLocalizedString("Hepatitis B pediatric vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("HibMenC", comment: ""), NSLocalizedString("Haemophilus influenzae type b and meningitis C", comment: "")])
        dataDescription.append([NSLocalizedString("IPV", comment: ""), NSLocalizedString("Inactivated polio vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("Measles", comment: ""), NSLocalizedString("Measles vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("MMR", comment: ""), NSLocalizedString("Measles mumps rubella  vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("MMRV", comment: ""), NSLocalizedString("Measles, mumps, rubella, varicella", comment: "")])
        dataDescription.append([NSLocalizedString("MR", comment: ""), NSLocalizedString("Measles-rubella  vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("OPV", comment: ""), NSLocalizedString("Oral polio vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("Rotavirus", comment: ""), NSLocalizedString("Rotavirus vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("Vitamin A", comment: ""), NSLocalizedString("Vitamin A vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("DTwP", comment: ""), NSLocalizedString("Diptheria, tetanus and pertussis vaccines", comment: "")])
        dataDescription.append([NSLocalizedString("DTwPHibHepB", comment: ""), NSLocalizedString("5 in 1 vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("Influenza_Pediatric", comment: ""), NSLocalizedString("Influenza_Pediatric vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("JE_LiveAtd", comment: ""), NSLocalizedString("Japanese encephalitis live vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("MenA", comment: ""), NSLocalizedString("Meningococcal A vaccine", comment: "")])
        dataDescription.append([NSLocalizedString("Pneumo_conj", comment: ""), NSLocalizedString("Pneumococcal conjugate vaccine", comment: "")])
        
        
        vacInfo.append([NSLocalizedString("Australia", comment: ""), NSLocalizedString("China", comment: "")])
        if selection == NSLocalizedString("0-2 Month", comment: "") {
            vacInfo.append(["HepB_Pediatric", "HepB_Pediatric"])
            vacInfo.append(["DTaPHibHepBIPV", "BCG"])
            vacInfo.append(["Pneumo_conj", "IPV"])
            vacInfo.append(["Rotavirus", "X"])
            unique = ["BCG", "DTaPHibHepBIPV", "HepB_Pediatric", "IPV", "Pneumo_conj", "Rotavirus"]
            
        } else if selection == NSLocalizedString("2-4 Month", comment: "") {
            vacInfo.append(["DTaPHibHepBIPV", "DTaP"])
            vacInfo.append(["Pneumo_conj", "OPV"])
            vacInfo.append(["Rotavirus", "X"])
            unique = [NSLocalizedString("DTaP", comment: ""), "DTaPHibHepBIPV", "OPV", "Pneumo_conj", "Rotavirus"]
            
        } else if selection == NSLocalizedString("4-6 Month", comment: "") {
            vacInfo.append(["DTaPHibHepBIPV", "HepB_Pediatric"])
            vacInfo.append(["Influenza_Pediatric", "OPV"])
            vacInfo.append(["Pneumo_conj", "MenA"])
            vacInfo.append(["Rotavirus", "X"])
            unique = ["DTaPHibHepBIPV", "HepB_Pediatric", "Influenza_Pediatric", "MenA", "OPV", "Pneumo_conj", "Rotavirus"]
            
        } else if selection == NSLocalizedString("6-12 Month", comment: "") {
            vacInfo.append(["HepA_Pediatric", "JE_LiveAtd"])
            vacInfo.append(["HibMenC", "MenA"])
            vacInfo.append(["MMR", "MR"])
            vacInfo.append(["Pneumo_conj", "X"])
            unique = ["HepA_Pediatric", "HibMenC", "JE_LiveAtd", "MenA", "MMR", "MR", "Pneumo_conj"]
        }
        
        data.append(vacInfo)
        
        var matchList = [[String]]()
        for i in 0...unique.count - 1 {
            for n in 0...dataDescription.count - 1 {
                if unique[i] == dataDescription[n][0] {
                    matchList.append(dataDescription[n])
                }
            }
        }
        data.append(matchList)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        let label = UILabel()
        label.text = "\(sectionName[section])"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.frame = CGRect(x: 0, y: 20, width: self.tableView.frame.width, height: 15)
        label.textAlignment = .center
        
        view.addSubview(label)
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        let middle = cell.frame.width / 2
        
        let labelOne = UILabel()
        labelOne.frame = CGRect(x: 30, y: 0, width: cell.frame.width / 2, height: cell.frame.height)
        labelOne.text = data[indexPath.section][indexPath.row][0]
        labelOne.font = UIFont.systemFont(ofSize: 14)
        
        let labelTwo = UILabel()
        labelTwo.frame = CGRect(x: middle + 30, y: 0, width: cell.frame.width / 2 - 40, height: cell.frame.height)
        labelTwo.text = data[indexPath.section][indexPath.row][1]
        labelTwo.numberOfLines = 3
        labelTwo.font = UIFont.systemFont(ofSize: 14)
        
        if labelOne.text == labelTwo.text && indexPath.section == 0 && indexPath.row != 0{
            labelOne.textColor = .green
            labelTwo.textColor = .green
        }
        else if indexPath.section == 0 && indexPath.row != 0 {
            labelOne.textColor = .red
            labelTwo.textColor = .red
        }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            labelOne.font = UIFont.boldSystemFont(ofSize: 16)
            labelTwo.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        for subview in cell.contentView.subviews {
            
            subview.removeFromSuperview()
            
        }
        cell.contentView.addSubview(labelOne)
        cell.contentView.addSubview(labelTwo)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    
    
}


//class TestViewController: UIViewController, UICollectionGridViewSortDelegate {
//
//    var gridViewController: UICollectionGridViewController!
//    var selection: String!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        gridViewController = UICollectionGridViewController()
//
//        if selection == "China0-2" {
//            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
//            gridViewController.addRow(row: ["Yes","HepB_Pediatric", "HepB_Pediatric"])
//            gridViewController.addRow(row: ["No","DTaPHibHepBIPV", "BCG"])
//            gridViewController.addRow(row: ["No","Pneumo_conj", "IPV"])
//            gridViewController.addRow(row: ["No","Rotavirus", "-"])
//
//        } else if selection == "China2-4" {
//            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
//            gridViewController.addRow(row: ["No","DTaPHibHepBIPV", "DTaP"])
//            gridViewController.addRow(row: ["No","Pneumo_conj", "OPV"])
//            gridViewController.addRow(row: ["No","Rotavirus", "-"])
//        } else if selection == "China4-6" {
//            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
//            gridViewController.addRow(row: ["No","DTaPHibHepBIPV", "HepB_Pediatric"])
//            gridViewController.addRow(row: ["No","Influenza_Pediatric", "OPV"])
//            gridViewController.addRow(row: ["No","Pneumo_conj", "MenA"])
//            gridViewController.addRow(row: ["No","Rotavirus", "-"])
//        } else if selection == "China6-12" {
//            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
//            gridViewController.addRow(row: ["No","HepA_Pediatric", "JE_LiveAtd"])
//            gridViewController.addRow(row: ["No","HibMenC", "MenA"])
//            gridViewController.addRow(row: ["No","MMR", "MR"])
//            gridViewController.addRow(row: ["No","Pneumo_conj", "-"])
//
//        } else if selection == "India0-2" {
//
//        } else if selection == "India2-4" {
//
//        } else if selection == "India4-6" {
//
//        } else if selection == "India6-8" {
//
//        } else if selection == "India8-12" {
//
//        } else {
//
//        }
//        gridViewController.sortDelegate = self
//        view.addSubview(gridViewController.view)
//
//
//
//    }
//
//    override func viewDidLayoutSubviews() {
//        gridViewController.view.frame = CGRect(x:0, y:100, width:view.frame.width,
//                                               height:view.frame.height-64)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    //表格排序函数
//    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]] {
//        let sortedRows = rows.sorted { (firstRow: [Any], secondRow: [Any])
//            -> Bool in
//            let firstRowValue = firstRow[colIndex] as! String
//            let secondRowValue = secondRow[colIndex] as! String
//            if colIndex == 0 || colIndex == 1 {
//                //首例、姓名使用字典排序法
//                if asc {
//                    return firstRowValue < secondRowValue
//                }
//                return firstRowValue > secondRowValue
//            } else  {
//                //中间两列使用数字排序
//                if asc {
//                    return firstRowValue < secondRowValue
//                }
//                return firstRowValue > secondRowValue
//            }
//        }
//        return sortedRows
//    }
//}
