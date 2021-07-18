//
//  ModelSaveFavoriteNews.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 16.07.2021.
//

import Foundation
import RealmSwift

class DataRealm: Object {
    
    @objc dynamic var image: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionNew: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var sourse: String = ""
    @objc dynamic var url: String = ""
    
}
