//
//  ViewController.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 11.07.2021.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    let model = Model()
    var selectData: Articles!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        model.getDataCountry(country: "us") {
            self.tableView.reloadData()
        }
       
//        model.getDataCategory(category: "business") {
//            self.tableView.reloadData()
//        }
//        model.getDataSources(sources: "techcrunch") {
//            self.tableView.reloadData()
//        }
        
    }
   
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath
        ) as! TableViewCell
        
        cell.selectionStyle = .gray
        cell.titleLabel.text = model.data[indexPath.row].title
        cell.descriptionLabel.text = model.data[indexPath.row].description
        cell.sourseLabel.text = model.data[indexPath.row].source?.name
        cell.authorLabel.text = model.data[indexPath.row].author
        
        if model.data[indexPath.row].urlToImage != nil {
            cell.imageViewNews.kf.indicatorType = .activity
            cell.imageViewNews?.setImage(url: model.data[indexPath.row].urlToImage!)
        }
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row == model.numberOfRows - 1 {
            model.getDataCountry(country: "us") {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectData = model.data[indexPath.row]
        print(selectData.url)
        
        performSegue(withIdentifier: "segue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "segue" else { return }
        guard let moreVC = segue.destination as? WebViewController else {return}
        moreVC.stringURL = selectData.url

    }
      
}
extension ViewController: CustomCellDelegate {
    func customCell(_ cell: TableViewCell, didPressButton: UIButton) {
        
        let indexPath = tableView.indexPath(for: cell)
        
    }
    
    
}

