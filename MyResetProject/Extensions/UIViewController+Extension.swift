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
    
    func showNetworkAlertCheck(check: Bool) {
        if !check {
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.openSettingScene()
            }
            self.presentAlert(title: "네트워크 연결 상태", message: "네트워크를 연결해주세요", alertActions: okAction)
        }
    }

}
