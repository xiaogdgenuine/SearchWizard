//
//  SearchWizardReducer.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies

struct SearchWizardReducer: ReducerProtocol {
    @Dependency(\.featureFlagRepository) var featureFlagRepository
    @Dependency(\.searchWizardRepository) var searchWizardRepository

    struct State: Equatable {
        var navigationPath = NavigationPath()
        var navigationCaseState = RequestState<NavigationCase>.intialized
        var currentPage = SearchWizardPage.pickingRegion

        var regionsState = RequestState<[Region]>.intialized
        var bedroomRangesState = RequestState<[BedroomRange]>.intialized
        var regions: [Region] = []
        var bedroomRanges: [BedroomRange] = []

        var selectedRegion: Region?
        var selectedBedroomRange: BedroomRange?
    }

    enum Action: Equatable {
        // Routing
        case startSearching(byCase: NavigationCase)
        case navigateNext
        case updateNavigationPath(NavigationPath)
        case updateCurrentPage(SearchWizardPage)

        // Data fetching
        case loadNavigationCase
        case loadRegions
        case loadBedroomRanges
        case navigationCaseLoaded(RequestState<NavigationCase>)
        case regionsLoaded(RequestState<[Region]>)
        case bedroomRangesLoaded(RequestState<[BedroomRange]>)

        // User input
        case toggleNavigationCase
        case chooseRegion(Region?)
        case chooseBedroomRange(BedroomRange?)
    }

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        // Routing
        case .startSearching(let navigationCase):
            switch navigationCase {
            case .regionThenBedroomRange:
                state.currentPage = .pickingRegion
                state.navigationPath.append(SearchWizardPage.pickingRegion)
            case .bedroomRangeThenRegion:
                state.currentPage = .pickingBedroomRanges
                state.navigationPath.append(SearchWizardPage.pickingBedroomRanges)
            }
        case .navigateNext:
            guard let navigationCase = state.navigationCaseState.result else {
                return .none
            }

            // Navigate to next screen base on A/B testing flag
            switch navigationCase {
            case .regionThenBedroomRange where state.currentPage == .pickingRegion:
                state.currentPage = .pickingBedroomRanges
            case .bedroomRangeThenRegion where state.currentPage == .pickingBedroomRanges:
                state.currentPage = .pickingRegion
            default:
                state.currentPage = .searchResult
            }
            state.navigationPath.append(state.currentPage)
        case .updateNavigationPath(let path):
            state.navigationPath = path
        case .updateCurrentPage(let page):
            state.currentPage = page

        // Data fetching
        case .loadNavigationCase:
            state.navigationCaseState = .loading
            return .task {
                .navigationCaseLoaded(await RequestState.getResult(provider: featureFlagRepository.getNavigationCase))
            }
        case .navigationCaseLoaded(let requestResult):
            state.navigationCaseState = requestResult
            if let byCase = state.navigationCaseState.result {
                return .task { .startSearching(byCase: byCase) }
            }
        case .loadRegions:
            state.regionsState = .loading
            return .task {
                .regionsLoaded(await RequestState.getResult(provider: searchWizardRepository.getRegions))
            }
        case .regionsLoaded(let regionsState):
            state.regionsState = regionsState
            state.regions = regionsState.result ?? []
            state.selectedRegion = state.regions.first
        case .loadBedroomRanges:
            state.bedroomRangesState = .loading
            return .task {
                .bedroomRangesLoaded(await RequestState.getResult(provider: searchWizardRepository.getBedroomRanges))
            }
        case .bedroomRangesLoaded(let bedroomRangesState):
            state.bedroomRangesState = bedroomRangesState
            state.bedroomRanges = bedroomRangesState.result ?? []
            state.selectedBedroomRange = state.bedroomRanges.first

        // User input
        case .toggleNavigationCase:
            guard let currentCase = state.navigationCaseState.result else { return .none }
            state.navigationCaseState = .loaded(currentCase == .regionThenBedroomRange ? .bedroomRangeThenRegion : .regionThenBedroomRange)
        case .chooseRegion(let region):
            state.selectedRegion = region
        case .chooseBedroomRange(let range):
            state.selectedBedroomRange = range
        }

        return .none
    }

}

enum NavigationCase: Equatable {
    case regionThenBedroomRange, bedroomRangeThenRegion

    var description: String {
        switch self {
        case .regionThenBedroomRange: return "Region > Bedroom Ranges"
        case .bedroomRangeThenRegion: return "Bedroom Ranges > Region"
        }
    }
}

struct Region: Hashable, Identifiable {
    var id: String { name }
    let name: String
}

struct BedroomRange: Hashable, Identifiable {
    var id: String { "\(min)-\(max) rooms" }

    let min: Int
    let max: Int
}

enum SearchWizardPage {
    case pickingRegion
    case pickingBedroomRanges
    case searchResult
}
