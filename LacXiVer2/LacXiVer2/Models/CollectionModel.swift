//
//  CollectionModel.swift
//  LacXiVer2
//
//  Created by Trường  on 2/9/24.
//

import Foundation
import RealmSwift

class CollectionModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var textObjects: List<TextModel> = List<TextModel>()
    
    convenience init(name: String, textObjects: List<TextModel>) {
        self.init()
        self.name = name
        self.textObjects = textObjects
    }
}


class TextModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var text: String
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
