//
//  UIViewController+Extension.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, style: UIAlertController.Style = .alert, alertActions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in alertActions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSettingScene() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
