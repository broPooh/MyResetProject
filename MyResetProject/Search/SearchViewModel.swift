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
    var disposeBag = DisposeBag()
    
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
        
        
        
//            .map { [unowned self] movieResult -> [DisplayMovie] in
//                self.viewModel.startPage.accept(movieResult.start ?? 1)
//                self.viewModel.totalCount.accept(movieResult.total ?? 1)
//
//                let array = movieResult.items.map { movie in
//                    movie.convertDisplayItem()
//                }
//               return array
//            }
            
    }
    
    func test() {
        
//        fetchMovie(start: 10)
//            .subscribe { [weak self] event in
//                switch event {
//                case .success(let movieArray2):
//                    self?.movieArray.accept(movieArray2)
//                case .failure(let myError):
//                    print(myError)
//                }
//            }
//            .disposed(by: disposeBag)
                
    }
    
    func checkFavoriteMovie(movie: DisplayMovie) -> Bool {
        if movie.favorite {
            databaesManager.delete(movie: movie.convertRealmItem())
            return false
        } else {
            databaesManager.createMovie(movie: movie)
            return true
        }
        
    }
    
}
