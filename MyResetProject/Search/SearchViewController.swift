//
//  SearchViewController.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import RxAlamofire

class SearchViewController: UIViewController {
    
    private var searchView: SearchView
    private var viewModel: SearchViewModel
    
    var disposeBag = DisposeBag()
    
    init(view: SearchView, viewModel: SearchViewModel) {
        self.searchView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = searchView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        navigationConfig()
        tableViewConfig()
        bind()
    }
    
    private func navigationConfig() {
        // 타이틀 지정
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = "네이버 영화 검색"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        let customBarButton = createCustomBarButton()
        customBarButton.addTarget(self, action: #selector(favoriteButtonDidTap), for: .touchUpInside)
        let favoriteButton = UIBarButtonItem(customView: customBarButton)
        self.navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func createCustomBarButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .yellow
        button.setTitle("즐겨찾기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 75, height: 30)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }
    
    private func tableViewConfig() {
        searchView.searchTableView.prefetchDataSource = self
        searchView.searchTableView.rowHeight = 120
    }
    
    @objc func favoriteButtonDidTap() {
        
    }
    
    func bind() {
        searchView.searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchInputText)
            .disposed(by: disposeBag)
        
        viewModel.searchInputText
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { $0 != "" }
            .do(onNext: { [unowned self] _ in
                print("test1")
                self.viewModel.isLoading.accept(true)
            })
            .flatMap { text -> Single<MovieResult> in
                print("test2")
                return APIManager.shared.searchMovieSingle(query: text, start: 1)
            }
            .subscribe { [unowned self] event in
                switch event {
                case .next(let movieResult):
                    self.viewModel.isLoading.accept(false)
                    self.viewModel.startPage.accept(movieResult.start ?? 1)
                    self.viewModel.totalCount.accept(movieResult.total ?? 1)

                    self.viewModel.movieResult.accept(movieResult)

                    let array = movieResult.items.map { $0.convertDisplayItem() }

                    self.viewModel.movieArray.accept(array)
                case .error(let myError):
                    self.viewModel.isLoading.accept(false)
                    print(myError)
                case .completed:
                    print("completed")
                }
            }
            .disposed(by: disposeBag)
//            .asSingle()
//            .subscribe { [unowned self] event in
//                switch event {
//                case .success(let movieResult):
//
//                    print("성공체크2")
//
//                    self.viewModel.isLoading.accept(false)
//                    self.viewModel.startPage.accept(movieResult.start ?? 1)
//                    self.viewModel.totalCount.accept(movieResult.total ?? 1)
//
//                    self.viewModel.movieResult.accept(movieResult)
//
//                    let array = movieResult.items.map { $0.convertDisplayItem() }
//
//                    self.viewModel.movieArray.accept(array)
//                case .failure(let error):
//                    print("실패체크2")
//                    print(error)
//                }
//            }
//            .disposed(by: disposeBag)
        
        
        



        searchView.searchBar.rx.searchButtonClicked
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .map { [unowned self] () -> String in
                return self.searchView.searchBar.text ?? ""
            }
            .filter { $0 != "" }
            .do(onNext: { [unowned self] _ in
                self.viewModel.isLoading.accept(true)
            })
            .asSingle()
            .flatMap { text -> Single<MovieResult> in
                return APIManager.shared.searchMovieSingle(query: text, start: 1)
            }
            .map { [unowned self] movieResult -> [DisplayMovie] in
                self.viewModel.startPage.accept(movieResult.start ?? 1)
                self.viewModel.totalCount.accept(movieResult.total ?? 1)
                                
                let array = movieResult.items.map { movie in
                    movie.convertDisplayItem()
                }
               return array
            }
            .subscribe { [unowned self] event in
                switch event {
                case .success(let displayMovies):
                    self.viewModel.isLoading.accept(false)
                    self.viewModel.movieArray.accept(displayMovies)
                case .failure(let myError):
                    self.viewModel.isLoading.accept(false)
                    print(myError)
                }
            }
            .disposed(by: disposeBag)
        
            
        searchView.searchBar.rx.cancelButtonClicked
            .map { () -> [DisplayMovie] in
                return []
            }
            .subscribe(onNext: { result in
                self.viewModel.movieArray.accept(result)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [unowned self] bool in
                bool ? self.searchView.showProgress() : self.searchView.dissmissProgress()
            })
            .disposed(by: disposeBag)

        
        viewModel.movieArray
            .bind(to: searchView.searchTableView.rx.items(cellIdentifier: SearchTableViewCell.reuseIdentifier, cellType: SearchTableViewCell.self)) {
                [unowned self] row, displayMovie, cell in
                
                var movie = viewModel.movieArray.value[row]
                cell.configureData(movie: displayMovie)
                cell.favoriteButtonAction = {
                    let favorite = self.viewModel.checkFavoriteMovie(movie: displayMovie)
                    movie.favorite = favorite
                    cell.changeButtonImage(favorite: movie.favorite)
                }
            }
            .disposed(by: disposeBag)

    }
    

}

// MARK: - TableView Prefetcing
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        let itemCount = viewModel.movieArray.value.count
        let totalCount = viewModel.totalCount.value
        
        for indexPath in indexPaths {
            if itemCount - 1 == indexPath.row && itemCount < totalCount {
                
                print("불렸니")
                
                let start = viewModel.startPage.value + 10
                viewModel.fetchMovie(start: start)
                    .subscribe { [unowned self] event in
                        switch event {
                        case .next(let movieResult):
                            self.viewModel.isLoading.accept(false)
                            self.viewModel.startPage.accept(movieResult.start ?? 1)
                            self.viewModel.totalCount.accept(movieResult.total ?? 1)

                            self.viewModel.movieResult.accept(movieResult)

                            let array = movieResult.items.map { $0.convertDisplayItem() }

                            self.viewModel.movieArray.accept(array)
                        case .error(let myError):
                            self.viewModel.isLoading.accept(false)
                            print(myError)
                        case .completed:
                            print("completed")
                        }
                    }
                    .disposed(by: disposeBag)
//                    .subscribe { [unowned self] event in
//                        switch event {
//                        case .success(let displayMovies):
//                            self.viewModel.isLoading.accept(false)
//                            self.viewModel.movieArray.accept(displayMovies)
//                        case .failure(let myError):
//                            self.viewModel.isLoading.accept(false)
//                            print(myError)
//                        }
//                    }
//                    .disposed(by: disposeBag)

            }
        }
    }
    
    
}
