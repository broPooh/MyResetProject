//
//  DetailViewModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/14.
//

import Foundation

import RxCocoa
import RxSwift

final class DetailViewModel: CommonViewModel {
    var movie: DisplayMovie
    
    let isFavorite = BehaviorRelay<Bool>(value: false)
    
        
    init(movie: DisplayMovie, databaseManager: DataBaseManagerType) {
        self.movie = movie
        isFavorite.accept(movie.favorite)
        super.init(databaesManager: databaseManager)
    }
        
    func checkDB() -> Bool {
        return databaesManager.checkFavorite(title: movie.title, director: movie.director, userRating: movie.userRating)
    }
    
    func checkFavoriteMovie(favorite: Bool) -> Bool{
        _ = favorite ? databaesManager.delete(movie: movie) : databaesManager.createMovie(movie: movie)
        return !favorite
    }
    
}
