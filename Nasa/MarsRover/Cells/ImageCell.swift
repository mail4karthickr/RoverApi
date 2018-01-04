//
//  ImageCell.swift
//  Nasa
//
//  Created by karthick on 12/16/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit
import RxSwift

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var roverImage: UIImageView!
    let disposeBag = DisposeBag()
}
