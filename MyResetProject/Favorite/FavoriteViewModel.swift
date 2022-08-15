//
//  FavoriteViewModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/13.
//

import Foundation

import RxCocoa
import RxSwift

final class FavoriteViewModel: CommonViewModel {
    
    var movieList: BehaviorRelay<[MovieItem]> = BehaviorRelay(value: [])
    
    func deleteMovie(movie: MovieItem) -> Observable<[MovieItem]> {
        return Observable.just(())
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap {  _ in
                return Observable.just(movie)
            }
            .flatMap { [weak self] movie -> Observable<MovieItem> in
                guard let self = self else { return Observable.just(movie)}
                return self.databaesManager.delete(movie: movie)
            }
            .flatMap { [weak self] movie -> Observable<[MovieItem]> in
                guard let self = self else { return Observable.just([])}
                return self.databaesManager.movieList()
            }
    }
    
}
