import SwiftUI

struct Theme: View {
    @EnvironmentObject var appTheme: ApplicationTheme
    @State var fontSize: ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily: ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor: ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
    @State var isToastVisible = false
    @State var toastMessage = ""
    @State var isLogout = false

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section {
                        Section {
                            HStack {
                                Text("Font Family")
                                        .padding()
                                        .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                        .foregroundColor(defaultColor.color)

                                Picker("", selection: $fontFamily) {
                                    Text("Cursive").tag(ApplicationTheme.FontFamily.CURSIVE)
                                    Text("HelveticaNeue-Bold").tag(ApplicationTheme.FontFamily.BOLD)
                                    Text("Times New Roman").tag(ApplicationTheme.FontFamily.TIMES_NEW_ROMAN)
                                }

                                        .pickerStyle(MenuPickerStyle())
                                        .accentColor(.primary)
                                        .padding()
                                        .onChange(of: fontFamily) { newValue in
                                            do {
                                                try ApplicationTheme.shared.setFontFamily(fontFamily: fontFamily.rawValue)
                                            } catch {
                                                toastMessage = "\(error)"
                                                isToastVisible.toggle()
                                            }
                                            ApplicationTheme.shared.fontFamily = fontFamily
                                        }
                            }
                        }

                        Section {
                            HStack {
                                Text("Font Size")
                                        .padding()
                                        .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                        .foregroundColor(defaultColor.color)

                                Picker("", selection: $fontSize) {
                                    Text("small").tag(ApplicationTheme.FontSize.small)
                                    Text("medium").tag(ApplicationTheme.FontSize.medium)
                                    Text("large").tag(ApplicationTheme.FontSize.large)
                                }
                                        .pickerStyle(MenuPickerStyle())
                                        .accentColor(.primary)
                                        .padding(.horizontal)
                                        .onChange(of: fontSize) { newValue in
                                            do {
                                                try ApplicationTheme.shared.setFontSize(fontSize: fontSize)
                                            } catch {
                                                toastMessage = "\(error)"
                                                isToastVisible.toggle()
                                            }
                                            ApplicationTheme.shared.fontSize = fontSize
                                        }
                            }
                        }
                                .frame(width: .infinity,height: 40)

                        Section {
                            HStack {
                                Text("Color")
                                        .padding()
                                        .font(Font.custom(fontFamily.rawValue, size: fontSize.rawValue))
                                        .foregroundColor(defaultColor.color)

                                Picker("", selection: $defaultColor) {
                                    Text("blue").tag(ApplicationTheme.DefaultColor.blue)
                                    Text("green").tag(ApplicationTheme.DefaultColor.green)
                                    Text("mint").tag(ApplicationTheme.DefaultColor.mint)
                                }
                                        .pickerStyle(MenuPickerStyle())
                                        .accentColor(.primary)
                                        .padding(.horizontal)
                                        .onChange(of: defaultColor) { newValue in
                                            do {
                                                try ApplicationTheme.shared.setDefaultColor(color: defaultColor)
                                            } catch {
                                                toastMessage = "\(error)"
                                            }
                                            ApplicationTheme.shared.defaultColor = defaultColor
                                        }
                            }
                        }
                                .frame(width: .infinity,height: 40)

                    }
                }
            }
                    .toast(isPresented:$isToastVisible , message: $toastMessage)
        }
    }
}
