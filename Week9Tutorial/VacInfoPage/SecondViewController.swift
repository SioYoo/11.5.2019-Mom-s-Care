//
//  SecondViewController.swift
//  mom's care
//
//  Created by Daniel Dz on 4/4/19.
//  Copyright © 2019 Daniel Dz. All rights reserved.
//

import UIKit
import TCPickerView

class SecondViewController: UIViewController, TCPickerViewOutput, TCPickerViewThemeType{
    
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("User select row at index: \(index)")
    }
    
    var selectedAge = "0-2"
    
    @IBAction func showInfo(_ sender: Any) {
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = NSLocalizedString("Baby's Age in Month", comment: "")
        let age = [
            NSLocalizedString("0-2 Month", comment: ""),
            NSLocalizedString("2-4 Month", comment: ""),
            NSLocalizedString("4-6 Month", comment: ""),
            NSLocalizedString("6-12 Month", comment: "")
        ]
        let values = age.map { TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
                self.selectedAge = values[i].title
            }
            self.performSegue(withIdentifier: "showVacInfo", sender: self)
        }
        picker.closeAction = {
            print("Handle close action here")
        }
        picker.show()
        
    }
    
    @IBOutlet weak var infoButton: UIButton!
    var agePickerData: [String] = [String]()
    var regionPickerData: [String] = [String]()
    var ageData = String()
    var regionData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = .white
        //infoButton.layer.cornerRadius = 4
        
        regionPickerData = ["China", "India"]
        
        agePickerData = ["0-2","2-4","4-6", "6-12"]
        
        //        self.agePicker.dataSource = self
        //        self.regionPicker.dataSource = self
        //        self.agePicker.delegate = self
        //        self.regionPicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    //    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    //        return 1
    //    }
    //
    //    // The number of rows of data
    //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    //        if pickerView == agePicker{
    //            return agePickerData.count
    //        }
    //        else{
    //            return regionPickerData.count
    //        }
    //    }
    //
    //    // The data to return fopr the row and component (column) that's being passed in
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        if pickerView == agePicker{
    //            ageData = agePickerData[row]
    //            return agePickerData[row]
    //        }
    //        else{
    //            regionData = regionPickerData[row]
    //            return regionPickerData[row]
    //        }
    //    }
    
    //    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    //        if pickerView == agePicker{
    //            let attributedString = NSAttributedString(string: agePickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
    //            return attributedString
    //        }
    //        else{
    //            let attributedString = NSAttributedString(string: regionPickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
    //            return attributedString
    //        }
    //
    //    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showVacInfo") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let vacVC = segue.destination as! TestViewController;
            vacVC.selection = selectedAge
        }
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
