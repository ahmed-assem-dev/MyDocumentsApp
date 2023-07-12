//
//  ExploringFileManagerApp.swift
//  ExploringFileManager
//
//  Created by Assem on 11/07/2023.
//

import SwiftUI

@main

struct ExploringFileManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(){
                    print("Launched")
                    let manager = FileManager.default
                    
                    guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{return}
                    
                    let newFilePath = url.appendingPathComponent("MyApp")
                    
                    
                    do{
                        try manager.createDirectory(at: newFilePath, withIntermediateDirectories: true, attributes: [:])
                    }
                    catch{
                        print(error)
                    }
                    
                }
        }
    }
}
