//
//  DetailView.swift
//  MyResetProject
//
//  Created by bro on 2022/08/14.
//

import UIKit
import WebKit

import SnapKit

class DetailView: UIView {
    var infoView = InfoView()
    
    var webView: WKWebView = {
       let webView = WKWebView()
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        addSubview(infoView)
        addSubview(webView)
    }
    
    func setupConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}
