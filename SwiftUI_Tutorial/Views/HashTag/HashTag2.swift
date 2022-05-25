//
//  HashTag2.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 25/05/2022.
//

import SwiftUI

enum EMentionPartType : Int8, Codable {
    case TEXT = 0
    case MENTION = 1
}

struct MentionPartViewModel: Codable {
    public var type: EMentionPartType = .TEXT
    public var displayText: String = ""
    public var userId: Int64 = 0
}

struct TagDisplay: Codable, Identifiable {
    init(_ data: MentionPartViewModel) {
        self.userId = data.userId
        self.hashTag = data.displayText
    }
    var id: Int64 {
        return userId
    }
    var userId: Int64 = 0
    var hashTag: String = ""
}

struct HashTag2: View {
    @State var sheet: TagDisplay? = nil
    @Binding var partList: [MentionPartViewModel]
    @Binding var hashTagList: [String]
    
    func fontWeight(_ string: String) -> Font.Weight {
        hashTagList.contains(string) ? .bold : .regular
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                createText(maxWidth: geo.size.width)
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(item: $sheet) { item in
            Text(item.hashTag)
                .font(.title2)
                .foregroundColor(.red)
        }
    }
    
    var partLast: MentionPartViewModel {
        return partList[(partList.count - 1)]
    }
    
    func createText(maxWidth: CGFloat) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero        
        
        return VStack(alignment: .leading) {
            ForEach(partList, id: \.userId) { item in
                Text(item.displayText + " ")
                    .font(.body)
                    .fontWeight(fontWeight(item.displayText))
                    .onTapGesture { showSheet(item) }
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > maxWidth) {
                            width = 0
                            height -= dimension.height
                        }
                        
                        let result = width
                        if partLast.displayText == item.displayText {
                            width = 0
                        }
                        else {
                            width -= dimension.width
                        }
                        
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if partLast.displayText == partList[0].displayText { height = 0 }
                        return result
                    })
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    func showSheet(_ part: MentionPartViewModel) {
        if hashTagList.contains(part.displayText) {
            self.sheet = TagDisplay(part)
        }
    }
}

struct DemoHashTag: View {
    @State var partList: [MentionPartViewModel] = [
        MentionPartViewModel(type: .TEXT, displayText: "Hello my name is Hau, my hashtag is  ", userId: 0),
        MentionPartViewModel(type: .MENTION, displayText: "@NGUYEN HUU HAU", userId: 1),
        MentionPartViewModel(type: .TEXT, displayText: ". There are four people in my family, My father, my mother, my sister and me. My father's hashtag is ", userId: 2),
        MentionPartViewModel(type: .MENTION, displayText: "@Hai", userId: 3),
        MentionPartViewModel(type: .TEXT, displayText: ", my mother's hashtag is ", userId: 4),
        MentionPartViewModel(type: .MENTION, displayText: "@Cuong", userId: 5),
        MentionPartViewModel(type: .TEXT, displayText: ", my siter's hashtag is ", userId: 6),
        MentionPartViewModel(type: .MENTION, displayText: "@Ngoc", userId: 7)
    ]
    
    @State var hashTagList: [String] = ["@Hai", "@Cuong", "@Ngoc", "@NGUYEN HUU HAU"]
    
    var body: some View {
        HashTag2(partList: $partList, hashTagList: $hashTagList)
    }
}

struct DemoHashTag_Previews: PreviewProvider {
    static var previews: some View {
        DemoHashTag()
    }
}
