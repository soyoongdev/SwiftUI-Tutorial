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
}
