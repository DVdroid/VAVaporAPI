//
//  Song.swift
//  
//
//  Created by VA on 29/03/22.
//

import Fluent
import Vapor

final class Song: Model, Content {
    static var schema = "songs"
    
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    init() { }
    
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
    
}

