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
        return String(format: "Czas wykonania:  %.2f ms", elapsedTime*1000)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            VStack(){
                Button(action: {
                    self.showFetchData = true
                    self.showDatabase = false
                    self.showCreateWriteReadFile = false
                })  {Text("Pobierz dane z API")
                    .multilineTextAlignment(.center)}
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
                Button(action: {
                    self.showFetchData = false
                    self.showDatabase = false
                    self.showCreateWriteReadFile = true
                })  {Text("Stwórz i wyświetl dane z pliku")
                    .multilineTextAlignment(.center)}
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
                Button(action: {
                    self.showFetchData = false
                    self.showDatabase = true
                    self.showCreateWriteReadFile = false
                })  {Text("Stwórz i pobierz dane z lokalnej bazy danych")
                    .multilineTextAlignment(.center)}
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                Text(time == "" ? "Czas operacji" : time)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            .frame(height: UIScreen.main.bounds.size.height/2)
            VStack(){
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
            .frame(height: UIScreen.main.bounds.size.height/2)
        }
        .padding(.vertical, 10.0)
    }    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().padding().frame(alignment: .top)
    }
}
