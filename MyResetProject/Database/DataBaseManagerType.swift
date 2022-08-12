//
//  DataBaseManagerType.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

import RxSwift

enum DatabaseError: Error {
    case deleteFail
}


protocol DataBaseManagerType {

    @discardableResult
    func createMovie(movie: Movie) -> Observable<MovieItem>
    
    @discardableResult
    func movieList() -> Observable<[MovieItem]>
    
    @discardableResult
    func update(oldMovie: MovieItem, newMovie: MovieItem) -> Observable<MovieItem>
    
    @discardableResult
    func delete(movie: MovieItem) -> Observable<MovieItem>
    
    func checkFavorite(title: String, director: String) -> Bool
    
}
