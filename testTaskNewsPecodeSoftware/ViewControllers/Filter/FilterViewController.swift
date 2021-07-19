//
//  FilterViewController.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 12.07.2021.
//

import UIKit


protocol FilterVCDelegate: AnyObject{
    func didSelect(filter: Filter)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var sourseTF: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    let viewModel = FilterViewModel()

    weak var delegate: FilterVCDelegate?

    lazy var picker: UIPickerView = {
        let view = UIPickerView()
        view.backgroundColor = .brown
        return view
    }()

    lazy var sourcesPickerDataSource: FilterPickerViewDataSource = {
        let source = FilterPickerViewDataSource()
        source.onOptionSelected = { [weak self] option in
            self?.sourseTF.text = option.text
            self?.viewModel.selectSource(row: option.row)
        }
        return source
    }()

    lazy var countriesPickerDataSource: FilterPickerViewDataSource = {
        let source = FilterPickerViewDataSource()
        source.options = viewModel.countries
        source.onOptionSelected = { [weak self] option in
            self?.countryTF.text = option.text
            self?.viewModel.selectCountry(code: option.text)
        }
        return source
    }()

    lazy var categoriesPickerDataSource: FilterPickerViewDataSource = {
        let source = FilterPickerViewDataSource()
        source.options = viewModel.categories
        source.onOptionSelected = { [weak self] option in
            self?.categoryTF.text = option.text
            self?.viewModel.selectCategory(option.text)
        }
        return source
    }()

    @IBAction func saveFilter(_ sender: UIButton) {
        dismiss(animated: true, completion: {[weak self] in
            guard let self = self else { return }
            self.delegate?.didSelect(filter: self.viewModel.filter)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        sourseTF.isHidden = true
        segmentedControl.setTitle("Country and category", forSegmentAt: 0)
        segmentedControl.setTitle("Sources", forSegmentAt: 1)
        let fields = [countryTF, categoryTF, sourseTF]
        fields.forEach {
            $0?.delegate = self
            $0?.alpha = 0
        }
        self.createToolbars()
        viewModel.getAllSources { [weak self] error in
            if let error = error {
                // Show error alert
                return
            }
            self?.sourcesPickerDataSource.options = self?.viewModel.sourcesNames ?? []
            self?.loadingIndicator.stopAnimating()
            self?.setupInitialData()
            UIView.animate(withDuration: 0.3, animations: {
                fields.forEach { $0?.alpha = 1 }
            })
        }
        updateSaveButtonState()
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        sourseTF.isHidden = sender.selectedSegmentIndex == 0
        countryTF.isHidden = sender.selectedSegmentIndex == 1
        categoryTF.isHidden = sender.selectedSegmentIndex == 1
    }

    private func setupInitialData() {
        countryTF.text = viewModel.filter.countryCode
        categoryTF.text = viewModel.filter.category
        sourseTF.text = viewModel.filter.source?.name
    }

    func createToolbars() {
        [countryTF, categoryTF, sourseTF].forEach { field in
            let toolbar = UIToolbar()
            toolbar.sizeToFit()

            let doneButton = UIBarButtonItem(title: "Done",
                                              style: .plain,
                                              target: self,
                                              action: #selector(dismissKeyboard))
            toolbar.setItems([doneButton], animated: true)
            toolbar.isUserInteractionEnabled = true
            toolbar.tintColor = .white
            toolbar.barTintColor = .brown
            field?.inputAccessoryView = toolbar
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateSaveButtonState() {
        let country = countryTF.text ?? ""
        let category = categoryTF.text ?? ""
        let sources = sourseTF.text ?? ""
        saveButtonOutlet.isEnabled = !country.isEmpty || !category.isEmpty || !sources.isEmpty
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
}

extension FilterViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputView = picker
        var source: PickerViewDataSorce!
        switch textField {
        case sourseTF:
            source = sourcesPickerDataSource
        case categoryTF:
            source = categoriesPickerDataSource
        case countryTF:
            source = countriesPickerDataSource
        default:
            fatalError("")
        }
        picker.dataSource = source
        picker.delegate = source
        return true
    }
}

