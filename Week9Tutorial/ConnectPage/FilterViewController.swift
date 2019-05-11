//
//  FilterViewController.swift
//  Week9Tutorial
//
//  Created by Ziyi Deng on 10/5/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit
import PopupDialog
import ZKCarousel

class FilterViewController: UIViewController {

    @IBOutlet weak var englishField: UITextField!
    @IBOutlet weak var languageField: UITextField!
    @IBOutlet var carousel: ZKCarousel! = ZKCarousel()
    var testArray: [String] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    private func setupCarousel() {
        
        // Create as many slides as you'd like to show in the carousel
        let slide = ZKCarouselSlide(image: #imageLiteral(resourceName: "connect1"), title: "",  description: "Connecting to the same culturally rich community can imbibe the cultural values in your kids and keep them related to their own culture")
        let slide1 = ZKCarouselSlide(image: #imageLiteral(resourceName: "connect2"), title: "", description: "Reconnecting to your culture can enrich your sense of self-identity and overall wellbeing")
        let slide2 = ZKCarouselSlide(image: #imageLiteral(resourceName: "connect3"), title: "", description: "Learning from the experiences to relate more effectively across cultural lines can boost your self-confidence to socialize with other cultures")
        
        
        // Add the slides to the carousel
        self.carousel.slides = [slide, slide1, slide2]
        
        
        // You can optionally use the 'interval' property to set the timing for automatic slide changes. The default is 1 second.
        self.carousel.interval = 8
        
        // Optional - automatic switching between slides.
        self.carousel.start()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        for dic:[String:Any] in self.getJson("Population") {
            if (dic["Population"]!) as! Double >= 10.0 {
                self.testArray.append(dic["Name"] as! String)
            }
        }
        print(self.testArray)
    }
    
    @IBOutlet weak var populationField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        self.setupCarousel()
        
        populationField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        languageField.addTarget(self, action: #selector(selectLanguageFunction), for: .touchDown)
        englishField.addTarget(self, action: #selector(selectEnglishFunction), for: .touchDown)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func selectLanguageFunction(textField: UITextField) {
        let title = "Langugage"
        
        let message = "Find a suburb where Chinese people speaks:"
        
        let image = UIImage.init(named: "home1")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        // Create first button
        let buttonOne = DefaultButton(title: "Mandarin") {
            self.languageField.text = "Mandarin"
        }
        
        let buttonTwo = DefaultButton(title: "Cantonese") {
            self.languageField.text = "Cantonese"
        }
        
        let buttonThree = DefaultButton(title: "Other Chinese language") {
            self.languageField.text = "Other Chinese language"
        }
        
        let buttonFour = DefaultButton(title: "English Only") {
            self.languageField.text = "English Only"
        }
        
        let buttonFive = CancelButton(title: "Cancel") {
            self.languageField.placeholder = "Tap to Select"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func selectEnglishFunction(textField: UITextField) {
        let title = "English Proficiency"
        
        let message = "Find the suburb where the Chinese people's proficiency is:"
        
        let image = UIImage.init(named: "home1")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        // Create first button
        let buttonOne = DefaultButton(title: "Excellent") {
            self.englishField.text = "Excellent"
        }
        
        let buttonTwo = DefaultButton(title: "Good") {
            self.englishField.text = "Good"
        }
        
        let buttonThree = DefaultButton(title: "Average") {
            self.englishField.text = "Average"
        }
        
        let buttonFour = DefaultButton(title: "Poor") {
            self.englishField.text = "Poor"
        }
        
        let buttonFive = CancelButton(title: "Cancel") {
            self.englishField.placeholder = "Tap to Select"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let title = "Chinese Population"
        
        let message = "Find a suburb where the number of Chinese people is:"
        
        let image = UIImage.init(named: "home1")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        // Create first button
        let buttonOne = DefaultButton(title: "More") {
            self.populationField.text = "More"
        }
        
        let buttonTwo = DefaultButton(title: "Less") {
            self.populationField.text = "Less"
        }
        
        
        let buttonFour = CancelButton(title: "Cancel") {
            self.populationField.placeholder = "Tap to Select"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo, buttonFour])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
