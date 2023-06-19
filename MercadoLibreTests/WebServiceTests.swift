//
//  WebServiceTests.swift
//  WebServiceTests
//
//  Created by Jose Angel Ramirez Garza on 17/06/23.
//

import XCTest
@testable import MercadoLibre

final class WebServiceTests: XCTestCase {
    
    var sut: WebService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = WebService(urlString: "https://api.mercadolibre.com/sites/MLA/search", urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testWebService_WhenGivenSuccessFullResponse_ReturnSuccess() {
        //Arrange
        let jsonString = """
        {
          "site_id": "MLA",
          "country_default_time_zone": "GMT-03:00",
          "query": "iPhone",
          "paging": {
            "total": 15225,
            "primary_results": 1000,
            "offset": 0,
            "limit": 50
          },
          "results": [
            {
              "id": "MLA1356411952",
              "title": "Apple iPhone 11 (128 Gb) - Negro",
              "condition": "new",
              "thumbnail_id": "842272-MLA52993977355_122022",
              "catalog_product_id": "MLA15149567",
              "listing_type_id": "gold_special",
              "permalink": "https://www.mercadolibre.com.ar/apple-iphone-11-128-gb-negro/p/MLA15149567",
              "buying_mode": "buy_it_now",
              "site_id": "MLA",
              "category_id": "MLA1055",
              "domain_id": "MLA-CELLPHONES",
              "thumbnail": "http://http2.mlstatic.com/D_842272-MLA52993977355_122022-I.jpg",
              "currency_id": "ARS",
              "order_backend": 1,
              "price": 346999,
              "original_price": null,
              "sale_price": null,
              "sold_quantity": 25,
              "available_quantity": 1,
              "official_store_id": null,
              "use_thumbnail_id": true,
              "accepts_mercadopago": true,
              "tags": [],
              "shipping": {},
              "stop_time": "2043-02-19T04:00:00.000Z",
              "seller": {},
              "seller_address": {},
              "address": {},
              "attributes": [],
              "installments": {
                "quantity": 12,
                "amount": 62751.88,
                "rate": 117.01,
                "currency_id": "ARS"
              },
              "winner_item_id": null,
              "catalog_listing": true,
              "discounts": null,
              "promotions": [
              ],
              "inventory_id": null
            }
        ]
        }
        """
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Search Results Web Service Response")

        // Act
        sut.search(with: "motorola") { (resultsModel, error) in
            XCTAssertNotNil(resultsModel, "Result model should be not nil but its nil")
            XCTAssertNil(error, "Error should be nil but is not")
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
    }
    
    func testWebService_WhenGivenBadJSONResponse_ReturnParsingError() {
        //Arrange
        let jsonString = """
        {
          "results": [
            {
              "id": "MLA1356411952",
              "category_id": "MLA1055",
              "domain_id": "MLA-CELLPHONES",
              "thumbnail": "http://http2.mlstatic.com/D_842272-MLA52993977355_122022-I.jpg",
              "currency_id": "ARS",
              "order_backend": 1,
              "price": 346999,
              "original_price": null
            }
        ]
        }
        """
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Search Results Web Service Response")

        // Act
        sut.search(with: "motorola") { (resultsModel, error) in
            XCTAssertNil(resultsModel, "Result model should be nil but is not nil")
            XCTAssertEqual(error, MLErrors.responseModelParsingError)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
    }

}
