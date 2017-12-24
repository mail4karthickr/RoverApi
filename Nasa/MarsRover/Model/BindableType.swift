//
//  BindableType.swift
//  Nasa
//
//  Created by karthick on 12/20/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit
import RxSwift

protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
