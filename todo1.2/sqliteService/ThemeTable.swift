import Foundation
import SwiftUI
import SQLite

class ThemeTable {
    
    static let shared = ThemeTable()
    
    private var db: Connection?
    
    private init () {
        
        db = InitDataBase().getDb()
    }
    
    func createTable() throws {
        guard let db = db else { return }
        
        
        do {
            // try db.run(Properties.dropThemeTable)
            try db.run(DBTableProperties.createThemeTable)
            
        } catch {
            throw error
        }
    }
    
    func insert(theme: ApplicationTheme) throws {
        guard let db = db else { return }
        let query = DBTableProperties.insertThemeTable
        
//        do {
//            try db.run(query, theme.defaultColor as! Binding, Double(theme.fontSize), theme.fontFamily )
//        } catch {
//            throw error
//        }
    }
    
    func updateColor(color:String) throws {
        guard let db = db else { return }
        
        let query = DBTableProperties.updateThemeColor
        
        do {
            try db.run(query, color)
        } catch {
            throw error
        }
    }
    
    func updateFontSize(fontSize : Double) throws {
        guard let db = db else { return }
        
        let query = DBTableProperties.updateThemeFontSize
        
        do {
            try db.run(query, fontSize)
        } catch {
            throw error
        }
    }
    
    func updateFontFamily(fontFamily: String) throws {
        guard let db = db else { return }
        
        let query = DBTableProperties.updateThemeFontFamily
        
        do {
            try db.run(query, fontFamily)

        } catch {
            throw error
        }
    }
    
    func get() throws -> ApplicationTheme  {
        guard let db = db else { return ApplicationTheme.shared }
        
        do {
            for row in try db.prepare(DBTableProperties.getAppTheme) {
                let id = row[0] as! Int64
                let color = row[1] as! String
                let fontSize = row[2] as! Double
                let fontFamily = row[3] as! String
                print(id, color,fontSize, fontFamily)
            }
        } catch {
            throw error
        }
        return ApplicationTheme.shared
    }
    
    func getColor() throws  -> ApplicationTheme.DefaultColor {
        guard let db = db else { return ApplicationTheme.DefaultColor.green}
        
        let table = Table(DBTableProperties.themeTable)
        let color = Expression<String>(DBTableProperties.color)
        
        do {
            if let row = try db.pluck(table) {
                let color = row[color]
                
                let selectedColor = ApplicationTheme.shared.setColorValue(color)
                return selectedColor
            }
        } catch {
            throw error
        }
        
        return ApplicationTheme.DefaultColor.green
    }
    
    func getFontSize() throws -> ApplicationTheme.FontSize {
        guard let db = db else { return ApplicationTheme.FontSize.medium }
        
        let table = Table(DBTableProperties.themeTable)
        let font = Expression<Double>(DBTableProperties.fontSize)
        
        do {
            if let row = try db.pluck(table) {
                let fontSize = row[font]
                let fontValue = ApplicationTheme.shared.setFontValue(value: fontSize)
                return fontValue
            }
        } catch {
            throw error
        }
        
        return ApplicationTheme.FontSize.medium
    }
    
//    func getFontFamily() throws -> ApplicationTheme.FontFamily {
//        guard let db = db else { return ApplicationTheme.FontFamily.CURSIVE }
//        
//        let table = Table(DBProperties.themeTable)
//        let font = Expression<String>(DBProperties.fontFamily)
//        
//        do {
//            if let row = try db.pluck(table) {
//                let font = row[font]
//                let fontValue = ApplicationTheme.shared.setFontFamily(value: font)
//                return fontValue
//            }
//        } catch {
//            throw error
//        }
//        
//        return ApplicationTheme.FontFamily.CURSIVE
//    }
    
    func getFirstId() throws  -> Int64 {
        guard let db = db else { return 0}
        
        let table = Table(DBTableProperties.themeTable)
        let id = Expression<Int64> (DBTableProperties.id)
        
        do  {
            if let row = try db.pluck(table) {
                let id = row[id]
                return id
            }
        } catch {
            throw error
        }
        return 0
    }
}
