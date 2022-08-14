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
    var disposeBag = DisposeBag()
    
    var movieList: BehaviorRelay<[MovieItem]> {
        return RealmManager.shared.movieList()
    }
    
    func deleteMovie(movie: MovieItem) -> Observable<[MovieItem]> {
        return Observable.just(())
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap {  _ in
                return Observable.just(movie)
            }
            .flatMap { [weak self] movie in
                self!.databaesManager.delete(movie: movie)
            }
            .flatMap { [weak self] _ -> Observable<[MovieItem]> in
                self!.databaesManager.movieList()
            }
    }
    
}
