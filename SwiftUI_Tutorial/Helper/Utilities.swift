//
//  Utilities.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 19/06/2022.
//
//

import SwiftUI

// MARK: - Utilities

public var noImage: String = "https://images.indianexpress.com/2022/06/Apple-WWDC-20221.jpg"

public class Utilities {
    public static func setRotationDevice(to orientation: UIInterfaceOrientationMask) {
        AppDelegate.orientationLock = orientation
    }
    
    public static func changeRotationDevice(to orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    // Example:
//    textWithHashtags("Here's a quick and easy way to include #hashtag formatting in your #SwiftUI Text Views. Learn how in the #Tutorial here.", color: .red)
//        .font(Font.custom("Avenir Next", size: 20))
//        .bold()
    public static func textWithHashtags(_ text: String, color: Color) -> Text {
        let words = text.split(separator: " ")
        var output: Text = Text("")

        for word in words {
            if word.hasPrefix("#") { // Pick out hash in words
                output = output + Text(" ") + Text(String(word))
                    .foregroundColor(color) // Add custom styling here
            } else {
                output = output + Text(" ") + Text(String(word))
            }
        }
        return output
    }
}
