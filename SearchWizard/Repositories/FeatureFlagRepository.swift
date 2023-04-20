//
//  FeatureFlagRepository.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import Foundation
import Dependencies

protocol FeatureFlagRepositoryProtocol {
    func getNavigationCase() async throws -> NavigationCase
}

struct FeatureFlagRepository: FeatureFlagRepositoryProtocol {
    var navigationCaseFlag = NavigationCase.bedroomRangeThenRegion

    func getNavigationCase() async throws -> NavigationCase {
        try await Task.sleep(nanoseconds: 300_000_000)

        return .bedroomRangeThenRegion
    }
}

// Register dependency
enum FeatureFlagRepositoryKey: DependencyKey {
    static let liveValue: FeatureFlagRepositoryProtocol = FeatureFlagRepository()
}

extension DependencyValues {
  var featureFlagRepository: FeatureFlagRepositoryProtocol {
    get { self[FeatureFlagRepositoryKey.self] }
    set { self[FeatureFlagRepositoryKey.self] = newValue }
  }
}
