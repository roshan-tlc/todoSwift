import Foundation
import SwiftUI
import SQLite

class ThemeTable {
    
    static let shared = ThemeTable()
    
    private var db: Connection?
    
    private init () {
        
        db = InitDataBase().getDb()
    }
    
    func createTable() {
        guard let db = db else { return }
        
        
        do {
            // try db.run("DROP TABLE Theme")
            try db.run("CREATE TABLE IF NOT EXISTS Theme (id INTEGER PRIMARY KEY AUTOINCREMENT, color TEXT, fontSize DOUBLE,fontFamily TEXT)")
            
        } catch {
            print("Error creating table: \(error)")
        }
    }
    
    func insert(theme: ApplicationTheme){
        guard let db = db else { return }
        let query = "INSERT INTO Theme (color, fontSize, fontFamily) values (?, ?, ?)"
        
        do {
            try db.run(query, theme.defaultColor.rawValue, Double(theme.fontSize.rawValue), theme.fontFamily.rawValue )
        } catch {
            print("error occured in inset query  \(error)")
        }
    }
    
    func updateColor(color:String) {
        guard let db = db else { return }
        
        let query = "UPDATE Theme SET color = ?"
        
        do {
            try db.run(query, color)
        } catch {
            print("error occured : \(error)")
        }
    }
    
    func updateFontSize(fontSize : Double) {
        guard let db = db else { return }
        
        let query = "UPDATE Theme SET fontSize = ?"
        
        do {
            try db.run(query, fontSize)
        } catch {
            print("error occured : \(error)")
        }
    }
    
    func updateFontFamily(fontFamily: String) {
        guard let db = db else { return }
        
        let query = "UPDATE Theme SET color = ?"
        
        do {
            try db.run(query, fontFamily)
            get()
        } catch {
            print("error occured : \(error)")
        }
    }
    
    func get() -> ApplicationTheme {
        guard let db = db else { return ApplicationTheme.shared }
        
        do {
            for row in try db.prepare("SELECT id, color, fontSize, fontFamily FROM Theme") {
                let id = row[0] as! Int64
                let color = row[1] as! String
                let fontSize = row[2] as! Double
                let fontFamily = row[3] as! String
                print(id, color,fontSize, fontFamily)
            }
        }catch {
            
        }
        return ApplicationTheme.shared
    }
    
    func getColor() -> String {
        guard let db = db else { return "" }
        
        let table = Table("Theme")
        let color = Expression<String>("color")
        
        do {
            if let row = try db.pluck(table) {
                let color = row[color]
                return color
            }
        } catch {
            print("Error fetching color from the database: \(error)")
        }
        
        return ""
    }
    
    func getFontSize() -> Double {
        guard let db = db else { return 0 }
        
        let table = Table("Theme")
        let font = Expression<Double>("fontSize")
        
        do {
            if let row = try db.pluck(table) {
                let fontSize = row[font]
                return fontSize
            }
        } catch {
            print("Error fetching color from the database: \(error)")
        }
        
        return 0
    }
    
    func getFontFamily() -> String? {
        guard let db = db else { return nil }
        
        let table = Table("Theme")
        let font = Expression<String>("fontFamily")
        
        do {
            if let row = try db.pluck(table) {
                let font = row[font]
                return font
            }
        } catch {
            print("Error fetching color from the database: \(error)")
        }
        
        return nil
    }
    
    func getFirstId() -> Int64? {
        guard let db = db else { return 0}
        
        let table = Table("Theme")
        let id = Expression<Int64> ("id")
        
        do  {
            if let row = try db.pluck(table) {
                let id = row[id]
                return id
            }
        } catch {
            print ("Error occured : \(error)")
        }
        return 0
    }
}
