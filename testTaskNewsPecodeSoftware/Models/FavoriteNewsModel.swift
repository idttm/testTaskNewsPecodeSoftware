//
//  FavoriteNewsModel.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 16.07.2021.
//

import Foundation
import RealmSwift

class FavoriteNewsModel {
    
    let realm = try! Realm()
    var items: Results<DataRealm>!
    
    func deleteItem(editingRow: DataRealm, completin: @escaping() -> Void ) {
        do {
            try self.realm.write({
                self.realm.delete(editingRow)
            })
            completin()
        } catch let error {
            error.localizedDescription
        }
    }
    
}
