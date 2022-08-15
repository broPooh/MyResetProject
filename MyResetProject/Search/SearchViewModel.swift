//
//  SearchViewModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchViewModel: CommonViewModel {    
    let searchInputText: PublishRelay<String> = PublishRelay()

    var movieResult: PublishRelay<MovieResult> = PublishRelay()
    
    var movieArray: BehaviorRelay<[DisplayMovie]> = BehaviorRelay(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    let startPage: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    let totalCount: BehaviorRelay<Int> = BehaviorRelay(value: 1)
        
    func fetchMovie(start: Int) -> Observable<MovieResult> {
        return searchInputText
            .filter { $0 != "" }
            .do(onNext: { [unowned self] _ in
                self.isLoading.accept(true)
            })
            .flatMap { text -> Single<MovieResult> in
                return APIManager.shared.searchMovieSingle(query: text, start: start)
            }
                    
    }
        
    func checkFavoriteMovie(movie: DisplayMovie) -> Bool {
        let favorite = databaesManager.checkFavorite(title: movie.title, director: movie.director, userRating: movie.userRating)
        if favorite {
            databaesManager.delete(movie: movie)
            return false
        } else {
            databaesManager.createMovie(movie: movie)
            return true
        }
        
    }
    
}
