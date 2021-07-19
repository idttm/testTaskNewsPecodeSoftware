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
    var onDataUpdated: () -> Void = {}
//    var filter = FilterViewModel().filter
    
    func refresh (completion: @escaping() -> Void) {
        self.getDataForCountry(country: filter.countryCode, sources: filter.sourceId, category: filter.category) {
            completion()
        }
    }
    
    func getDataForCountry(country: String?, refresh: Bool = false, sources: String?, category: String?, completion: @escaping() -> Void) {
        
        if refresh == true {
            page = 1
            data.removeAll()
        }
        self.networkManager.getCountry(page: page, country: country, category: category, sources: sources) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                self?.onDataUpdated()
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
    
    func getNextPage() {
        print(self.page)
        print(filter.countryCode)
        if filter.category == nil && filter.countryCode == nil && filter.sourceId == nil {
            getDataForCountry(country: "us", sources: nil, category: "technology") {
                self.onDataUpdated()
            }
        } else {
            getDataForCountry(country: filter.countryCode, sources: filter.sourceId, category: filter.category) {
                self.onDataUpdated()
            }
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
