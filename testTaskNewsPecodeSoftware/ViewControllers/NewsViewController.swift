//
//  ViewController.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 11.07.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class NewsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = NewsViewModel()
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        viewModel.refresh()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        viewModel.refresh()
    }
    
    @IBAction func filterButton(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "filter") as? FilterViewController else { return }
        vc.delegate = self
        vc.viewModel.filter = viewModel.filter
        present(vc, animated: true, completion: nil)
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath
        ) as! TableViewCell
        cell.selectionStyle = .gray
        let wrappedItem = viewModel.data[indexPath.row]
        cell.titleLabel.text = wrappedItem.item.title
        cell.descriptionLabel.text = wrappedItem.item.description
        cell.sourseLabel.text = wrappedItem.item.source?.name
        cell.authorLabel.text = wrappedItem.item.author
        cell.favoriteButtonOutlet.isSelected = wrappedItem.isSelected
        if let url = wrappedItem.item.urlToImage {
            cell.imageViewNews.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageViewNews?.setImage(url: url)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows - 1 {
            viewModel.getNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedItem = viewModel.data[indexPath.row].item
        performSegue(withIdentifier: "segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "segue" else { return }
        guard let moreVC = segue.destination as? WebViewController,
              let selectedItem = viewModel.selectedItem else { return }
        moreVC.stringURL = selectedItem.url
    }
}

extension NewsViewController: CustomCellDelegate {
    func customCell(_ cell: TableViewCell, didPressButton: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.toggleFavoriteStateForItem(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension NewsViewController: FilterVCDelegate {
    func didSelect(filter: Filter) {
        viewModel.filter = filter
    }
}
