//
//  AppTheme.swift
//  todo1.2
//
//  Created by Krithik Roshan on 01/09/23.
//

import Foundation
import SwiftUI

class ApplicationTheme : ObservableObject {
    
    @Published var fontFamily:FontFamily = .CURSIVE
    @Published var fontSize : CGFloat = 14
    @Published var defaultColor : Color = .blue
    @State var theme:APISettings = APISettings()
    
    static var shared = ApplicationTheme()
    
    private init(){
        
    }
    enum FontSize : CGFloat {
        case small = 14
        case medium = 17
        case large = 20
        
    }

    enum FontFamily : String {
        case CURSIVE = "cursive"
        case TIMES_NEW_ROMAN = "TimesNewRoman"
        case ROBOTO = "roboto"
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

    func setFontFamilyValue(font:String) {
        switch font{
        case Properties.fontFamilyCursive :
            fontFamily = ApplicationTheme.FontFamily.CURSIVE
            break
        case Properties.fontFamilyTimesNewRoman :
            fontFamily = ApplicationTheme.FontFamily.TIMES_NEW_ROMAN
            break
        case Properties.fontFamilyRobodo :
            fontFamily = ApplicationTheme.FontFamily.ROBOTO
        default:
            fontFamily = ApplicationTheme.FontFamily.TIMES_NEW_ROMAN
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
    
    func setColorValue(_ value : String)  -> DefaultColor {
        if let color = DefaultColor(rawValue: value) {
            return color
        } else {
            return DefaultColor.blue
        }
    }
    
    
    func setFontSize(fontSize:CGFloat)  {
        self.fontSize = fontSize
    }
    
    func getFontSize() -> CGFloat {
        fontSize
    }
    
    func getFontFamily() -> FontFamily {
        fontFamily
    }

    func setTheme() {
        defaultColor =  Color(theme.color)
        setFontFamilyValue(font: theme.font_family)
        fontSize =  theme.font_size
    }
    
    func getTheme(token:String) {
        SettingsAPI.shared.get(token: token) { result in
            switch result {
            case .success(let Setting):
                self.theme = Setting
            case .failure(_):
                print("error")
            }
        }
        print(theme)
        setTheme()
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}


