//
//  ChooseRegionView.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct ChooseRegionView: View {
    let store: ViewStoreOf<SearchWizardReducer>

    var body: some View {
        VStack {
            RequestWrappingView(requestState: store.regionsState) { regions in
                let binding = Binding(get: {
                    store.selectedRegion ?? regions[0]
                }, set: {
                    store.send(.chooseRegion($0))
                })

                HStack {
                    Text("Which region:")
                    Picker("", selection: binding) {
                        ForEach(regions, id: \.self) { region in
                            Text(region.name)
                        }
                    }
                }
                Button("Next") {
                    store.send(.navigateNext)
                }
            }
        }
        .onAppear {
            store.send(.updateCurrentPage(.pickingRegion))
            
            if store.regionsState == .intialized {
                store.send(.loadRegions)
            }
        }
    }
}
