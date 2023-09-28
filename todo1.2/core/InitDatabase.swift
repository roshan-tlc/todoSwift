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
    static var shared = InitDataBase()
    
    init() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(DBTableProperties.filePath)
            
            db = try Connection(fileURL.path)
        } catch {
            db = nil
        }
    }
    
    func getDb() -> Connection? {
        db
    }

    enum dbError : Error {
        case invalidData
    }
}
