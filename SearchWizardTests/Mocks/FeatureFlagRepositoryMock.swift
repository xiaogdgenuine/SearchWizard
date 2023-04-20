//
//  FeatureFlagRepositoryMock.swift
//  SearchWizardTests
//
//  Created by xiaogd on 2023/4/20.
//

import XCTest
import Dependencies
@testable import SearchWizard

struct FeatureFlagRepositoryMock: FeatureFlagRepositoryProtocol {
    let preDefinedNavigationCase: SearchWizard.NavigationCase

    func getNavigationCase() async throws -> SearchWizard.NavigationCase {
        preDefinedNavigationCase
    }
}

