//
//  SearchWizardRepositoryMock.swift
//  SearchWizardTests
//
//  Created by xiaogd on 2023/4/20.
//

import XCTest
import Dependencies
@testable import SearchWizard

struct SearchWizardRepositoryMock: SearchWizardRepositoryProtocol {
    let regions: [SearchWizard.Region] = [
        .init(name: "Asia"),
        .init(name: "Europe"),
        .init(name: "North America"),
        .init(name: "South America"),
        .init(name: "Africa"),
        .init(name: "Oceania"),
        .init(name: "Antarctica")
    ]
    let bedroomRanges: [SearchWizard.BedroomRange] = [
        .init(min: 1, max: 2),
        .init(min: 3, max: 5),
        .init(min: 5, max: 8),
        .init(min: 8, max: 12)
    ]

    func getRegions() async throws -> [SearchWizard.Region] {
        regions
    }

    func getBedroomRanges() async throws -> [SearchWizard.BedroomRange] {
        bedroomRanges
    }
}
