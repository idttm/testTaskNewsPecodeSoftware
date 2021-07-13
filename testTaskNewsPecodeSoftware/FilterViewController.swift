//
//  FilterViewController.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 12.07.2021.
//

import UIKit

enum Filter {
    case country
    case category
    case sourse
}

class FilterViewController: UIViewController {

    @IBOutlet weak var CountryTF: UITextField!
    @IBOutlet weak var CategoryTF: UITextField!
    @IBOutlet weak var SourseTF: UITextField!
    
    let model = Model()
    var selectedElement: String?
    
    var arrayCountrys = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "vjp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph"," pl", "pt", "ro", "vrs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    
    let arrarCategory = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    
    let arraySourse = ["cnn", "reuters", "bleacher-report", "the-hill", "fox-news","usa-today", "nbc-news", "politico","bbc-news","google-news", "lenta" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        choiceUIElement()
        createToolbar()
    }

   
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done",
                                          style: .plain,
                                          target: self,
                                          action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        CountryTF.inputAccessoryView = toolbar
       
//        case .country:
//CountryTF.inputAccessoryView = toolbar
//        case .category:
//            CategoryTF.inputAccessoryView = toolbar
//            print("CategoryTF.inputAccessoryView = toolbar")
//        case .sourse:
//            SourseTF.inputAccessoryView = toolbar
//            print("SourseTF.inputAccessoryView = toolbar")
        
        toolbar.tintColor = .white
        toolbar.barTintColor = .brown
    }
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
    func choiceUIElement() {
        
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        CountryTF.inputView = elementPicker
        
        elementPicker.backgroundColor = .brown
        
    }
    
    
}


extension FilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        arrayCountrys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        arrayCountrys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedElement = arrayCountrys[row]
        CountryTF.text = selectedElement
        
        
//
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerViewLabel = UILabel()
        
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel()
        }
        pickerViewLabel.textColor = .white
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 23)
        pickerViewLabel.text = arrayCountrys[row]
        
        return pickerViewLabel
    }
    
}
