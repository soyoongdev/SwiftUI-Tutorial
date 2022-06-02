//
//  ActiveLabelView.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 25/05/2022.
//  https://github.com/optonaut/ActiveLabel.swift.git
//

import SwiftUI
import ActiveLabel

struct ActiveLabelView: UIViewRepresentable {
    init(text: String, enabledTypes: [ActiveType], selected: Binding<String>) {
        self.text = text
        self.enabledTypes = enabledTypes
        self._selected = selected
    }
    
    let text: String
    let enabledTypes: [ActiveType]
    @Binding var selected: String
    
    func makeUIView(context: Context) -> ActiveLabel {
        let label = ActiveLabel()
        label.customize { label in
            label.enabledTypes = self.enabledTypes
            label.text = self.text
            label.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
            label.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
            label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
            label.URLColor = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
            label.handleURLTap { url in
                self.selected = url.absoluteString
            }
            label.handleMentionTap { mess in
                self.selected = mess
            }
            label.handleHashtagTap { mess in
                self.selected = mess
            }
            label.handleEmailTap { mess in
                self.selected = mess
            }
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = UIScreen.main.bounds.width
            label.delegate = context.coordinator
            
        }
        return label
    }
    
    func updateUIView(_ label: ActiveLabel, context: Context) {
        context.coordinator.selected = self.selected
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selected: $selected)
    }
    
    class Coordinator: NSObject, ActiveLabelDelegate {
        init(selected: Binding<String>) {
            self._selected = selected
        }
        @Binding var selected: String
        
        func didSelect(_ text: String, type: ActiveType) {
            self.selected = text
        }
    }
}

struct DemoActiveLabel: View {
    @State private var text: String = "This is a post with #multiple #hashtags and a @user handle. I have an link SwiftUI: https://developer.apple.com/tutorials/swiftui"
    
    @State private var selected: String = ""
    
    var body: some View {
        VStack {
            ActiveLabelView(text: text, enabledTypes: [.hashtag, .mention, .url, .email, .custom(pattern: "\\swith\\b")], selected: $selected)
            
            Text("\(selected)")
                .font(.title2)
                .foregroundColor(.red)
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
    }
}

struct ActiveLabelView_Previews: PreviewProvider {
    static var previews: some View {
        DemoActiveLabel()
            .previewInterfaceOrientation(.portrait)
    }
}
