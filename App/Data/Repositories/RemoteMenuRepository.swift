//
//  RemoteMenuRepository.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

class RemoteMenuRepository: MenuRepository {

    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    public func loadMenu(merchantId: Int) async throws -> [Menu] {
        let url = Endpoint.merchant.url(.id("\(merchantId)"), .menu)
        let all = try await client.request([Menu].self, url: url)

        return all.filter {
            ($0.active ?? false) ||
            ($0.online ?? false) ||
            ($0.isWebOrdering ?? false)
        }
    }
}
