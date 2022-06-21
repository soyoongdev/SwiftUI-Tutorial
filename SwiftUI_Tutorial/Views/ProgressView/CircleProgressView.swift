//
//  CircleProgressView.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 20/06/2022.
//

import SwiftUI

struct CircleProgressView: View {
    var body: some View {
        VStack() {
            CircularProgressView(progress: 0.55)
            
            CircularProgressView(progress: 0.85)
                .scaleEffect(0.75)
            
            Spacer()
        }
        .padding(20)
    }
}

struct CircularProgressView: View {
    var progress: Double
    
    var body: some View {
        let progressText = String(format: "%.0f%%", progress * 100)
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: CGFloat(self.progress))
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .overlay(
                    Text(progressText)
                        .foregroundColor(.blue)
                        .font(.system(size: 8))
                        .fontWeight(.heavy)
                        .rotationEffect(Angle(degrees: 90))
                )
        }
        .rotationEffect(Angle(degrees: -90))
        .frame(width: 48, height: 48)
        

    }
}

struct AnimateProgressView: View {
    init(isPresented: Binding<Bool>, progress: Binding<CGFloat>, complete: (() -> Void)? = nil, cancel: (() -> Void)? = nil) {
        self._isPresented = isPresented
        self._progress = progress
        self.complete = complete
        self.cancel = cancel
    }
    @Binding var isPresented: Bool
    @Binding var progress: CGFloat
    var complete: (() -> Void)?
    var cancel: (() -> Void)?
    
    var body: some View {
        if progress != 100 && isPresented {
            VStack(spacing: 20) {
                
                CircularProgressView(progress: self.progress / 100)
                    .padding(.horizontal, 40)
                    .onChange(of: self.progress) { _ in
                        DispatchQueue.main.async {
                            if progress >= 100 {
                                self.complete?()
                            }
                        }
                    }
                
                Button(action: {
                    self.cancel?()
                }) {
                    Text("Cancel")
                        .font(.body)
                        .foregroundColor(Color.blue)
                }
            }
            .padding(.vertical, 20)
            .blurView(style: .extraLight)
            .cornerRadius(8)
            .animation(.spring())
        }
    }
}

extension View {
    func animateProgressView(isPresented: Binding<Bool>, progress: Binding<CGFloat>, complete: (() -> Void)? = nil, cancel: (() -> Void)? = nil) -> some View {
        return self.overlay(
            AnimateProgressView(isPresented: isPresented, progress: progress, complete: complete, cancel: cancel)
        )
        .animation(.spring())
    }
}

struct DemoAnimateProgressView: View {
    @State var progress: CGFloat = 42.0
    @State var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            Button(action: {
                self.isPresented = true
            }){
                Text("Show alert")
            }
        }
        .animateProgressView(isPresented: $isPresented, progress: $progress, complete: complete, cancel: cancel)
    }
    
    func cancel() {
        self.isPresented = false
    }
    
    func complete() {
        print("Complete")
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            DemoAnimateProgressView()
        }
    }
}
