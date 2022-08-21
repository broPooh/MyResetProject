//
//  NetworkMonitor.swift
//  MyResetProject
//
//  Created by bro on 2022/08/21.
//

import Foundation
import Network

final class NetworkMonitor {
    private init() { }
    static let shared = NetworkMonitor()
    
    let networkMonitor = NWPathMonitor()
    
    private let queue = DispatchQueue.global()
    var isConnected: Bool = false
    
    typealias Handler = (Bool) -> Void
    
    func startNetworkMonitor() {
        networkMonitor.start(queue: queue)
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied ? true : false
            //completion(path.status == .satisfied ? true : false)
        }
    }
    
    func stopNetworkMonitor() {
        networkMonitor.cancel()
    }
}
