//
//  AppTheme.swift
//  todo1.2
//
//  Created by Krithik Roshan on 01/09/23.
//

import Foundation
import SwiftUI

class ApplicationTheme : ObservableObject {
    
    @Published var fontFamily :FontFamily = .CURSIVE
    @Published var fontSize : FontSize = .medium
    @Published var defaultColor : DefaultColor = .light
    @State var theme = ThemeTable.shared
    
    static var shared = ApplicationTheme()
    
    private init(){
        
    }
    

    enum FontFamily: String {
        case CURSIVE = "Cursive"
        case BOLD = "HelveticaNeue-Bold"
        case TIMES_NEW_ROMAN = "TimesNewRoman"
        
    }

    enum FontSize : CGFloat {
        case small = 14
        case medium = 18
        case large = 22
        
    }

    enum DefaultColor: String {
        case light = "light"
        case blue = "blue"
        case red = "red"
        case dark = "dark"
        
        var color: Color {
            switch self {
            case .light:
                return Color.secondary
            case .blue:
                return Color.blue
            case .red:
                return Color.red
            case .dark:
                return Color.black
            }
        }
    }
    
    func setFontFamily( value: String) -> FontFamily {
        if value == "Cursive"{
            return .CURSIVE
        } else if value == "HelveticaNeue-Bold" {
            return .BOLD
        } else {
            return .TIMES_NEW_ROMAN
        }
    }
    
    func setFontValue( value: CGFloat) -> FontSize {
            if value == FontSize.small.rawValue {
                return .small
            } else if value == FontSize.medium.rawValue {
                return .medium
            } else {
                return .large
            }
        }
    
    func setColorValue(_ value : String) -> DefaultColor {
        if let color = DefaultColor(rawValue: value) {
            return color
        } else {
            print("invalid color")
        }
        return DefaultColor.light
    }
    
    func setFontFamily(fontFamily:String) {
        theme.updateFontFamily(fontFamily: fontFamily)
        self.fontFamily = setFontFamily(value: fontFamily)
    }
    
    func setFontSize(fontSize:ApplicationTheme.FontSize) {
        theme.updateFontSize(fontSize: fontSize.rawValue)
        self.fontSize = fontSize
    }
    
    func setDefaultColor(color: ApplicationTheme.DefaultColor) {
        theme.updateColor(color: color.rawValue)
        self.defaultColor = color
    }
    
    func getDefaultColor() -> Color {
        defaultColor.color
    }
    
    func getFontSize() -> CGFloat {
        fontSize.rawValue
    }
    
    func getFontFamily() -> FontFamily {
        fontFamily
    }
    
//    func update(withColor color: DefaultColor, fontSize: CGFloat, fontFamily: String) {
//        self.defaultColor = color
//        self.fontSize = FontSize.setValue(value: fontSize)
//        self.fontFamily = FontFamily.setValue(value: fontFamily)
//    }
    
}
