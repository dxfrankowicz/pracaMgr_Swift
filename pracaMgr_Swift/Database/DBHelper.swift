//
//  DBHelper.swift
//  pracaMgr_Swift
//
//  Created by Damian Fra on 30/11/2020.
//  Copyright © 2020 Damian Fra. All rights reserved.
// medium.com/@imbialhassan/saving-data-in-sqlite-db-in-ios-using-swift-4-76b743d3ce0e

import Foundation
import SQLite3

class DBHelper {
    
    let  dbPath: String = "myDb.sqlite"
    var db: OpaquePointer?
    let tableName: String = "personsTable"
    
    init() {
        db = openDatabase()
        dropTable()
        createTable()
        insertRowsToTable()
    }
    
    func insertRowsToTable() {
        for i in 1...100 {
            insert(id: i, name: "Name\(i)", surnmae: "Surname\(i)", age: Int.random(in: 1...100))
        }
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Blad przy tworzeniu bazy")
            return nil
        }
        else {
            print("Baza otwarta poprawnie w: \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableQuery = "create table \(tableName)(id INTEGER PRIMARY KEY, name TEXT, surname TEXT, age INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Tabela person utworzona")
            }
            else {
                print("Tabela person nie zostala utworzona")
            }
            sqlite3_finalize(createTableStatement)
        }
    }
    
    func insert(id: Int, name: String, surnmae: String, age: Int) {
        let persons = read()
        for p in persons {
            if p.id == id {
                return
            }
        }
        let insertQuery = "insert into \(tableName)(id, name, surname, age) values (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (surnmae as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(age))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Dodano rekord do bazy")
            }
            else {
                print("Nie dodano rekordu do bazy")
            }
        }
        else {
            print("Polecenie insert nie moglo byc wykonane")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Person] {
        let readQuery = "select * from \(tableName)"
        var readStatement: OpaquePointer? = nil
        var persons : [Person] = []
        
        if sqlite3_prepare_v2(db, readQuery, -1, &readStatement, nil) == SQLITE_OK {
            while sqlite3_step(readStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(readStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(readStatement, 1)))
                let surname = String(describing: String(cString: sqlite3_column_text(readStatement, 2)))
                let age = sqlite3_column_int(readStatement, 3)
                persons.append(Person(id: Int(id), name: name, surname: surname, age: Int(age)))
                print("Rezultat zapytania select: \(id) | \(name) | \(surname) | \(age)")
            }
        }
        else {
            print("Zapytanie select nie moglo byc wykonane")
        }
        sqlite3_finalize(readStatement)
        return persons
    }
    
    func deleteById(id: Int) {
        let deleteQuery = "delete from \(tableName) where id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Usunieto rekord do bazy")
            }
            else {
                print("Nie usunieto rekordu do bazy")
            }
        }
        else {
            print("Polecenie delete nie moglo byc wykonane")
        }
        sqlite3_finalize(deleteStatement)
        
    }
    
    func dropTable() {
        let dropQuery = "drop table \(tableName)"
        var dropStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, dropQuery, -1, &dropStatement, nil) == SQLITE_OK {
                        
            if sqlite3_step(dropStatement) == SQLITE_DONE {
                print("Usunieto tabele")
            }
            else {
                print("Nie usunieto tabeli")
            }
        }
        else {
            print("Polecenie drop nie moglo byc wykonane")
        }
        sqlite3_finalize(dropStatement)
        
    }
}
