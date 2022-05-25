//
//  HashTag2.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 25/05/2022.
//  Link example at: https://stackoverflow.com/questions/59624838/swiftui-tappable-subtext

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
    @Binding var data: [MentionPartViewModel]
    @State private var sheet: TagDisplay? = nil
    @State private var hashTagList = [String]()
    @State private var string: String = ""
    
    func font(_ string: String) -> Font {
        self.hashTagList.contains(string) ? .title2 : .body
    }
    
    func fontWeight(_ string: String) -> Font.Weight {
        self.hashTagList.contains(string) ? .bold : .regular
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                createText(maxWidth: geo.size.width)
                
                Text("\(self.hashTagList.description)")
                
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(item: $sheet) { item in
            Text(item.hashTag)
                .font(.title2)
                .foregroundColor(.red)
        }
        .onAppear() {
            self.getHashTagList()
        }
    }
    
    func createText(maxWidth: CGFloat) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        let stringArray = string.components(separatedBy: " ")
        
        return ZStack(alignment: .topLeading) {
            ForEach(stringArray, id: \.self) { item in
                Text(item + " ")
                    .font(font(item))
                    .fontWeight(fontWeight(item))
                    .onTapGesture { showSheet(item) }
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > maxWidth) {
                            width = 0
                            height -= dimension.height
                        }
                        
                        let result = width
                        if item == stringArray.last {
                            width = 0
                        }
                        else {
                            width -= dimension.width
                        }
                        
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if item == stringArray.last { height = 0 }
                        return result
                    })
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    func getHashTagList() {
        self.hashTagList.removeAll()
        self.string = ""
        for item in self.data {
            self.string += item.displayText
            if item.type == .MENTION {
                self.hashTagList.append(item.displayText)
            }
        }
        
    }
    
    func showSheet(_ s: String) {
        let index = self.data.firstIndex(where: {$0.displayText == s}) ?? 0
        if hashTagList.contains(s) {
            self.sheet = TagDisplay(self.data[index])
        }
    }
}

struct DemoHashTag: View {
    @State var partList: [MentionPartViewModel] = [
        MentionPartViewModel(type: .TEXT, displayText: "Hello my name is Hau, my hashtag is ", userId: 0),
        MentionPartViewModel(type: .MENTION, displayText: "@NGUYEN HUU HAU", userId: 1),
        MentionPartViewModel(type: .TEXT, displayText: ". There are four people in my family, My father, my mother, my sister and me. My father's hashtag is ", userId: 2),
        MentionPartViewModel(type: .MENTION, displayText: "@Hai", userId: 3),
        MentionPartViewModel(type: .TEXT, displayText: ", my mother's hashtag is ", userId: 4),
        MentionPartViewModel(type: .MENTION, displayText: "@Cuong", userId: 5),
        MentionPartViewModel(type: .TEXT, displayText: ", my siter's hashtag is ", userId: 6),
        MentionPartViewModel(type: .MENTION, displayText: "@Ngoc", userId: 7)
    ]
        
    var body: some View {
        HashTag2(data: $partList)
    }
}

struct DemoHashTag_Previews: PreviewProvider {
    static var previews: some View {
        DemoHashTag()
    }
}
