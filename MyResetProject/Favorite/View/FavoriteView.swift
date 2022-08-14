//
//  FavoriteView.swift
//  MyResetProject
//
//  Created by bro on 2022/08/13.
//

import Foundation
import UIKit

final class FavoriteView: UIView, ViewRepresentable {
    
    var favoriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
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
        addSubview(favoriteTableView)
    }
    
    func setupConstraints() {
        favoriteTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
