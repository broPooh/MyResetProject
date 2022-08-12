//
//  UIImageView+Extension.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(imageUrl: String) {
        self.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(systemName: SystemImage.star.rawValue)
        )
    }
}
