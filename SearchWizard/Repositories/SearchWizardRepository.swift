//
//  SearchWizardRepository.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import Foundation
import Dependencies

protocol SearchWizardRepositoryProtocol {
    func getRegions() async throws -> [Region]
    func getBedroomRanges() async throws -> [BedroomRange]
}

struct SearchWizardRepository: SearchWizardRepositoryProtocol {
    func getRegions() async throws -> [Region] {
        try await Task.sleep(nanoseconds: 1000_000_000)
        return [
            .init(name: "Asia"),
            .init(name: "Europe"),
            .init(name: "North America"),
            .init(name: "South America"),
            .init(name: "Africa"),
            .init(name: "Oceania"),
            .init(name: "Antarctica")
        ]
    }

    func getBedroomRanges() async throws -> [BedroomRange] {
        try await Task.sleep(nanoseconds: 1000_000_000)
        return [
            .init(min: 1, max: 2),
            .init(min: 3, max: 5),
            .init(min: 5, max: 8),
            .init(min: 8, max: 12)
        ]
    }
}

// Register dependency
private enum SearchWizardRepositoryKey: DependencyKey {
    static let liveValue: SearchWizardRepositoryProtocol = SearchWizardRepository()
}

extension DependencyValues {
  var searchWizardRepository: SearchWizardRepositoryProtocol {
    get { self[SearchWizardRepositoryKey.self] }
    set { self[SearchWizardRepositoryKey.self] = newValue }
  }
}
