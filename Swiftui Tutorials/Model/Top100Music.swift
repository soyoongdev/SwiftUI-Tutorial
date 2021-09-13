//
//  MusicModelView.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 13/09/2021.
//

import SwiftUI

struct Top100Music: Hashable, Codable {
    let id: Int
    let nameSinger: String
    let nameMusic: String
    let idType: Int
    let imageBanner: String
    let idCountry: Int
    let updatedAt: Date
}


class Top100MusicModelView: ObservableObject {
    
    let urlApiCall: String = "http://192.168.1.3:8080/php/top100music/topmusic.php?apicall=getAllMusic"
    
    func fetchApi() {
        guard let url = URL(string: "") else { return <#return value#> }
    }
}
