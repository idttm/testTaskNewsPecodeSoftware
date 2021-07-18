//
//  FilterModel.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 17.07.2021.
//

import Foundation

class FilterModel {
    
    let networkManager = NetworkingManager()
    
    var data: [InfoSource] = []
    
    
    
    func getDataAllSources( completion: @escaping() -> Void) {
        networkManager.getAllSourse { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion()
        }
    }
    
    
}
