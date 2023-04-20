//
//  ErrorView.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import SwiftUI

struct RequestWrappingView<Result: Equatable, Content: View>: View {
    let requestState: RequestState<Result>

    let contentBuilder: (Result) -> Content

    init(requestState: RequestState<Result>,
         @ViewBuilder content: @escaping (Result) -> Content) {
        self.requestState = requestState
        self.contentBuilder = content
    }

    var body: some View {
        switch requestState {
        case .intialized:
            EmptyView()
        case .loading:
            ProgressView()
        case .loaded(let result):
            contentBuilder(result)
        case .failure(let error):
            Text(error.localizedDescription)
                .font(.title)
                .foregroundColor(.red)
        }
    }
}
