//
//  ModelCourses.swift
//  URlSessionApp
//
//  Created by User on 07.02.2022.
//

import Foundation

struct ModelCourses:Codable{
    let id:Int?
    let name:String?
    let link:String?
    let imageUrl:String?
    let numberOfLessons:Int?
    let numberOfTests:Int?
}
