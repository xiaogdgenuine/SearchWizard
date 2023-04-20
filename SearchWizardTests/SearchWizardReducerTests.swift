//
//  SearchWizardReducerTests.swift
//  SearchWizardTests
//
//  Created by xiaogd on 2023/4/20.
//

import XCTest
import ComposableArchitecture
import Dependencies
@testable import SearchWizard

@MainActor
final class SearchWizardReducerTests: XCTestCase {

    func testNavigationCase_RegionThenBedroomRanges() async throws {
        // GIVEN
        let store = TestStore(initialState: SearchWizardReducer.State(), reducer: SearchWizardReducer()) {
            $0.featureFlagRepository = FeatureFlagRepositoryMock(preDefinedNavigationCase: .regionThenBedroomRange)
            $0.searchWizardRepository = SearchWizardRepositoryMock()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.loadNavigationCase)

        // THEN
        await store.receive(.startSearching(byCase: .regionThenBedroomRange)) { $0.currentPage = .pickingRegion }
        await store.send(.navigateNext) { $0.currentPage = .pickingBedroomRanges }
        await store.send(.navigateNext) { $0.currentPage = .searchResult }
    }

    func testNavigationCase_BedroomRangesThenRegion() async throws {
        // GIVEN
        let store = TestStore(initialState: SearchWizardReducer.State(), reducer: SearchWizardReducer()) {
            $0.featureFlagRepository = FeatureFlagRepositoryMock(preDefinedNavigationCase: .bedroomRangeThenRegion)
            $0.searchWizardRepository = SearchWizardRepositoryMock()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.loadNavigationCase)

        // THEN
        await store.receive(.startSearching(byCase: .bedroomRangeThenRegion)) { $0.currentPage = .pickingBedroomRanges }
        await store.send(.navigateNext) { $0.currentPage = .pickingRegion }
        await store.send(.navigateNext) { $0.currentPage = .searchResult }
    }

}
