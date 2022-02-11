//
//  MainCellCollectionViewController.swift
//  URlSessionApp
//
//  Created by User on 08.02.2022.
//

import UIKit

enum Actions:String, CaseIterable{
    case downloadImage = "Download Image"
    case get = "Get"
    case post = "Post"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
}

private let reuseIdentifier = "Cell"

class MainCellCollectionViewController: UICollectionViewController {
    
    //let actions = ["Download Image", "Get", "Post","Our Courses", "Upload Image" ]
    let actions = Actions.allCases

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.item].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.item]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            let url = "https://jsonplaceholder.typicode.com/posts"
            NetworkManager.createURLRequestGet(forURL: url)
        case .post:
            let url = "https://jsonplaceholder.typicode.com/posts"
            NetworkManager.createURLRequestPost(forURL: url)
        case .ourCourses:
            performSegue(withIdentifier: "ShowOurCourses", sender: self)
        case .uploadImage:
            print("Upload Image")
        }
    }

}
