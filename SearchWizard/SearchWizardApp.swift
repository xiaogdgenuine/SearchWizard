//
//  SearchWizardApp.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay

@main
struct SearchWizardApp: App {
    var body: some Scene {
        WindowGroup {
            // Prevent Testing gotchas
            // https://pointfreeco.github.io/swift-dependencies/main/documentation/dependencies/testing/#Testing-gotchas
            if !_XCTIsTesting {
                SearchWizardView(store: Store(initialState: SearchWizardReducer.State(), reducer: SearchWizardReducer()))
            }
        }
    }
}
