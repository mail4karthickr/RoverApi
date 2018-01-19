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
import MaterialComponents
import RxGesture
import Action
import RxAnimated
import RxSwiftExt

final class RoverImagesListViewController: UIViewController, BindableType {
    
    @IBOutlet weak var roverImages: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var showOrHideDatePicker: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    var viewModel: RoverImagesListViewModel!
    let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.backgroundColor = UIColor.white
    }
    
    func bindViewModel() {

        showOrHideDatePicker.rx.tap.subscribe(onNext: {
            self.viewModel.showDatePicker.execute(self.showOrHideDatePicker.title!)
        })
        .disposed(by: disposeBag)
        
        self.viewModel.datePickerIsHidden
            .asDriver()
            .drive(datePicker.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.viewModel.barButtonTitle
            .asDriver()
            .drive(showOrHideDatePicker.rx.title)
            .disposed(by: disposeBag)
        
        self.viewModel
            .showLoadingIndicator
            .asDriver()
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        let imageUrlsDownloaded = viewModel.startDownloadingImageUrls
            .asObservable()
            .filter { $0 }
            .flatMapLatest {_ in
            self.viewModel.getMarsRoverImageUrls(date: self.datePicker.date)
        }
        
        imageUrlsDownloaded
            .filter { $0.isFailure }
            .subscribe(onNext: {
                self.showError(marsRoverApiError: $0.error!)
            })
            .disposed(by: disposeBag)
       
        imageUrlsDownloaded
            .filter { $0.isSuccess }
            .map { $0.value ?? [] }
            .asDriver(onErrorJustReturn: [])
            .drive(self.roverImages.rx.items(cellIdentifier: "imageCell", cellType: ImageCell.self))
            {(row, element, cell) in
                cell.roverImage.rx.tapGesture().skip(1).map {
                        guard let imageView = $0.view as? UIImageView, let image = imageView.image else {
                            return UIImage(named:"default")!
                        }
                        return image
                    }
            .subscribe(self.viewModel.tapAction.inputs)
            .disposed(by: cell.disposeBag)
      
        let roverImage = self.viewModel.getMarsRoverImages(imageUrl: element)
            .materialize()
            .share()
        
        roverImage.elements()
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

