//
//  ContentView.swift
//  pracaMgr_Swift
//
//  Created by Damian Fra on 25/11/2020.
//  Copyright © 2020 Damian Fra. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showFetchData = false
    @State private var showCreateWriteReadFile = false
    @State private var showDatabase = false
    
    @State var results: [TaskEntry] = []
    @State var fileContent = ""
    @State var time = ""
    
    @State var resultsDb: [Person] = []
    
    func getElapsedTimeInSeconds(operation: () -> ()) -> String {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
        print("Czas wykonania: \(elapsedTime*1000) ms")
        return "Czas wykonania: \(elapsedTime*1000) ms"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Button(action: {self.showFetchData.toggle();
            })  {Text("Pobierz dane z API")}
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            Button(action: {self.showCreateWriteReadFile.toggle();
            })  {Text("Stwórz i wyświetl dane z pliku")}
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            Button(action: {self.showDatabase.toggle();
            })  {Text("Stwórz i pobierz dane z lokalnej bazy danych")}
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            
            Text(time)
            
            if showFetchData{
                List(results)   { x in
                    Text("UserId: \(x.userId), Id: \(x.id), Title: \(x.title), Completed: \(x.completed.description)")
                }
                .onAppear(){
                    self.time = self.getElapsedTimeInSeconds(operation: {ApiClient().fetchData { (results) in
                        self.results = results
                        }})
                }
            }
            
            if showCreateWriteReadFile {
                Text(fileContent).onAppear(){
                    self.time = self.getElapsedTimeInSeconds(operation: {FileUtils().createAndWriteFile{
                        (data) in self.fileContent = data
                        }})
                }
            }
            
            if showDatabase{
                List(resultsDb)   { x in
                    Text("Id: \(x.id), \(x.name) \(x.surname), Age: \(x.age)")
                }
                .onAppear(){
                    self.time = self.getElapsedTimeInSeconds(operation: {
                        let db:DBHelper = DBHelper()
                        self.resultsDb = db.read()
                    })
                }
            }
            
        }
    }    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().frame(alignment: .top)
    }
}
