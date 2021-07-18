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
    
    let viewModel = FilterModel()
    var selectedElement: String?
    var arrayCountrys = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "vjp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph"," pl", "pt", "ro", "vrs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    
    let arrayCategory = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    var arraySourse: [InfoSource] = []
    var country = Filter.country
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SourseTF.isHidden = true
        segmentedControl.setTitle("Country and category", forSegmentAt: 0)
        segmentedControl.setTitle("Sources", forSegmentAt: 1)
        viewModel.getDataAllSources {
            self.arraySourse = self.viewModel.data
            print("seccses")
            
        }
        self.choiceUIElement()
        self.createToolbar()
        
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        
        case 0:
            SourseTF.isHidden = true
            CountryTF.isHidden = false
            CategoryTF.isHidden = false
        case 1:
            CountryTF.isHidden = true
            CategoryTF.isHidden = true
            SourseTF.isHidden = false
           
        default:
        print("Error")
        }
        
      
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
        
        switch country {
        case .country:
            CategoryTF.inputAccessoryView = toolbar
        case .category:
            CategoryTF.inputAccessoryView = toolbar
        case .sourse:
            SourseTF.inputAccessoryView = toolbar
        }
        
        toolbar.tintColor = .white
        toolbar.barTintColor = .brown
    }
    
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
    
    func choiceUIElement() {
        
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        
        switch country {
        case .country:
            CategoryTF.inputView = elementPicker
        case .category:
            CategoryTF.inputView = elementPicker
        case .sourse:
            SourseTF.inputView = elementPicker
        }
        
        elementPicker.backgroundColor = .brown
        
    }
}

extension FilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch country {
        case .country:
            return arrayCountrys.count
        case .category:
            return arrayCategory.count
        case .sourse:
            return arraySourse.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch country {
        case .country:
            return  arrayCountrys[row]
        case .category:
            return  arrayCategory[row]
        case .sourse:
            return  arraySourse[row].name
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch country {
        case .country:
            selectedElement = arrayCountrys[row]
            CountryTF.text = selectedElement
        case .category:
            selectedElement = arrayCategory[row]
            CategoryTF.text = selectedElement
        case .sourse:
            selectedElement = arraySourse[row].name
            SourseTF.text = selectedElement
        }
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
        
        switch country {
        case .country:
            pickerViewLabel.text = arrayCountrys[row]
        case .category:
            pickerViewLabel.text = arrayCategory[row]
        case .sourse:
            pickerViewLabel.text = arraySourse[row].name
        }
        
        return pickerViewLabel
    }
    
}
