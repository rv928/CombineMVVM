//
//  CarCellViewModel.swift
//  Cars
//
//  Created by Ravi Vora on 31/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import Combine

final class CarCellViewModel {
    
    @Published var title: String = ""
    @Published var dateTime: String = ""
    @Published var imageURL: String = ""
    @Published var description: String = ""
    
    private let car: Car
    
    init(car: Car) {
        self.car = car
        setUpBindings()
    }
    
    private func setUpBindings() {
        title = car.title
        dateTime = car.dateTime
        imageURL = car.image
        if car.content.count > 0 {
            description = car.content[0].description
        } else {
            description = ""
        }
        if car.dateTime != "" {
            // 25.12.2017 14:13
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            let date = dateFormatter.date(from: car.dateTime)
            
            // checking for same year condition
            let intervalYear = Date() - date!
            if (intervalYear.year ?? 0 == 0) {
                dateFormatter.dateFormat = "dd MMM, hh:mm a"
            } else {
                dateFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
            }
            let dateString:String = dateFormatter.string(from: date!)
            self.dateTime = dateString
            //25 December 2017, 02:13 PM
        } else {
            self.dateTime = ""
        }
    }
}
