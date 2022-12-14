//
//  RealmModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation
import RealmSwift

enum SearchType: Int, PersistableEnum {
   case movie = 100
   case drama = 200
}

class MovieItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var subtitle: String
    @Persisted var image: String
    @Persisted var actor: String
    @Persisted var userRating: String
    @Persisted var pubDate: String
    @Persisted var director: String
    @Persisted var link: String
    @Persisted var type: SearchType
    
    convenience init(id: Int, title: String, subtitle: String, image: String, actor: String, userRating: String, pubDate: String, director: String, link: String, type: SearchType = .movie) {
        self.init()
        
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.actor = actor
        self.userRating = userRating
        self.pubDate = pubDate
        self.director = director
        self.link = link
        self.type = type
    }
    
    
    static func updateMovie(oldMovie: MovieItem, updateMovie: MovieItem) -> MovieItem {
        oldMovie.title = updateMovie.title
        oldMovie.subtitle = updateMovie.subtitle
        oldMovie.image = updateMovie.image
        oldMovie.actor = updateMovie.actor
        oldMovie.userRating = updateMovie.userRating
        oldMovie.pubDate = updateMovie.pubDate
        oldMovie.director = updateMovie.director
        oldMovie.link = updateMovie.link
        return oldMovie
    }
    
}
