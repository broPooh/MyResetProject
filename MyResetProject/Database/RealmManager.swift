//
//  RealmManager.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

class RealmManager: DataBaseManagerType {

    private init(){ }
    static let shared = RealmManager()
    
    private var list: [MovieItem] = []
    private lazy var storage = BehaviorSubject<[MovieItem]>(value: list)
    
    @discardableResult
    func createMovie(movie: DisplayMovie) -> Observable<MovieItem> {
        let localRealm = try! Realm()
        let movieItem = movie.convertRealmItem()
        
        do {
            try localRealm.write {
                localRealm.add(movieItem)
            }
            return Observable.just(movieItem)
        } catch {
            print("create Error: \(error)")
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func movieObservableList() -> Observable<[MovieItem]> {
        let localRealm = try! Realm()
        let results = localRealm.objects(MovieItem.self)
        var array: [MovieItem] = []
        results.forEach { movieItem in
            array.append(movieItem)
        }
        return Observable.just(array)
    }
    
    @discardableResult
    func movieList() -> Observable<[MovieItem]> {
        let localRealm = try! Realm()
        let results = localRealm.objects(MovieItem.self)
        var array: [MovieItem] = []
        results.forEach { movieItem in
            array.append(movieItem)
        }
        return Observable.just(array)
    }
    
    @discardableResult
    func movieList() -> BehaviorRelay<[MovieItem]> {
        let localRealm = try! Realm()
        let results = localRealm.objects(MovieItem.self)
        var array: [MovieItem] = []
        results.forEach { movieItem in
            array.append(movieItem)
        }
        return BehaviorRelay<[MovieItem]>(value: array)
    }
    
    @discardableResult
    func update(oldMovie: MovieItem, newMovie: MovieItem) -> Observable<MovieItem> {
        let localRealm = try! Realm()
        if let oldMovie = localRealm.objects(MovieItem.self).where({ $0._id == oldMovie._id}).first {
            do {
                try localRealm.write { () -> Observable<MovieItem> in
                    let update = MovieItem.updateMovie(oldMovie: oldMovie, updateMovie: newMovie)
                    return Observable.just(update)
                }
            } catch {
                print("update Error: \(error)")
                return Observable.error(error)
            }
        }
        
        return Observable.just(MovieItem())
    }
    
    @discardableResult
    func delete(movie: MovieItem) -> Observable<MovieItem> {
        let localRealm = try! Realm()
        do {
            if let deleteItem = localRealm.objects(MovieItem.self).where({
                $0.title == movie.title || $0.pubDate == movie.pubDate
            }).first {
                try localRealm.write {
                    localRealm.delete(deleteItem)
                }
                return Observable.just(deleteItem)
            } else {
                return Observable.error(DatabaseError.deleteFail)
            }
        } catch {
            print("Error Delete : \(error)")
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func delete(movie: DisplayMovie) -> Observable<MovieItem> {
        let localRealm = try! Realm()
        do {
            if let deleteItem = localRealm.objects(MovieItem.self).where({
                $0.title == movie.title || $0.pubDate == movie.pubDate
            }).first {
                try localRealm.write {
                        localRealm.delete(deleteItem)
                }
                return Observable.just(deleteItem)
            } else {
                return Observable.error(DatabaseError.deleteFail)
            }
        } catch {
            print("Error Delete : \(error)")
            return Observable.error(error)
        }
    }
    
    func checkFavorite(title: String, director: String) -> Bool {
        let localRealm = try! Realm()
        let checkItem = localRealm.objects(MovieItem.self).where({
            $0.title == title && $0.director == director
        }).first
        return checkItem != nil ? true : false
    }
    
    
}
