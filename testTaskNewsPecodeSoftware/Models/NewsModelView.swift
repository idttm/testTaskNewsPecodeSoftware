//
//  Model.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 11.07.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class IsSelectedWrapper<T> {
    let item: T
    var isSelected: Bool

    init(item: T, isSelected: Bool) {
        self.item = item
        self.isSelected = isSelected
    }
}

class NewsViewModel {
    private var notificationToken: NotificationToken?
    private let realm = try! Realm()
    private var page = 1
    private let networkManager = NetworkingManager()
    var selectedItem: Article?
    var filter: Filter = Filter(countryCode: nil, category: nil, source: nil) {
        didSet { refresh() }
    }
    var data: [IsSelectedWrapper<Article>] = []
    var numberOfRows: Int { data.count }
    var onDataUpdated: () -> Void = {}

    private lazy var savedItems: Results<NewsObject> = { realm.objects(NewsObject.self) }()

    func refresh() {
        page = 1
        getNextPage()
    }

    private func getData(completion: @escaping () -> Void) {
        var country: String? = nil
        var category: String? = nil
        var sources: String? = nil
        if filter.source == nil && filter.category == nil && filter.countryCode == nil {
            country = "us"
            category = "technology"
        } else {
            country = filter.countryCode
            category = filter.category
            sources = filter.source?.id
        }
        
        self.networkManager.getCountry(page: page, country: country , category: category, sources: sources) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if self.page == 1 { self.data.removeAll() }
                let wrappedItems = data.map { apiData in
                    IsSelectedWrapper(item: apiData, isSelected: self.savedItems.contains(where: { savedItem in savedItem.url == apiData.url }))
                }
                self.data.append(contentsOf: wrappedItems)
                self.increasePage()
            case .failure(let error):
                break
            }
            completion()
        }
    }
    
    private func increasePage() {
        page += 1
    }
    
    func getNextPage() {
        getData() { [weak self] in
            self?.onDataUpdated()
        }
    }

    func toggleFavoriteStateForItem(at indexPath: IndexPath) {
        let wrappedItem = data[indexPath.row]
        wrappedItem.isSelected.toggle()
        do {
            if (wrappedItem.isSelected) {
                //Save
                let object = NewsObject()
                object.title = wrappedItem.item.title ?? ""
                object.descriptionNew = wrappedItem.item.description ?? ""
                object.author = wrappedItem.item.author ?? ""
                object.sourse = wrappedItem.item.source?.name ?? ""
                object.image = wrappedItem.item.urlToImage ?? ""
                object.url = wrappedItem.item.url
                try realm.write({
                    realm.add(object, update: .modified)
                })
            } else {
                guard let objectToDelete = realm.object(ofType: NewsObject.self, forPrimaryKey: wrappedItem.item.url) else { return }
                try realm.write({
                    realm.delete(objectToDelete)
                })
            }
        } catch let error {
            error.localizedDescription
        }
    }

    init() {
        notificationToken = savedItems.observe(on: .main) { [weak self] changes in
            switch changes {
            case .update(_, let deletions, _, _):
                guard !deletions.isEmpty else { return }
                self?.refresh()
            default: break
            }
        }
    }

    deinit {
        notificationToken = nil
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
