//
//  SearchModelTests.swift
//  MercadoLibreTests
//
//  Created by Jose Angel Ramirez Garza on 19/06/23.
//

import XCTest
@testable import MercadoLibre

final class SearchModelTests: XCTestCase {

    var sut: SearchViewModel!

    override func setUpWithError() throws {
        sut = SearchViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSearchViewModel_WhenSearchTextIsEmpty_SearchButtonEnableShouldBeFalse() {
        sut.handleEditSearch(search: "")
        XCTAssertFalse(sut.isSearchButtonEnabled, "The isSearchButtonEnabled should be false but is true")
    }

    func testSearchViewModel_WhenSearchTextIsOnly2Chars_SearchButtonEnableShouldBeFalse() {
        sut.handleEditSearch(search: "ab")
        XCTAssertFalse(sut.isSearchButtonEnabled, "The isSearchButtonEnabled should be false but is true")
    }

    func testSearchViewModel_WhenSearchTextIsMoreThan3Chars_SearchButtonEnableShouldBeTrue() {
        sut.handleEditSearch(search: "iPhone")
        XCTAssertTrue(sut.isSearchButtonEnabled, "The isSearchButtonEnabled should be true but is false")
    }

}
