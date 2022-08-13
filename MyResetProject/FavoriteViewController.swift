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
    
    var disposeBag = DisposeBag()
    var favoriteButtonAction: ( () -> () )?
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //즐겨찾기 화면에서 복귀시 화면 갱신을 위함.
        //이거 말고 다른 방법이 맞는거 같은데..
        favoriteView.favoriteTableView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
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
    
    private func tableViewConfig() {
        favoriteView.favoriteTableView.delegate = self
        favoriteView.favoriteTableView.dataSource = self
    }
    
    @objc func dissmissButtonDidTap() {
        dismiss(animated: true)
    }
    
}
