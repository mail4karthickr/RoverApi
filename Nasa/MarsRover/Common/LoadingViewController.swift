//
//  LoadingViewController.swift
//  Nasa
//
//  Created by karthick on 12/24/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoadingViewController: UIViewController {

    @IBOutlet weak var activityMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let sharedInstance = LoadingViewController()
    
    let message = Variable<String>("Set your own loading message")
    let isHidden = Variable<Bool>(false)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.activityIndicatorViewStyle = .gray
        message.asDriver()
            .drive(activityMessage.rx.text)
            .disposed(by: disposeBag)
        isHidden.asDriver()
            .drive(self.view.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func show(withMessage message: String, onView superView: UIView) {
        superView.addSubview(self.view)
        self.message.value = message
        activityIndicator.startAnimating()
    }
    
    func hide() {
        self.view.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}

extension Reactive where Base: LoadingViewController {
    
}














