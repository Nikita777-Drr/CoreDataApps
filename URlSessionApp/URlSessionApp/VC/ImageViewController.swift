//
//  ViewController.swift
//  URlSessionApp
//
//  Created by User on 06.02.2022.
//

import UIKit

class ImageViewController: UIViewController {
    private let url = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }
    func fetchImage(){
        label.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.networkAction(url: url) {[weak self] (image) in
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
        }
        
        
    }
    
    

}


