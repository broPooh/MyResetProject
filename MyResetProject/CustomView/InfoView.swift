//
//  InfoView.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import Foundation

import UIKit
import SnapKit

final class InfoView: UIView, ViewRepresentable {
    var favoriteButtonAction: ( () -> () )?
    
    let posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .yellow
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        return posterImageView
    }()
    
    let titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.font = .boldSystemFont(ofSize: 20)
        titleLable.numberOfLines = 1
        return titleLable
    }()
    
    let directorLable: UILabel = {
        let directorLable = UILabel()
        directorLable.numberOfLines = 1
        return directorLable
    }()
    
    let castLable: UILabel = {
        let castLable = UILabel()
        castLable.numberOfLines = 1
        return castLable
    }()
    
    let rateLable: UILabel = {
        let rateLable = UILabel()
        return rateLable
    }()
    
    let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(systemName: SystemImage.star.rawValue), for: .normal)
        favoriteButton.tintColor = .lightGray
        return favoriteButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError()
    }
    
    func setupView() {
        addSubview(posterImageView)
        addSubview(titleLable)
        addSubview(directorLable)
        addSubview(castLable)
        addSubview(rateLable)
        addSubview(favoriteButton)
    }
    
    func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.82)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
            make.height.equalTo(30)
        }
        
        directorLable.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(4)
            make.leading.equalTo(titleLable.snp.leading)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        castLable.snp.makeConstraints { make in
            make.top.equalTo(directorLable.snp.bottom).offset(4)
            make.leading.equalTo(titleLable.snp.leading)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        rateLable.snp.makeConstraints { make in
            make.top.equalTo(castLable.snp.bottom).offset(4)
            make.leading.equalTo(titleLable.snp.leading)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func buttonConfig() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
    }
    
    @objc func favoriteButtonClicked() {
        favoriteButtonAction?()
    }
}
