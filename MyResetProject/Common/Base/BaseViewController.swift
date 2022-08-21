//
//  BaseViewController.swift
//  MyResetProject
//
//  Created by bro on 2022/08/11.
//

import UIKit
import Network

struct NetworkManager {
    private init() { }
    static let shared = NWPathMonitor()
}

class BaseViewController: UIViewController {

    var checkNetworkValue = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showNetworkAlert(check: self.checkNetworkValue)
            }
        }
    }
    
    let networkMonitor = NetworkManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startNetworkMonitor()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopNetworkMonitor()
    }
    
    func startNetworkMonitor() {
        networkMonitor.start(queue: DispatchQueue.global())
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.checkNetworkValue = path.status == .satisfied ? true : false
        }
    }
    
    func stopNetworkMonitor() {
        networkMonitor.cancel()
    }
    
    func configure() {
        view.backgroundColor = .white
    }
    
    func showNetworkAlert(check: Bool) {
        if !check {
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.openSettingScene()
            }
            self.presentAlert(title: "네트워크 연결 상태", message: "네트워크를 연결해주세요", alertActions: okAction)
        }
    }

}

