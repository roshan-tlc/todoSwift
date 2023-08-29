//
//  initDatabase.swift
//  todo1.2
//
//  Created by Krithik Roshan on 29/08/23.
//

import SwiftUI
import SQLite
import Foundation

class InitDataBase : Identifiable {
    
    private var db: Connection?
    
    init() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("myDatabase.sqlite")
            
            db = try Connection(fileURL.path)
        } catch {
            print("Error opening database: \(error)")
        }
    }
    
    func getDb() -> Connection? {
        return db
    }
}
