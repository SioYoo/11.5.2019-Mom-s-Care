//
//  ThirdViewController.swift
//  mom's care
//
//  Created by Daniel Dz on 4/4/19.
//  Copyright © 2019 Daniel Dz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Charts

class ThirdViewController: UIViewController,UITextFieldDelegate  {

    @IBOutlet weak var InfoButton: UIButton!

    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBAction func covInfoBtn(_ sender: Any) {
        let a:Int? = Int(postCodeField.text ?? "0")
        
        if a != nil{
            if a! >= 3000 && a! <= 4000{
                years = ["2011-12", "2012-13", "2013-14", "2014-15", "2015-16", "2016-17"]
                lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:years)
                lineChartView.xAxis.granularity = 1
                setChart(dataPoints: years, values: dataFromFirebaseArray[postCodeField.text!]! as [Double])
            }
            else{
                let alert = UIAlertController(title: "Sorry", message: "The Postcode is Incorrect", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "Sorry", message: "The Postcode is Incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var postCodeField: UITextField!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return (newString.length <= maxLength) && (string == numberFiltered)
    }
    
    var ref: DatabaseReference?
    var dataFromFirebaseArray = [String:[Double]]()
    var years: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postCodeField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        lineChartView.noDataText = "Please input your postcode above"
        
        InfoButton.layer.cornerRadius = 4
        
//        self.percentageLabel.text = ""
        
        Auth.auth().signIn(withEmail: "localhost@theshield.com", password: "4theshield.com")
        
        ref = Database.database().reference()
        
        
        ref?.child("Coverage").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String:[Double]]
            
            self.dataFromFirebaseArray.removeAll()
            
            self.dataFromFirebaseArray = value!
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        postCodeField.layer.masksToBounds = true
        postCodeField.layer.cornerRadius = 12.0
        postCodeField.layer.borderWidth = 2.0
        postCodeField.layer.borderColor = UIColor.blue.cgColor
        postCodeField.placeholder = "Please Enter Your Postcode"
        postCodeField.clearButtonMode = .whileEditing
        
        // Do any additional setup after loading the view.
    }
    
    
//    func setChart(dataPoints: [String], values: [Double]) {
//        var dataEntries: [BarChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
//            dataEntries.append(dataEntry)
//        }
//
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Percent full immunised (%)")
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barChartView.data = chartData
//    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Percent full immunised (%)")
        lineChartDataSet.lineWidth = 5
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
