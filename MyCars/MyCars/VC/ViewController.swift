//
//  ViewController.swift
//  MyCars
//
//  Created by Ivan Akulov on 08/02/20.
//  Copyright © 2020 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context:NSManagedObjectContext!
    
    var car:Car!
    
    lazy var dateFormatter:DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!{
        didSet{
            updateSegmentedControll()
            segmentedControl.selectedSegmentTintColor = .white
            
            let whiteTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            let blackTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
            
            UISegmentedControl.appearance().setTitleTextAttributes(whiteTextAttributes, for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes(blackTextAttributes, for: .selected)
        }
    }
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromFile()
        
    }
    
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
        updateSegmentedControll()
    }
    private func updateSegmentedControll(){
        let fetchRequest:NSFetchRequest<Car> = Car.fetchRequest()
        let mark = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        fetchRequest.predicate = NSPredicate(format:"mark == %@", mark as! CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            car = result.first
            insertDataFrom(selectedCar: car!)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
        car.timesDriven += 1
        car.lastStarted = Date()
        
        do {
            try context.save()
            insertDataFrom(selectedCar: car)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title: "Rate it", message: "Rate this car please", preferredStyle: .alert)
        let rateAction = UIAlertAction(title: "Rate", style: .default) {[weak self] action in
            guard let text = alertController.textFields?.first?.text else {return}
            
            self?.update(rating:(text as NSString).doubleValue)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { textfield in
            textfield.keyboardType = .numberPad
            textfield.placeholder = "rating number"
        }
        alertController.addAction(rateAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    private func update(rating rate:Double){
        car.rating = rate
        
        do {
            try context.save()
            
            insertDataFrom(selectedCar: car)
        } catch let error as NSError {
            let alertCOntroller = UIAlertController(title: "Wrong value", message: "Wrong Input", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertCOntroller.addAction(okAction)
            
            present(alertCOntroller, animated: true)
            print(error.localizedDescription)
        }
    }
    private func insertDataFrom(selectedCar car:Car){
        carImageView.image = UIImage(data: car.imageData!)
        markLabel.text = car.mark
        modelLabel.text = car.model
        myChoiceImageView.isHidden = !(car.myChoice)
        ratingLabel.text = "Rating \(car.rating)/10"
        numberOfTripsLabel.text = "Number of trips: \(car.timesDriven)"
        lastTimeStartedLabel.text = "Last time started: \(dateFormatter.string(from: car.lastStarted!))"
        segmentedControl.backgroundColor = car.tintColor as? UIColor
        
    }
    
    private func getDataFromFile(){
        let fetchRequest:NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: " mark != nil ")
        
        var records = 0
        
        do {
            records = try context.count(for: fetchRequest)
            print("It's ok")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
        
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist"),
              let array = NSArray(contentsOfFile: pathToFile) else { return }
        
        for dictionary in array{
            guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)else { return }
            let car = NSManagedObject(entity: entity, insertInto: context) as! Car
            
            let carDictionary = dictionary as! [String:AnyObject]
            
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            
            let imageName = carDictionary["imageName"] as? String
            guard let image = UIImage(named: imageName!) else { return }
            let imageData = image.pngData()
            car.imageData = imageData
            
            if let colorDictionary = carDictionary["tintColor"] as? [String:Float]{
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
            
            
        }
        
    }
    private func getColor(colorDictionary:[String:Float])->UIColor{
        guard let red = colorDictionary["red"], let blue = colorDictionary["blue"], let green = colorDictionary["green"] else {return UIColor()}
        let color = UIColor(displayP3Red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        
        return color
    }
    
    
    
}


