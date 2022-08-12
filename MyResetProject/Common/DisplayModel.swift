//
//  DisplayModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

// MARK: - Item
struct DisplayMovie: Codable {
    let subtitle: String
    let image: String
    let title: String
    let actor: String
    let userRating: String
    let pubDate: String
    let director: String
    let link: String
    var favorite: Bool = false
    
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

}
