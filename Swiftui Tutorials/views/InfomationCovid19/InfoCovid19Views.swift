//
//  InfoCovid19Views.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 15/09/2021.
//

import SwiftUI

struct InfoCovid19Views: View {
    @StateObject var total = Covid19ViewModel()
    
    var body: some View {
        Text("\(total.covid.count)")
    }
}

struct InfoCovid19Views_Previews: PreviewProvider {
    static var previews: some View {
        InfoCovid19Views()
    }
}
