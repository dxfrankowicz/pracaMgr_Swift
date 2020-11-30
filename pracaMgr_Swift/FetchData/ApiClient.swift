//
//  ApiClient.swift
//  pracaMgr_Swift
//
//  Created by Damian Fra on 25/11/2020.
//  Copyright © 2020 Damian Fra. All rights reserved.
//

import Foundation

class ApiClient {
    func fetchData(completion: @escaping ([TaskEntry]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            print("Niepoprawny URL, błąd pobierania danych")
            return
        }
       
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let results = try! JSONDecoder().decode([TaskEntry].self, from: data!)
            DispatchQueue.main.async {
                completion(results)
            }
            //print(results)
        }
    .resume()
        
        
    }}
