import SwiftUI

struct Theme: View {
    @EnvironmentObject var appTheme: ApplicationTheme
    @State var isToastVisible = false
    @State var toastMessage = ""

    @State var token: String

    var body: some View {
        List {
            VStack {
                HStack {
                    Text(Properties.fontFamily)
                            .font(Font.custom(appTheme.fontFamily.rawValue, size: appTheme.fontSize.rawValue))
                            .foregroundColor(.primary)

                    Spacer()

                    Picker("", selection: $appTheme.fontFamily) {
                        Text(Properties.fontFamilyCursive).tag(ApplicationTheme.FontFamily.CURSIVE)
                        Text(Properties.fontFamilyRoboto).tag(ApplicationTheme.FontFamily.ROBOTO)
                        Text(Properties.fontFamilyTimesNewRoman).tag(ApplicationTheme.FontFamily.TIMES_NEW_ROMAN)
                    }
                            .pickerStyle(MenuPickerStyle())
                }
                        .frame(height: 40)


                HStack {
                    Text(Properties.fontSize)
                            .font(Font.custom(appTheme.fontFamily.rawValue, size: appTheme.fontSize.rawValue))
                            .foregroundColor(.primary)

                    Spacer()

                    Picker("", selection: $appTheme.fontSize) {
                        Text(Properties.small).tag(ApplicationTheme.FontSize.small)
                        Text(Properties.medium).tag(ApplicationTheme.FontSize.medium)
                        Text(Properties.large).tag(ApplicationTheme.FontSize.large)
                    }
                            .pickerStyle(MenuPickerStyle())
                            .frame(height: 40)
                }

                HStack {
                    Text(Properties.color)
                            .font(Font.custom(appTheme.fontFamily.rawValue, size: appTheme.fontSize.rawValue))
                            .foregroundColor(.primary)

                    Spacer()

                    Picker("", selection: $appTheme.defaultColor) {
                        Text(ColorProperties.blue).tag(ApplicationTheme.DefaultColor.blue)
                        Text(ColorProperties.green).tag(ApplicationTheme.DefaultColor.green)
                        Text(ColorProperties.light).tag(ApplicationTheme.DefaultColor.light)
                    }
                            .pickerStyle(MenuPickerStyle())
                }
                        .frame(height: 40)
            }

        }

                .onDisappear {
                    let theme = ApplicationTheme.shared
                    SettingsAPI.shared.update(token: token, theme: theme) { result, error in
                        if let error = error {
                            toastMessage = "\(error)"
                            isToastVisible.toggle()
                        }
                    }
                }
                .toast(isPresented: $isToastVisible, message: $toastMessage)
    }
}
