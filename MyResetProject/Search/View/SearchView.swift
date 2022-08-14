//
//  SearchView.swift
//  MyResetProject
//
//  Created by bro on 2022/08/13.
//

import UIKit

import SnapKit
import JGProgressHUD

final class SearchView: UIView {
    
    let hud = JGProgressHUD()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setImage(UIImage(named: SystemImage.icSearchNonW.rawValue), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: SystemImage.icCancel.rawValue), for: .clear, state: .normal)
        
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.cornerRadius = 4
        searchBar.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.rightView?.tintColor = .white
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.textAlignment = .center
        label.backgroundColor = .white
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        addSubview(searchBar)
        addSubview(searchTableView)
        addSubview(noDataLabel)
    }
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
                
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    func showProgress() {
        hud.show(in: self)
    }
    
    func dissmissProgress() {
        hud.dismiss()
    }
}
