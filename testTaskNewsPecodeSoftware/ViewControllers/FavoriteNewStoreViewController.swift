//
//  FavoriteNewStoreViewController.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 13.07.2021.
//

import UIKit
import RealmSwift
import SDWebImage

class FavoriteNewStoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = FavoriteNewsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        viewModel.items = viewModel.realm.objects(NewsObject.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension FavoriteNewStoreViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { fatalError() }
        let item = viewModel.items[indexPath.row]
        cell.authorLabel.text = item.title
        cell.descriptionLabel.text = item.descriptionNew
        cell.authorLabel.text = item.author
        cell.sourseLabel.text = item.sourse
        cell.imageViewNews.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imageViewNews?.setImage(url: item.image)
        cell.favoriteButtonOutlet.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let editingRow = viewModel.items[indexPath.row]
        if editingStyle == .delete {
            viewModel.deleteItem(editingRow: editingRow) {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
