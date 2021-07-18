//
//  Model.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 11.07.2021.
//


import UIKit
import SDWebImage

class NewsModelView {
    
    private let networkManager = NetworkingManager()
   
    var data: [Articles] = []
    var test: News?
    var numberOfRows: Int { data.count }
    private var page = 1
    
    
    func getDataCountry(country: String, refresh: Bool = false, category: String, completio: @escaping() -> Void) {
        if refresh == true {
            data.removeAll()
            page = 1
        }
        self.networkManager.getCountry(page: page, country: country, category: category) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
            case .failure(let error):
                break
            }
            self?.pagePlus()
            completio()
        }
        
    }
    
    func pagePlus() {
        page += 1
    }
    
    func getDataSources(sources: String, completio: @escaping() -> Void) {
        
        self.networkManager.getSources(page: page, sources: sources) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                print("seccsee")
            case .failure(let error):
                break
            }
            self?.pagePlus()
            completio()
        }
        
    }

}
extension UIImageView {
    func setImage(url: String) {
        
        guard let url = URL(string: url) else { return }
        sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        
    }
}
extension UIColor {
    static func mainWhite() -> UIColor {
        return #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
    }
}
