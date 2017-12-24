//
//  RoverImagesViewController.swift
//  Nasa
//
//  Created by karthick on 12/19/17.
//  Copyright © 2017 karthick. All rights reserved.
//

import UIKit

final internal class RoverImageViewController: UIViewController, BindableType {

    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: RoverImageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
    }
}


