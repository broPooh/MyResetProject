//
//  SearchViewModel.swift
//  MyResetProject
//
//  Created by bro on 2022/08/12.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchViewModel {
    var disposeBag = DisposeBag()
    
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    
}
