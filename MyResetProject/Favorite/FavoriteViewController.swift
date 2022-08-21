//
//  FavoriteViewController.swift
//  MyResetProject
//
//  Created by bro on 2022/08/13.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class FavoriteViewController: UIViewController {
    
    private var favoriteView: FavoriteView
    private var viewModel: FavoriteViewModel
    
    private var disposeBag: DisposeBag!
    
    init(view: FavoriteView, viewModel: FavoriteViewModel) {
        self.favoriteView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = favoriteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        //bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        disposeBag = DisposeBag()
        bind()
        
        //즐겨찾기 화면에서 복귀시 화면 갱신을 위함.
        RealmManager.shared.movieList()
            .do(onNext: { movieList in
                print(movieList)
            })
            .bind(to: viewModel.movieList)
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    func configure() {
        navigationConfig()
        tableViewConfig()
    }
    
    private func navigationConfig() {
        // 타이틀 지정
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = "즐겨찾기 목록"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.navigationItem.titleView = titleLabel
        
        let dissmissBarButton = UIBarButtonItem(image: UIImage(systemName: SystemImage.xmark.rawValue), style: .plain, target: self, action: #selector(dissmissButtonDidTap))
        
        self.navigationItem.leftBarButtonItem = dissmissBarButton
    }
    
    private func bind() {
        
        viewModel.movieList
            .bind(to: favoriteView.favoriteTableView.rx.items(cellIdentifier: FavoriteTableViewCell.reuseIdentifier, cellType: FavoriteTableViewCell.self)) {
                row, movieItem, cell in
                cell.configureData(movie: movieItem)
                cell.favoriteButtonAction = { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.deleteMovie(movie: movieItem)
                        .bind(to: self.viewModel.movieList)
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        
        Observable
            .zip(favoriteView.favoriteTableView.rx.modelSelected(MovieItem.self),
                 favoriteView.favoriteTableView.rx.itemSelected)
            .bind { [weak self] (movieItem, indexPath) in
                guard let self = self else { return }
                self.favoriteView.favoriteTableView.deselectRow(at: indexPath, animated: true)
                
                //화면전환 -> Detail로
                //화면전환 -> Detail로
                let detailView = DetailView()
                let detailViewModel = DetailViewModel(movie: DisplayMovie.convertDisplaymodel(movieItem: movieItem), databaseManager: RealmManager.shared)
                let viewController = DetailViewController(view: detailView, viewModel: detailViewModel)
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            .disposed(by: disposeBag)

    }
    
    private func tableViewConfig() {
        favoriteView.favoriteTableView.rowHeight = 120
    }
    
    @objc func dissmissButtonDidTap() {
        dismiss(animated: true)
    }
    
}
