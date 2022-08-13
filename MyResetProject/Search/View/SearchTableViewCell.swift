//
//  SearchViewCell.swift
//  MyResetProject
//
//  Created by bro on 2022/08/13.
//

import Foundation

import SnapKit
import UIKit

final class SearchTableViewCell: UITableViewCell, ViewRepresentable {
    
    var favoriteButtonAction: ( () -> () )?
    
    var infoView = InfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        buttonConfig()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(infoView)
    }
    
    func setupConstraints() {
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func buttonConfig() {
        infoView.favoriteButton.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
    }
    
    func configureData(movie: DisplayMovie) {
        infoView.posterImageView.setImage(imageUrl: movie.image)
        infoView.titleLable.text = movie.title.htmlEscaped
        infoView.directorLable.text = "감독: \(movie.director)"
        infoView.castLable.text = "출연: \(movie.actor)"
        infoView.rateLable.text = "평점: \(movie.userRating)"
        
        let favorite = RealmManager.shared.checkFavorite(title: movie.title, director: movie.director)
        
        changeButtonImage(favorite: favorite)
    }
    
    func changeButtonImage(favorite: Bool) {
        let color: UIColor = favorite ? .yellow : .lightGray
        infoView.favoriteButton.setImage(UIImage(systemName: SystemImage.star.rawValue), for: .normal)
        infoView.favoriteButton.tintColor = color
    }
    
    @objc func favoriteButtonClicked() {
        favoriteButtonAction?()
    }
    
    
}
