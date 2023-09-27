import SwiftUI

struct Theme: View {
    @EnvironmentObject var appTheme: ApplicationTheme
    @State var fontSize: ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily: ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor: ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
    @State var isToastVisible = false
    @State var toastMessage = ""
    
    @State var token:String
    
    var body: some View {
        List {
                HStack {
                    Text(Properties.fontFamily)
                        .font(Font.custom(appTheme.fontFamily.rawValue, size: fontSize.rawValue))
                            .foregroundColor(.primary)

                    Spacer()

                    Picker("", selection: $appTheme.fontFamily) {
                        Text(Properties.fontFamilyCursive).tag(ApplicationTheme.FontFamily.CURSIVE)
                        Text(Properties.fontFamilyRoboto).tag(ApplicationTheme.FontFamily.ROBOTO)
                        Text(Properties.fontFamilyTimesNewRoman).tag(ApplicationTheme.FontFamily.TIMES_NEW_ROMAN)
                    }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: fontFamily) { newValue in
                                //ApplicationTheme.shared.fontFamily = appTheme.fontFamily
                            }
                }
                        .frame(height: 40)
            

      
                HStack {
                    Text(Properties.fontSize)
                            .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                            .foregroundColor(.primary)

                    Spacer()

                    Picker("", selection: $fontSize) {
                        Text(Properties.small).tag(ApplicationTheme.FontSize.small)
                        Text(Properties.medium).tag(ApplicationTheme.FontSize.medium)
                        Text(Properties.large).tag(ApplicationTheme.FontSize.large)
                    }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: fontSize) { _ in
                                ApplicationTheme.shared.fontSize = fontSize
                            }
                            .frame(height: 40)
                

         
                    HStack {
                        Text(Properties.color)
                                .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                .foregroundColor(.primary)

                        Spacer()

                        Picker("", selection: $defaultColor) {
                            Text(Properties.blue).tag(ApplicationTheme.DefaultColor.blue)
                            Text(Properties.green).tag(ApplicationTheme.DefaultColor.green)
                            Text(Properties.light).tag(ApplicationTheme.DefaultColor.mint)
                        }
                        .pickerStyle(MenuPickerStyle())
                                .onChange(of: defaultColor) { newValue in
                                    ApplicationTheme.shared.defaultColor = defaultColor
                                }
                    }
                            .frame(height: 40)
                }
            
        }
                .onDisappear {
                    let theme = ApplicationTheme.shared
                    print("color",theme.defaultColor)
                    SettingsAPI.shared.update(token: token, theme: theme) { result, error  in
                        if let error = error {
                            print(error)
                            toastMessage = "\(error)"
                            isToastVisible.toggle()
                        }
                    }
                }
                .toast(isPresented: $isToastVisible, message: $toastMessage)
    }
    
}
