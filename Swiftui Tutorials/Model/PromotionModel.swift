//
//  PromotionModel.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 17/09/2021.
//

import Foundation
import SwiftUI

public struct PromotionModel: Codable {
    public var id = UUID().uuidString
    public var productId: Int8
    public var postId: Int8
    public var vendorId: Int8
    public var productName: String
    public var productStatus: Int8
    public var voucherType: Int8
    public var quantity: Int8
    public var price: CGFloat
    public var expiredDate: String
    public var vendorName: String
    public var postContent: String
    public var postFeaturedImage: String
    public var postFeaturedImageId: Int8
    public var usedQuantity: String
}
