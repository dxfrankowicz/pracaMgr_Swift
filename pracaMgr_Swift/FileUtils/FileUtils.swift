//
//  FileUtils.swift
//  pracaMgr_Swift
//
//  Created by Damian Fra on 26/11/2020.
//  Copyright © 2020 Damian Fra. All rights reserved.
//

import Foundation

class FileUtils {
    
    func createAndWriteFile(completion: @escaping (String) -> ()) {
        let dateFormat = DateFormatter();
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = dateFormat.string(from: Date())
        let fileName = "test \(now)"
        let documentDirectoryUrl = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("File path \(fileUrl.path)")
        let dataToWrite = "Plik utworzony: \(now)"
        do {
            try dataToWrite.write(to: fileUrl, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print (error)
        }
        var readFile = "";
        do {
            readFile = try String(contentsOf: fileUrl)
        } catch let error as NSError {
            print(error)
        }
        completion(readFile)
        print (readFile)
    }
}
