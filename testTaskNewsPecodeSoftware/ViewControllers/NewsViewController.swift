//
//  ViewController.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 11.07.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class Items {
    
    var selected: Bool
    
    init(selected: Bool) {
        self.selected = selected
    }
    
}

class NewsViewController: UIViewController {
    
    let modelView = NewsModelView()
    var selectData: Articles!
    var selectedButton: [Items] = []
    let refreshControl = UIRefreshControl()

    let realm = try! Realm()
    var items: Results<DataRealm>!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
     
        modelView.getDataCountry(country: "us", category: "technology") {
            self.tableView.reloadData()
        }
        
//        modelView.getDataCategory(category: "business") {
//            self.tableView.reloadData()
//        }
//        modelView.getDataSources(sources: "techcrunch") {
//            self.tableView.reloadData()
//        }
       
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        modelView.getDataCountry(country: "us", refresh: true, category: "technology") {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelView.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath
        ) as! TableViewCell
        selectedButton.append(Items.init(selected: cell.favoriteButtonOutlet.isSelected))
        cell.selectionStyle = .gray
        cell.titleLabel.text = modelView.data[indexPath.row].title
        cell.descriptionLabel.text = modelView.data[indexPath.row].description
        cell.sourseLabel.text = modelView.data[indexPath.row].source?.name
        cell.authorLabel.text = modelView.data[indexPath.row].author
        cell.favoriteButtonOutlet.isSelected = selectedButton[indexPath.row].selected
        
        if modelView.data[indexPath.row].urlToImage != nil {
            cell.imageViewNews.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageViewNews?.setImage(url: modelView.data[indexPath.row].urlToImage!)
        }
       
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row == modelView.numberOfRows - 1 {
            modelView.getDataCountry(country: "us", category: "technology") {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectData = modelView.data[indexPath.row]
        performSegue(withIdentifier: "segue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "segue" else { return }
        guard let moreVC = segue.destination as? WebViewController else {return}
        moreVC.stringURL = selectData.url

    }
      
}

extension NewsViewController: CustomCellDelegate {
    func customCell(_ cell: TableViewCell, didPressButton: UIButton) {
        
        let indexPath = tableView.indexPath(for: cell)
        selectedButton[indexPath!.row].selected.toggle()
        let favoriteNew = DataRealm()
        favoriteNew.title = modelView.data[indexPath!.row].title!
        favoriteNew.descriptionNew = modelView.data[indexPath!.row].description!
        favoriteNew.author = modelView.data[indexPath!.row].author!
        favoriteNew.sourse = (modelView.data[indexPath!.row].source?.name)!
        favoriteNew.image = modelView.data[indexPath!.row].urlToImage!
        favoriteNew.url = modelView.data[indexPath!.row].url!
        do {
            try realm.write({
                realm.add(favoriteNew)
            })
        } catch let error {
            error.localizedDescription
        }
        tableView.reloadData()
      
    }
}

