//
//  ChooseBedroomRangeView.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct ChooseBedroomView: View {
    let store: ViewStoreOf<SearchWizardReducer>

    var body: some View {
        VStack {
            RequestWrappingView(requestState: store.bedroomRangesState) { bedroomRanges in
                let binding = Binding(get: {
                    store.selectedBedroomRange ?? bedroomRanges[0]
                }, set: {
                    store.send(.chooseBedroomRange($0))
                })
                HStack {
                    Text("How many bedrooms:")
                    Picker("", selection: binding) {
                        ForEach(bedroomRanges, id: \.self) { range in
                            Text(range.id)
                        }
                    }
                }
                
                Button("Next") {
                    store.send(.navigateNext)
                }
            }
        }
        .onAppear {
            store.send(.updateCurrentPage(.pickingBedroomRanges))
            
            if store.bedroomRangesState == .intialized {
                store.send(.loadBedroomRanges)
            }
        }
    }

}
