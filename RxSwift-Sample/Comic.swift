//
//  Comic.swift
//  RxSwift-Sample
//
//  Created by 蜂谷庸正 on 2018/08/07.
//  Copyright © 2018年 Tsunemasa Hachiya. All rights reserved.
//

import Foundation

struct Comic {
    var num: Int?
    var img: String?
    var title: String?
    var alt: String?
    var date: Date?
    
    private var year: String?
    private var month: String?
    private var day: String?
    
    init(_ dist: [String: Any]) {
        num = dist["num"] as? Int
        img = dist["img"] as? String
        title = dist["title"] as? String
        alt = dist["alt"] as? String
        year = dist["year"] as? String
        month = dist["month"] as? String
        day = dist["day"] as? String
        
        guard let day = self.day, let month = self.month, let year = self.year else { return }
        
        var components = DateComponents()
        components.calendar = Calendar.current
        components.year = Int(year)
        components.month = Int(month)
        components.day = Int(day)
        date = components.date
    }
}
