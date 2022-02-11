//
//  CoursesViewController.swift
//  URlSessionApp
//
//  Created by User on 07.02.2022.
//

import UIKit

class CoursesViewController: UIViewController {
    private let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    
    private var modelCourses = [ModelCourses]()
    private var coursesName:String?
    private var coursesURL:String?

    @IBOutlet var tableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        courseLoadData()
        tableVIew.dataSource = self
        tableVIew.delegate = self
    }
    
    private func configureCell(cell:TableViewCell,for indexPath:IndexPath){
        let course = modelCourses[indexPath.row]
        
        cell.nameLabelCell.text = course.name
        
        if let numberOfLessons = course.numberOfLessons{
            cell.numberLabelCell.text = "Number of lessons - \(numberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests{
            cell.labelCell.text = "Number of tests - \(numberOfTests)"
        }
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageUrl!) else { return }
            guard let dataImage = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                cell.imageViewCell.image = UIImage(data: dataImage)
            }
        }
        
    }
}
extension CoursesViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewViewController
        webViewController.selectedCourse = coursesName
        if let url = coursesURL{
            webViewController.courseUrl = url
        }
    }
    func courseLoadData(){
        NetworkManager.fetchData(url) {[weak self] courses in
            self?.modelCourses = courses
            DispatchQueue.main.async {
                self?.tableVIew.reloadData()
            }
        }
    }
}
extension CoursesViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = modelCourses[indexPath.row]
        
        coursesURL = course.link
        coursesName = course.name
        
        performSegue(withIdentifier: "Description", sender: self)
    }
    
}

