//
//  Model.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 11.07.2021.
//


import UIKit
import SDWebImage

class NewsViewModel {
        
    private let networkManager = NetworkingManager()
    var filter: Filter = Filter(countryCode: nil, category: nil, sourceId: nil)
    var data: [Articles] = []
    var test: News?
    var numberOfRows: Int { data.count }
    private var page = 1
    
    func getDataForCountry(country: String?, refresh: Bool = false,sources: String?, category: String?, completion: @escaping() -> Void) {
        if refresh == true {
            data.removeAll()
            page = 1
        }
        self.networkManager.getCountry(page: page, country: country, category: category, sources: sources) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
            case .failure(let error):
                break
            }
            self?.increasePage()
            completion()
        }
        
    }
    
    func increasePage() {
        page += 1
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
