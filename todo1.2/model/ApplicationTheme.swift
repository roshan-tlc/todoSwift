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
    @Published var defaultColor : DefaultColor = .blue
    @State var theme = ThemeTable.shared
    
    static var shared = ApplicationTheme()
    
    private init(){
        
    }
    

    enum FontFamily: String {
        case CURSIVE = "Cursive"
        case BOLD = "HelveticaNeue-Bold"
        case TIMES_NEW_ROMAN = "TimesNewRoman"
        
        static func setValue( value: String) -> FontFamily {
            if value == "Cursive"{
                return .CURSIVE
            } else if value == "HelveticaNeue-Bold" {
                return .BOLD
            } else {
                return .TIMES_NEW_ROMAN
            }
        }
    }

    enum FontSize : CGFloat {
        case small = 14
        case medium = 18
        case large = 22
        
        static func setValue( value: CGFloat) -> FontSize {
                if value == FontSize.small.rawValue {
                    return .small
                } else if value == FontSize.medium.rawValue {
                    return .medium
                } else {
                    return .large
                }
            }
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
        
        func setValue(_ value : String) -> DefaultColor {
            if let color = DefaultColor(rawValue: value) {
                return color
            } else {
                print("invalid color")
            }
            return DefaultColor.light
        }
        
//        func toHex() -> String {
//            let uiColor = UIColor(ApplicationTheme.shared.getDefaultColor())
//
//              guard let components = uiColor.cgColor.components else {
//                  return ""
//              }
//
//              let red = Int(components[0] * 255.0)
//              let green = Int(components[1] * 255.0)
//              let blue = Int(components[2] * 255.0)
//
//              return String(format: "#%02X%02X%02X", red, green, blue)
//          }
    }
    
    func setFontFamily(fontFamily:String) {
        theme.updateFontFamily(fontFamily: fontFamily)
        self.fontFamily = FontFamily.setValue(value: theme.getFontFamily() ?? "")
    }
    
    func setFontSize(fontSize:ApplicationTheme.FontSize) {
        theme.updateFontSize(fontSize: fontSize.rawValue)
        self.fontSize = FontSize.setValue(value: theme.getFontSize())
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
    
    func update(withColor color: DefaultColor, fontSize: CGFloat, fontFamily: String) {
        self.defaultColor = color
        self.fontSize = FontSize.setValue(value: fontSize)
        self.fontFamily = FontFamily.setValue(value: fontFamily)
    }
    
}
