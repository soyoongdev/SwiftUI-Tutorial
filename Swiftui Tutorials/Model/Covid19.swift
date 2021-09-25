//
//  Covid19.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 15/09/2021.
//

import SwiftUI

struct BeCome: Codable {
    let update: Update
}

struct Update: Codable {
    let total: Total
}

struct Total: Codable {
    let jumlah_positif: Int
    let jumlah_dirawat: Int
    let jumlah_sembuh: Int
    let jumlah_meninggal: Int
}

