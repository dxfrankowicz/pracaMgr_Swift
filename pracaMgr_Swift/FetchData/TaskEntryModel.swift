//
//  TaskEntryModel.swift
//  pracaMgr_Swift
//
//  Created by Damian Fra on 25/11/2020.
//  Copyright © 2020 Damian Fra. All rights reserved.
//

import Foundation

struct TaskEntry: Codable, Identifiable   {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
