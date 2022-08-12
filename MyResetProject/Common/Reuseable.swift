//
//  Reuseable.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String {
        get
    }
}

protocol ViewRepresentable {
    func setupView()
    func setupConstraints()
}
