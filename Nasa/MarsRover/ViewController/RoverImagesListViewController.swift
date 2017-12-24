//
//  ViewController.swift
//  Nasa
//
//  Created by karthick on 12/15/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RxOptional
import Moya_ModelMapper
import AlamofireImage
import MaterialComponents
import RxGesture
import Action

class RoverImagesListViewController: UIViewController, BindableType {
    
    @IBOutlet weak var roverImages: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var showOrHideDatePicker: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    var viewModel: RoverImagesListViewModel!
    let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.backgroundColor = .red
    }
    
    func bindViewModel() {
        let imageUrls = showOrHideDatePicker.rx.tap.do(onNext:{
            self.datePicker.isHidden = !self.datePicker.isHidden
        })
        .map { self.datePicker.date }
        .flatMap { self.viewModel.getMarsRoverImageUrls(date: $0) }
        
        imageUrls.bind(to: self.roverImages.rx.items(cellIdentifier: "imageCell", cellType: ImageCell.self))
        {(row, element, cell) in
          //  cell.roverImage.rx.tapGesture().bind(onNext: viewModel.onOpenImage(image: cell.roverImage.image!))
            
            self.viewModel.getMarsRoverImages(imageUrl: element)
                .subscribeOn(self.globalScheduler)
                .asDriver(onErrorJustReturn: UIImage(named:"default"))
                .drive(cell.roverImage.rx.image)
                .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }

    func showError(marsRoverApiError: Error) {
        if let error = marsRoverApiError as? MarsRoverApiError {
            let message = MDCSnackbarMessage()
            message.text = error.errorMessage
            MDCSnackbarManager.show(message)
        }
    }
}

