//
//  DetailViewController.swift
//  MyResetProject
//
//  Created by bro on 2022/08/14.
//

import UIKit

import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    private var detailView: DetailView
    private var viewModel: DetailViewModel
    
    var disposeBag: DisposeBag!
    
    init(view: DetailView, viewModel: DetailViewModel) {
        self.detailView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
        bind()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationConfig()
        //bind()
        bindMovieData(movie: viewModel.movie)
        bindWeb(movie: viewModel.movie)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
        detailView.webView.stopLoading()
    }
    
    private func navigationConfig() {
        // 타이틀 지정
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = viewModel.movie.title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func bind() {
        detailView.infoView.favoriteButton.rx.tap
            .flatMap { [weak self] () -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return Observable.just(self.viewModel.checkFavoriteMovie(favorite: self.viewModel.movie.favorite))
            }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] favorite in
                guard let self = self else { return }
                self.viewModel.movie.favorite = favorite
                self.changeButtonImage(favorite: favorite)
            })
            .disposed(by: disposeBag)
    }
    
    
    func bindMovieData(movie: DisplayMovie) {
        let infoView = detailView.infoView
        
        infoView.posterImageView.setImage(imageUrl: movie.image)
        infoView.titleLable.text = movie.title
        infoView.directorLable.text = movie.director != "" ? "감독: \(movie.director)" : "감독: 정보가 없습니다."
        infoView.castLable.text = movie.actor != "" ? "출연: \(movie.actor)" : "출연: 정보가 없습니다."
        infoView.rateLable.text = movie.userRating != "" ? "평점: \(movie.userRating)" : "평점: 정보가 없습니다."
        
        let favorite = viewModel.checkDB()
        changeButtonImage(favorite: favorite)
    }
    
    func changeButtonImage(favorite: Bool) {
        let color: UIColor = favorite ? .yellow : .lightGray
        detailView.infoView.favoriteButton.tintColor = color
    }
    
    func bindWeb(movie: DisplayMovie) {
        guard let url = URL(string: movie.link) else { print("Invalid URL"); return }
        let request = URLRequest(url: url)
        detailView.webView.load(request)
    }
}
