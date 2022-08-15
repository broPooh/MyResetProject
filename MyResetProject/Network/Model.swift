//
//  Model.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

// MARK: - MovieResult
struct MovieResult: Codable {
    let lastBuildDate: String?
    let start: Int?
    let total: Int?
    var items: [Movie] = []
    let display: Int?
}

// MARK: - Item
struct Movie: Codable {
    let subtitle: String?
    let image: String?
    let title: String?
    let actor: String?
    let userRating: String?
    let pubDate: String?
    let director: String?
    let link: String?
    
    private enum CodingKeys: String, CodingKey {
        case subtitle
        case image
        case title
        case actor
        case userRating
        case pubDate
        case director
        case link
    }
        
    
    func convertDisplayItem() -> DisplayMovie {
        return DisplayMovie(subtitle: self.subtitle?.htmlEscaped ?? "", image: self.image?.htmlEscaped ?? "", title: self.title?.htmlEscaped ?? "", actor: String(self.actor?.htmlEscaped.dropLast() ?? ""), userRating: self.userRating?.htmlEscaped ?? "", pubDate: self.pubDate?.htmlEscaped ?? "", director: String(self.director?.htmlEscaped.dropLast() ?? ""), link: self.link?.htmlEscaped ?? "", favorite: RealmManager.shared.checkFavorite(title: self.title?.htmlEscaped ?? "", director: self.director?.htmlEscaped ?? "", userRating: self.userRating ?? ""))
    }
    
}
