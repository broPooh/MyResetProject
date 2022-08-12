//
//  RealmModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation
import RealmSwift

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
    
    convenience init(id: Int, title: String, subtitle: String, image: String, actor: String, userRating: String, pubDate: String, director: String, link: String) {
        self.init()
        
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.actor = actor
        self.userRating = userRating
        self.pubDate = pubDate
        self.director = director
        self.link = link
    }
    
    
    static func convertMovie(movie: Movie) -> MovieItem {
        let movieItem = MovieItem()
        movieItem.title = movie.title?.htmlEscaped ?? ""
        movieItem.subtitle = movie.subtitle?.htmlEscaped ?? ""
        movieItem.image = movie.image ?? ""
        movieItem.actor = movie.actor ?? ""
        movieItem.userRating = movie.userRating ?? ""
        movieItem.pubDate = movie.pubDate ?? ""
        movieItem.director = movie.director ?? ""
        movieItem.link = movie.link ?? ""
        
        return movieItem
        
    }
    
    static func convertMovieItem(movieItem: MovieItem) -> Movie {
        return Movie(subtitle: movieItem.subtitle, image: movieItem.image, title: movieItem.title, actor: movieItem.actor, userRating: movieItem.userRating, pubDate: movieItem.pubDate, director: movieItem.director, link: movieItem.link)
    }
    
    static func updateMovie(oldMovie:MovieItem, updateMovie: MovieItem) -> MovieItem {
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
