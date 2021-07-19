//
//  FilterModel.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 17.07.2021.
//


import Foundation

struct Filter {
    var countryCode: String?
    var category: String?
    var source: InfoSource?
}

class FilterViewModel {
    
    private var sources: [InfoSource] = []
    private let networkManager = NetworkingManager()

    let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "vjp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph"," pl", "pt", "ro", "vrs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]

    let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]

    var sourcesNames: [String] {
        sources.map { $0.name }
    }

    var filter: Filter = Filter(countryCode: nil, category: nil, source: nil)

    func selectCountry(code: String) {
        filter.source = nil
        filter.countryCode = code
    }

    func selectCategory(_ category: String) {
        filter.source = nil
        filter.category = category
    }

    func selectSource(row: Int) {
        filter.countryCode = nil
        filter.category = nil
        filter.source = sources[row]
    }

    func getAllSources(completion: @escaping (Error?) -> Void) {
        networkManager.getAllSources { [weak self] result in
            switch result {
            case .success(let data):
                self?.sources.append(contentsOf: data)
                completion(nil)
            case .failure(let error):
                print(error.localizedDescription)
                completion(error)
            }
        }
    }
}
