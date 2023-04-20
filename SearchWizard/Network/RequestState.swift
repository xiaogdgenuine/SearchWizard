//
//  RequestState.swift
//  SearchWizard
//
//  Created by xiaogd on 2023/4/20.
//

import Foundation

enum RequestState<Result: Equatable>: Equatable {
    case intialized
    case loading
    case loaded(Result)
    case failure(Error)

    var result: Result? {
        if case let .loaded(result) = self {
            return result
        }

        return nil
    }

    static func == (lhs: RequestState<Result>, rhs: RequestState<Result>) -> Bool {
        if case .intialized = lhs, case .intialized = rhs {
            return true
        }

        if case .loading = lhs, case .loading = rhs {
            return true
        }

        if case .loaded(let lResult) = lhs, case .loaded(let rResult) = rhs {
            return lResult == rResult
        }

        if case .failure(let lError) = lhs, case .failure(let rError) = rhs {
            return lError.localizedDescription == rError.localizedDescription
        }

        return false
    }
}

extension RequestState {
    static func getResult(provider: @escaping () async throws -> Result) async -> Self {
        do {
            let result = try await provider()
            return .loaded(result)
        } catch {
            return .failure(error)
        }
    }
}
