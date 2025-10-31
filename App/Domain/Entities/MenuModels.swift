//
//  MenuModels.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import Foundation

struct Menu: Codable {
    let id: Int?
    let active: Bool?
    let name: String?
    let isWebOrdering: Bool?
    let online: Bool?
    let merchantId: Int?
    let menuMenuCategories: [MenuMenuCategory]?
}

struct MenuMenuCategory: Codable, Identifiable {
    let id: Int
    let menuCategoryId: Int?
    let menuCategory: MenuCategory
}

struct MenuCategory: Codable {
    let id: Int
    let photoURL: String?
    let name: String
    let menuId: Int?
    let menuCategoryItems: [MenuCategoryItem]
}

struct MenuCategoryItem: Codable, Identifiable {
    let id: Int?
    let sequence: Int?
    let product: Product
}

struct Product: Codable {
    let id: Int
    let name: String?
    let photoURL: String?
    let productCategoryId: Int?
    let price: Double?
}
