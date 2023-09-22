//
//  AppTheme.swift
//  todo1.2
//
//  Created by Krithik Roshan on 01/09/23.
//

import Foundation
import SwiftUI

class ApplicationTheme : ObservableObject {
    
    @Published var fontFamily:String = "Cursive"
    @Published var fontSize : CGFloat = 16
    @Published var defaultColor : DefaultColor = .blue
    @State var theme:APISettings = APISettings()
    
    static var shared = ApplicationTheme()
    
    private init(){
        
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
    
    func setFontFamily(fontFamily:String)  {
        self.fontFamily = fontFamily
    }
    
    func setFontSize(fontSize:CGFloat)  {
        self.fontSize = fontSize
    }
    
    func setDefaultColor(color: ApplicationTheme.DefaultColor) throws {
        defaultColor = color
    }
    
    func getDefaultColor() -> Color {
        defaultColor.color
    }
    
    func getFontSize() -> CGFloat {
        fontSize
    }
    
    func getFontFamily() -> String {
        fontFamily
    }

    func setTheme() {
        defaultColor =  setColorValue(theme.color)
        setFontFamily(fontFamily: theme.font_family)
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
        setTheme()
    }
}
