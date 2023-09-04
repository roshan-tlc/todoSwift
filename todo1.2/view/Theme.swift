//
//  AppTheme.swift
//  todo1.2
//
//  Created by Krithik Roshan on 01/09/23.
//

import SwiftUI

struct Theme : View {
    @EnvironmentObject var appTheme : ApplicationTheme
    @State var fontSize : ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily : ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor : ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor

    var body: some View {
        VStack {
            HStack{
                Text("Font Family")
                    .padding()
                    .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                        .foregroundColor(defaultColor.color)
                Picker(selection: $fontFamily) {
                    Text("Cursive").tag(ApplicationTheme.FontFamily.CURSIVE)
                    Text("HelveticaNeue-Bold").tag(ApplicationTheme.FontFamily.BOLD)
                    Text("TimesNewRoman").tag(ApplicationTheme.FontFamily.TIMES_NEW_ROMAN)
                } label: {
                    HStack{
                        Text("picker")
                        Text("fontFamily")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                        .onChange(of: fontFamily) { newValue in
                            ApplicationTheme.shared.setFontFamily(fontFamily: fontFamily.rawValue)
                        }
            }
        }
        
        HStack{
            Text("Font Size")
                .padding()
                .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                    .foregroundColor(defaultColor.color)
            Picker(selection: $fontSize) {
                Text("small").tag(ApplicationTheme.FontSize.small)
                Text("medium").tag(ApplicationTheme.FontSize.medium)
                Text("large").tag(ApplicationTheme.FontSize.large)
            } label: {
                HStack{
                    Text("picker")
                    Text("fontSize")

                            .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                            .foregroundColor(defaultColor.color)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)

            .onChange(of: fontSize) { newValue in
                ApplicationTheme.shared.setFontSize(fontSize: fontSize)
            }
            
        }
        
        HStack{
            Text("Default Color")
                .padding()
                    .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                    .foregroundColor(defaultColor.color)
            Picker(selection: $defaultColor) {
                Text("light").tag(ApplicationTheme.DefaultColor.light)
                Text("blue").tag(ApplicationTheme.DefaultColor.blue)
                Text("red").tag(ApplicationTheme.DefaultColor.red)
                Text("black").tag(ApplicationTheme.DefaultColor.dark)
            } label: {
                HStack{
                    Text("picker")
                    Text("color")
                        .foregroundColor(.white)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
            
            .onChange(of: defaultColor) { newValue in
                ApplicationTheme.shared.setDefaultColor(color: defaultColor)
            }

        }
        Spacer()
    }
}



