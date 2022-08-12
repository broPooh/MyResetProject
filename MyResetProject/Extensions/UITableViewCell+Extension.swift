//
//  UITableViewCell+Extension.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import UIKit

extension UITableViewCell: Reusable {
   static var reuseIdentifier: String {
        return String(describing: self)
    }
}
