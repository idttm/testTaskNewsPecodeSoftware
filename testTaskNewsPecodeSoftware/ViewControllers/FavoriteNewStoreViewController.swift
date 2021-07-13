//
//  FavoriteNewStoreViewController.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 13.07.2021.
//

import UIKit

class FavoriteNewStoreViewController: UIViewController {
   

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
      
    }
    

   
}
extension FavoriteNewStoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { fatalError() }
        
        
        
        return cell
    }
    
    
}
