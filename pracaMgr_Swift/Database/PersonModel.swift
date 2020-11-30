//
//  PersonModel.swift
//  pracaMgr_Swift
//
//  Created by Damian Fra on 30/11/2020.
//  Copyright © 2020 Damian Fra. All rights reserved.
//

import Foundation

class Person : Identifiable {
    var id: Int = 0
    var name: String = ""
    var surname: String = ""
    var age: Int = 0
    
    init(id: Int, name: String, surname: String, age: Int) {
        self.id = id
        self.name = name
        self.surname = surname
        self.age = age
    }
}
