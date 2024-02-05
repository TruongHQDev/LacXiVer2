//
//  Extensions.swift
//  LacXiVer2
//
//  Created by Trường  on 1/20/24.
//

import Foundation
import SwiftUI

// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

extension Font {
    enum AzukiFont {
        case regular
        case custom(String)
        
        var value: String {
            switch self {
            case .regular:
                return "UTM-Azuki"
            case .custom(let name):
                return name
            }
        }
    }
    
    enum TektonFont {
        case regular
        case medium
        case bold
        case custom(String)
        
        var value: String {
            switch self {
            case .regular:
                return "TektonPro-Regular"
            case .medium:
                return "TektonPro-Medium"
            case .bold:
                return "TektonPro-Bold"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func titleFont(_ type: AzukiFont, size: CGFloat = 15) -> Font {
        return .custom(type.value, size: size)
    }
    
    static func appFont(_ type: TektonFont, size: CGFloat = 15) -> Font {
        return .custom(type.value, size: size)
    }
}

extension Color {
    public static let appDarkGreen = Color(hex: "#43766C")
    public static let appDarkBrown = Color(hex: "#76453B")
    public static let appLightBrown = Color(hex: "#B19470")
    public static let appBeige = Color(hex: "#F8FAE5")
    
    
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

extension View {
    func snapshot() -> UIImage? {
        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first,
            let view = keyWindow.rootViewController?.view else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, keyWindow.screen.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
