//
//  ImgurFeedTests.swift
//  ImgurFeedTests
//
//  Created by Senthil on 22/03/2025.
//

import XCTest
import Combine
@testable import ImgurFeed

final class ImgurFeedTests: XCTestCase {
    var apiManager: APIManager!
    var cancellables: Set<AnyCancellable>!
      
    override func setUp() {
      super.setUp()
      apiManager = APIManager.shared
      cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchViralPosts_Success() {
        let expectation = XCTestExpectation(description: "Fetch viral posts successfully")
        apiManager.fetchViralPosts()
           .sink(receiveCompletion: { completion in
               switch completion {
               case .finished:
                   break
               case .failure(let error):
                   XCTFail("Request failed with error: \(error)")
               }
           }, receiveValue: { posts in
               // Assert
               XCTAssertGreaterThan(posts.count, 0)
               expectation.fulfill()
           })
           .store(in: &cancellables)
       
        wait(for: [expectation], timeout: 5)
    }

}
