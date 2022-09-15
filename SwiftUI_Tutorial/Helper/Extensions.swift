//
//  Extensions.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 09/06/2022.
//

import SwiftUI

// MARK: - Extension String

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public extension String {
    func parseURL() -> URL {
        let this = self
        let url = URL(string: this.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) ?? URL(string:String(noImage).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        return url
    }
}

// MARK: - Extension View

extension View {
    func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
        self.modifier(MeasureSizeModifier())
            .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
    
    func animation(_ animation: Animation? = .default) -> some View {
        self.animation(animation, value: UUID())
    }
}

// MARK: - Extension ViewModifier

extension ViewModifier {
    func readSize(rect: Binding<CGRect>) -> GeometryGetterMod {
        return .init(rect: rect)
    }
}

// MARK: - Extension URL
extension URL {
    func fileSizeInMB() -> String {
        let p = self.path
        
        let attr = try? FileManager.default.attributesOfItem(atPath: p)
        
        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1024.0 * 1024.0)
            
            return String(format: "%.2f MB", fileSize)
        } else {
            return "Failed to get size"
        }
    }
}


// MARK: - Make function get frame size of swiftui view..

// MARK:  Solution 1
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct MeasureSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self,
                                   value: geometry.size)
        })
    }
}


// MARK:  Solution 2
struct GeometryGetterMod: ViewModifier {
    init(rect: Binding<CGRect>) {
        self._rect = rect
    }
    @Binding var rect: CGRect
    
    func body(content: Content) -> some View {
        print(content)
        return GeometryReader { (g) -> Color in // (g) -> Content in - is what it could be, but it doesn't work
            DispatchQueue.main.async { // to avoid warning
                self.rect = g.frame(in: .global)
            }
            return Color.clear // return content - doesn't work
        }
    }
}


