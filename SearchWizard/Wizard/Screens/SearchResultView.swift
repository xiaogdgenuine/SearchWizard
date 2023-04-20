//
//  SearchResultView.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import SwiftUI
import ComposableArchitecture

struct SearchResultView: View {
    let store: ViewStoreOf<SearchWizardReducer>

    var body: some View {
        Group {
            if let region = store.selectedRegion,
               let bedroomRange = store.selectedBedroomRange {
                Text("Your filter conditions").font(.title2)
                Text("Region: \(region.name)")
                Text("Bedrooms: \(bedroomRange.id)")
            }
        }
        .onAppear { store.send(.updateCurrentPage(.searchResult)) }
    }
}
