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
    @Published var fontSize :FontSize = .medium
    @Published var defaultColor : DefaultColor = .blue
    @State var theme:APISettings = APISettings()
    
    static var shared = ApplicationTheme()
    
    private init(){

    }
    enum FontSize : CGFloat {
        case small = 12
        case medium = 14
        case large = 16
        
    }

    enum FontFamily : String {
        case CURSIVE = "cursive"
        case TIMES_NEW_ROMAN = "timesNewRoman"
        case ROBOTO = "roboto"
    }

    enum DefaultColor: String {
        case blue = "blue"
        case green = "green"
        case mint = "dark"
        case light = "light"
        
        var color: Color {
            switch self {
            case .blue:
                return Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.9, alpha: 1.0))
            case .green:
                return Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.5, alpha: 1.0))
            case .mint:
                return Color.mint
            case .light:
                return Color.white
            }
        }
    }

    func setFontFamilyValue(font:String) -> FontFamily {
        switch font{
        case Properties.fontFamilyCursive :
            return ApplicationTheme.FontFamily.CURSIVE
        case Properties.fontFamilyTimesNewRoman :
            return ApplicationTheme.FontFamily.TIMES_NEW_ROMAN
        case Properties.fontFamilyRoboto :
            return ApplicationTheme.FontFamily.ROBOTO
        default:
            return ApplicationTheme.FontFamily.TIMES_NEW_ROMAN
        }
    }
    
    func setFontValue(value: CGFloat) -> FontSize {
            if value < 15 {
                return .small
            } else if value < 18  {
                return .medium
            } else {
                return .large
            }
        }
    
    func setColorValue(_ value : String)  -> DefaultColor {
        if let color = DefaultColor(rawValue: value) {

            return color
        } else {
            return DefaultColor.light
        }
    }
    
    
    func getFontSize() -> FontSize {
        fontSize
    }
    
    func getFontFamily() -> FontFamily {
        fontFamily
    }
    
    func getTheme(token:String) {
        SettingsAPI.shared.get(token: token) { result in
            switch result {
            case .success(let setting):
                self.theme = setting
                self.fontSize = self.setFontValue(value: setting.font_size)
                self.fontFamily = self.setFontFamilyValue(font: setting.font_family)
                self.defaultColor = self.setColorValue(setting.color)
            case .failure(_):
                self.theme = self.theme
            }
        }
    }
}

extension Color {
    init?(hex: String) {
        let value = "#\(hex)"
        var hexSanitized = value.trimmingCharacters(in: .whitespacesAndNewlines)
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


