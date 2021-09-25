//
//  HouseTemplate.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 15/09/2021.
//

import Foundation
import SwiftUI

// Wellcome..
struct ThietThachModel: Codable {
    var items: Item
    var total: Int8
    var errorCode: String
    var errorMessage: String
}

struct Item: Codable {
    var postTaxonomyObject: PostTaxonomyObject
}

struct PostTaxonomyObject: Codable {
    var id: Int8? { return postTaxonomyId }
    var postTaxonomyId: Int8
    var postTaxonomyName: String
    var postType: Int8
    var postTaxonomyStatus: Int8
    var postTaxonomyOrder: Int8
    var createdDate: String
    var postCates: PostCateModel
}

struct PostCateModel: Codable {
    var id: Int8? { return postCateId }
    var postCateId: Int8
    var postCateName: String
    var postCateParentName: String
    var postCateIcon: String
    var postCateStatus: Int8
    var postCateType: Int8
    var postTaxonomyId: Int64
}

