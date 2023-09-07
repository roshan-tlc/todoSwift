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
        
    }

    enum FontSize : CGFloat {
        case small = 14
        case medium = 17
        case large = 20
        
    }

    enum DefaultColor: String {
        case blue = "blue"
        case green = "green"
        case mint = "dark"
        
        var color: Color {
            switch self {
            case .blue:
                return Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.9, alpha: 1.0))
            case .green:
                return Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.5, alpha: 1.0))
            case .mint:
                return Color.mint
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
        return DefaultColor.blue
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
        defaultColor = color
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
    
}
