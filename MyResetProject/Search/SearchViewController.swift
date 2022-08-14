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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //리로드 데이터 말고
        //전체적으로 데이터를 다시 줘서 업데이트하고 싶은데
        //어떻게 해야하지..
        //searchView.searchTableView.reloadData()
        Observable.just(viewModel.movieArray.value)
            .bind(to: viewModel.movieArray)
            .disposed(by: disposeBag)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        navigationConfig()
        tableViewConfig()
        searchBarConfig()
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
    
    private func searchBarConfig() {
        searchView.searchBar.searchTextField.delegate = self
    }
    
    @objc func favoriteButtonDidTap() {
        let favoriteView = FavoriteView()
        let favoriteViewModel = FavoriteViewModel(databaesManager: RealmManager.shared)
        let viewController = FavoriteViewController(view: favoriteView, viewModel: favoriteViewModel)
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .fullScreen
        
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    func bind() {
        searchView.searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchInputText)
            .disposed(by: disposeBag)
               
        viewModel.searchInputText
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { $0 != "" }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.isLoading.accept(true)
                self.viewModel.startPage.accept(1)
                self.viewModel.totalCount.accept(1)
            })
            .flatMap { text -> Single<MovieResult> in
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

        searchView.searchBar.rx.searchButtonClicked
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .map { [unowned self] () -> String in
                return self.searchView.searchBar.text ?? ""
            }
            .filter { $0 != "" }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.isLoading.accept(true)
                self.viewModel.startPage.accept(1)
                self.viewModel.totalCount.accept(1)
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
                
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] bool in
                bool ? self!.searchView.showProgress() : self!.searchView.dissmissProgress()
            })
            .disposed(by: disposeBag)

        
        viewModel.movieArray
            .bind(to: searchView.searchTableView.rx.items(cellIdentifier: SearchTableViewCell.reuseIdentifier, cellType: SearchTableViewCell.self)) {
                [weak self] row, displayMovie, cell in
                
                cell.configureData(movie: displayMovie)
                cell.favoriteButtonAction = {
                    let favorite = self!.viewModel.checkFavoriteMovie(movie: displayMovie)
                    displayMovie.favorite = favorite
                    cell.changeButtonImage(favorite: displayMovie.favorite)
                }
            }
            .disposed(by: disposeBag)
        
        
        Observable
            .zip(searchView.searchTableView.rx.modelSelected(DisplayMovie.self),
                 searchView.searchTableView.rx.itemSelected)
            .bind { [unowned self] (displayMovie, indexPath) in
                self.searchView.searchTableView.deselectRow(at: indexPath, animated: true)
                
                //화면전환 -> Detail로
                let detailView = DetailView()
                let detailViewModel = DetailViewModel(movie: displayMovie, databaseManager: RealmManager.shared)
                let viewController = DetailViewController(view: detailView, viewModel: detailViewModel)
                navigationController?.pushViewController(viewController, animated: true)
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
                let start = viewModel.startPage.value + 10
//                print("찍혔니")
//                searchView.searchBar.rx.text.orEmpty
//                    .filter { $0 != "" }
//                    .do(onNext: { [unowned self] _ in
//                        print("찍혔니 체크")
//                        self.viewModel.isLoading.accept(true)
//                    })
//                    .flatMap { text -> Single<MovieResult> in
//                        return APIManager.shared.searchMovieSingle(query: text, start: start)
//                    }
                APIManager.shared
                    .searchMovieSingle(query: searchView.searchBar.text!, start: start)
                    .subscribe { [weak self] event in
                        guard let self = self else { return }
                        print("찍혔니 체크", "스타트 \(self.viewModel.startPage.value)")
                        switch event {
                        case .success(let movieResult):
                            self.viewModel.isLoading.accept(false)
                            self.viewModel.startPage.accept(movieResult.start ?? 1)
                            self.viewModel.totalCount.accept(movieResult.total ?? 1)

                            self.viewModel.movieResult.accept(movieResult)

                            let array = movieResult.items.map { $0.convertDisplayItem() }

                            let updateArray = self.viewModel.movieArray.value + array
                            self.viewModel.movieArray.accept(updateArray)
                        case .failure(let error):
                            self.viewModel.isLoading.accept(false)
                            print(error)
                        }
                    }
                    .disposed(by: disposeBag)
                    
                    
//                    .subscribe { [unowned self] event in
//                        switch event {
//                        case .next(let movieResult):
//                            self.viewModel.isLoading.accept(false)
//                            self.viewModel.startPage.accept(movieResult.start ?? 1)
//                            self.viewModel.totalCount.accept(movieResult.total ?? 1)
//
//                            self.viewModel.movieResult.accept(movieResult)
//
//                            let array = movieResult.items.map { $0.convertDisplayItem() }
//
//                            let updateArray = self.viewModel.movieArray.value + array
//                            self.viewModel.movieArray.accept(updateArray)
//                        case .error(let myError):
//                            self.viewModel.isLoading.accept(false)
//                            print(myError)
//                        case .completed:
//                            print("completed")
//                        }
//                    }
//                    .disposed(by: disposeBag)

            }
        }
    }
    
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        Observable.just([])
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.startPage.accept(1)
                self.viewModel.totalCount.accept(1)
            })
            .bind(to: viewModel.movieArray)
            .disposed(by: disposeBag)
        return true
    }
}
