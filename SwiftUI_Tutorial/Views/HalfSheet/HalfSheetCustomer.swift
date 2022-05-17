//
//  HalfSheet.swift
//  ThietThachClient
//
//  Created by Hau Nguyen on 14/12/2021.
//

import SwiftUI

struct HalfSheetHandle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}


struct HalfSheetCustomer<Content: View> : View {
    init
    (
        isPresented: Binding<Bool>,
        position: Binding<CardPosition>,
        content: @escaping () -> Content
    )
    {
        self._isPresented = isPresented
        self._position = position
        self.content = content()
    }
    
    @Binding private var isPresented: Bool
    @Binding private var position: CardPosition
    @GestureState private var dragState: DragState = .inactive
    private var content: Content
    @State private var startOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var middleOffset: CGFloat = 0
    @State private var radius: CGFloat = 0
    
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        return Group {
            HalfSheetHandle()
            self.content
                .onChange(of: self.isPresented) { newValue in
                    if newValue {
                        self.position = .middle
                    } else {
                        self.position = .bottom
                    }
                }
                .onChange(of: position) { newValue in
                    if newValue == .middle {
                        self.radius = 20
                    } else {
                        self.radius = 0
                    }
                }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height, alignment: .top)
        .background(
            Rectangle().fill(Color.white)
        )
        .cornerRadius(radius)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
//        .offset(y: self.position.rawValue + self.dragState.translation.height)
        .offset(y: getRestrictedYOffset(desiredOffset: self.position.rawValue + self.dragState.translation.height))
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        DispatchQueue.main.async {
            let verticalDirection = drag.predictedEndLocation.y - drag.location.y
            let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
            var positionAbove: CardPosition
            var positionBelow: CardPosition
            var closestPosition: CardPosition
            
            
            if cardTopEdgeLocation <= CardPosition.middle.rawValue {
                positionAbove = .top
                positionBelow = .middle
            } else {
                positionAbove = .middle
                positionBelow = .bottom
                self.isPresented = false
            }
            
            if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) {
                closestPosition = positionAbove
            } else {
                closestPosition = positionBelow
            }
            
            if verticalDirection > 0 {
                self.position = positionBelow
            } else if verticalDirection < 0 {
                self.position = positionAbove
            } else {
                self.position = closestPosition
            }
        }
        
    }
}

enum CardPosition: CGFloat {
    case top = 0
    case middle = 350
    case bottom = 1000
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

private func getRestrictedYOffset(desiredOffset: CGFloat) -> CGFloat {
    return max(CardPosition.top.rawValue, desiredOffset)
}
