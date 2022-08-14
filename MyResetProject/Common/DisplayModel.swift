//
//  DisplayModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

// MARK: - Item
class DisplayMovie: Codable {
    let subtitle: String
    let image: String
    let title: String
    let actor: String
    let userRating: String
    let pubDate: String
    let director: String
    let link: String
    var favorite: Bool = false
    
    init(subtitle: String, image: String, title: String, actor: String, userRating: String, pubDate: String, director: String, link: String, favorite: Bool = false)  {
        self.subtitle = subtitle
        self.image = image
        self.title = title
        self.actor = actor
        self.userRating = userRating
        self.pubDate = pubDate
        self.director = director
        self.link = link
        self.favorite = favorite
    }
    
    func convertRealmItem() -> MovieItem {
        let movieItem = MovieItem()
        
        movieItem.title = self.title
        movieItem.subtitle = self.subtitle
        movieItem.image = self.image
        movieItem.actor = self.actor
        movieItem.userRating = self.userRating
        movieItem.pubDate = self.pubDate
        movieItem.director = self.director
        movieItem.link = self.link
        
        return movieItem
    }
    
    static func convertDisplaymodel(movieItem: MovieItem) -> DisplayMovie {
        return DisplayMovie(subtitle: movieItem.subtitle, image: movieItem.image, title: movieItem.title, actor: movieItem.actor, userRating: movieItem.userRating, pubDate: movieItem.pubDate, director: movieItem.director, link: movieItem.link, favorite: true)
    }

}
