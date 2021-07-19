//
//  PickerViewDataSorce.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 18.07.2021.
//

import UIKit

protocol PickerViewDataSorce: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var options: [String] { get set }
    var onOptionSelected: ((row: Int, text: String)) ->  Void { get set }
}

class FilterPickerViewDataSource: NSObject, PickerViewDataSorce {
    var options: [String] = []

    var onOptionSelected: ((row: Int, text: String)) -> Void = { _ in }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { options.count }

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
        pickerViewLabel.text = options[row]
        return pickerViewLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onOptionSelected((row: row, text: options[row]))
    }
}

