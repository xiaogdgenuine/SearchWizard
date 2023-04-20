//
//  SearchWizardView.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct SearchWizardView: View {
    let store: StoreOf<SearchWizardReducer>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack(path: viewStore.binding(get: \.navigationPath, send: { .updateNavigationPath($0) })) {
                Group {
                    RequestWrappingView(requestState: viewStore.navigationCaseState) { navigationCase in
                        Button("Toggle navigation case") {
                            viewStore.send(.toggleNavigationCase)
                        }
                        if let navigationCase = viewStore.navigationCaseState.result {
                            Text("Current flag: ") + Text(navigationCase.description).foregroundColor(.red)
                        }
                        Button("Start searching") {
                            viewStore.send(.startSearching(byCase: navigationCase))
                        }
                        .padding(.top)
                    }
                }
                .navigationTitle("Entry")
                .navigationDestination(for: SearchWizardPage.self) { page in
                    switch page {
                    case .pickingRegion:
                        ChooseRegionView(store: viewStore)
                            .navigationTitle("Region")
                    case .pickingBedroomRanges:
                        ChooseBedroomView(store: viewStore)
                            .navigationTitle("Bedroom range")
                    case .searchResult:
                        SearchResultView(store: viewStore)
                            .navigationTitle("Result")
                    }
                }
            }
            .onAppear {
                if viewStore.navigationCaseState == .intialized {
                    viewStore.send(.loadNavigationCase)
                }
            }
        }
    }
}
