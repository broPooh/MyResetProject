//
//  BaseViewController.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import UIKit
import Network

struct NetworkManager {
    static let shared = NWPathMonitor()
}

class BaseViewController: UIViewController {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var checkNetworkValue = false {
        didSet {
            DispatchQueue.main.async {
                if !self.checkNetworkValue {
                    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                        self.openSettingScene()
                    }
                    self.presentAlert(title: "네트워크 연결 상태", message: "네트워크를 연결해주세요", alertActions: okAction)
                }
            }
        }
    }
    
    let networkMonitor = NetworkManager.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startNetworkMonitor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopNetworkMonitor()
    }

    func startNetworkMonitor() {
        networkMonitor.start(queue: DispatchQueue.global())
        networkMonitor.pathUpdateHandler = { path in
            self.checkNetworkValue = path.status == .satisfied ? true : false
        }
    }
    
    func stopNetworkMonitor() {
        networkMonitor.cancel()
    }
    
    func configure() {
        view.backgroundColor = .white
    }

}

