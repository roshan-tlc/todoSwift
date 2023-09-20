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
            try db.run(DBProperties.createThemeTable)
            
        } catch {
            throw error
        }
    }
    
    func insert(theme: ApplicationTheme) throws {
        guard let db = db else { return }
        let query = DBProperties.insertThemeTable
        
        do {
            try db.run(query, theme.defaultColor.rawValue, Double(theme.fontSize.rawValue), theme.fontFamily.rawValue )
        } catch {
            throw error
        }
    }
    
    func updateColor(color:String) throws {
        guard let db = db else { return }
        
        let query = DBProperties.updateThemeColor
        
        do {
            try db.run(query, color)
        } catch {
            throw error
        }
    }
    
    func updateFontSize(fontSize : Double) throws {
        guard let db = db else { return }
        
        let query = DBProperties.updateThemeFontSize
        
        do {
            try db.run(query, fontSize)
        } catch {
            throw error
        }
    }
    
    func updateFontFamily(fontFamily: String) throws {
        guard let db = db else { return }
        
        let query = DBProperties.updateThemeFontFamily
        
        do {
            try db.run(query, fontFamily)

        } catch {
            throw error
        }
    }
    
    func get() throws -> ApplicationTheme  {
        guard let db = db else { return ApplicationTheme.shared }
        
        do {
            for row in try db.prepare(DBProperties.getAppTheme) {
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
        
        let table = Table(DBProperties.themeTable)
        let color = Expression<String>(DBProperties.color)
        
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
        
        let table = Table(DBProperties.themeTable)
        let font = Expression<Double>(DBProperties.fontSize)
        
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
    
    func getFontFamily() throws -> ApplicationTheme.FontFamily {
        guard let db = db else { return ApplicationTheme.FontFamily.CURSIVE }
        
        let table = Table(DBProperties.themeTable)
        let font = Expression<String>(DBProperties.fontFamily)
        
        do {
            if let row = try db.pluck(table) {
                let font = row[font]
                let fontValue = ApplicationTheme.shared.setFontFamily(value: font)
                return fontValue
            }
        } catch {
            throw error
        }
        
        return ApplicationTheme.FontFamily.CURSIVE
    }
    
    func getFirstId() throws  -> Int64 {
        guard let db = db else { return 0}
        
        let table = Table(DBProperties.themeTable)
        let id = Expression<Int64> (DBProperties.id)
        
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
