//
//  TextLabelWithHyperLink.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 25/05/2022.
//

import SwiftUI

struct TextLabelWithHyperLink2: UIViewRepresentable {
    
    @State var tintColor: UIColor
    
    @State var hyperLinkItems: Set<HyperLinkItem2>
    
    private var _attributedString: NSMutableAttributedString
    
    private var openLink: (HyperLinkItem2) -> Void
    
    init (
        tintColor: UIColor,
        string: String,
        attributes: [NSAttributedString.Key : Any],
        hyperLinkItems: Set<HyperLinkItem2>,
        openLink: @escaping (HyperLinkItem2) -> Void
    ) {
        self.tintColor = tintColor
        self.hyperLinkItems = hyperLinkItems
        self._attributedString = NSMutableAttributedString(
            string: string,
            attributes: attributes
        )
        self.openLink = openLink
    }
    
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.isEditable = false
        textView.isSelectable = true
        textView.tintColor = UIColor(.red)
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.tintColor = self.tintColor
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        for item in hyperLinkItems {
            let subText = item.subText
            let link = item.subText.replacingOccurrences(of: " ", with: "_")
            
            _attributedString
                .addAttribute(
                    .link,
                    value: String(format: "https://%@", link),
                    range: (_attributedString.string as NSString).range(of: subText)
                )
        }
        
        uiView.attributedText = _attributedString
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent : TextLabelWithHyperLink2
        
        init( parent: TextLabelWithHyperLink2 ) {
            self.parent = parent
        }
        
        func textView(
            _ textView: UITextView,
            shouldInteractWith URL: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction
        ) -> Bool {
            
            let strPlain = URL.absoluteString
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "_", with: " ")
            
            if let ret = parent.hyperLinkItems.first(where: { $0.subText == strPlain }) {
                parent.openLink(ret)
            }
            
            return false
        }
    }
}

struct HyperLinkItem2: Hashable {
    
    let subText : String
    let attributes : [NSAttributedString.Key : Any]?
    
    init (
        subText: String,
        attributes: [NSAttributedString.Key : Any]? = nil
    ) {
        self.subText = subText
        self.attributes = attributes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(subText)
    }
    
    static func == (lhs: HyperLinkItem2, rhs: HyperLinkItem2) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

struct DemoTextLabelWithHyperLink2: View {
    @State var sheetItem: String = ""
    
    var body: some View {
        VStack {
            TextLabelWithHyperLink(
                tintColor: .blue,
                string: "Please contact us by filling contact form. We will contact with you shortly.  Your request will be processed in accordance with the Terms of Use and Privacy Policy.",
                attributes: [:],
                hyperLinkItems: [
                    .init(subText: "processed"),
                    .init(subText: "Terms of Use"),
                ],
                openLink: {
                    (tappedItem) in
                    print("Tapped link: \(tappedItem.subText)")
                    self.sheetItem = tappedItem.subText
                }
            )
            
            Text(sheetItem.description)
                .font(.title2)
                .foregroundColor(Color.red)
        }
    }
}

struct TextLabelWithHyperLink2_Previews: PreviewProvider {
    static var previews: some View {
        DemoTextLabelWithHyperLink2()
    }
}
