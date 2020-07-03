import XCTest

@testable import CreativeWorkFindr

class FetchBookOperationTests: XCTestCase {
  let testQueue = OperationQueue()

  func testParseError() {
    let mockURLSession = MockURLSession(nextData: "{}".data(using: .utf8)!)
    let op = FetchBookOperation(session: mockURLSession, openLibraryId: "my book")

    testQueue.addOperations([op], waitUntilFinished: true)

    guard let result = op.result else {
      XCTFail("FetchBookOperation failed to yield a result")
      return
    }

    switch result {
    case .success(_):
      XCTFail("FetchBookOperation incorrectly parsed an incomplete book")
    case .failure(let error):
      XCTAssertEqual(error, .parseError, "FetchBookOperation did not communicate a parsing error")
    }
  }

  func testSuccess() {
    let data = """
{
    "OLID:OL27358054M": {
        "publishers": [
            {
                "name": "SFI Readerlink Dist"
            }
        ],
        "identifiers": {
            "isbn_13": [
                "9780794442194"
            ],
            "amazon": [
                "0794442196"
            ],
            "isbn_10": [
                "0794442196"
            ],
            "openlibrary": [
                "OL27358054M"
            ]
        },
        "subtitle": "X-Wing",
        "title": "Star Wars Build Your Own",
        "url": "https://openlibrary.org/books/OL27358054M/Star_Wars_Build_Your_Own",
        "notes": "Source title: Star Wars Build Your Own: X-Wing",
        "number_of_pages": 36,
        "cover": {
            "small": "https://covers.openlibrary.org/b/id/8821355-S.jpg",
            "large": "https://covers.openlibrary.org/b/id/8821355-L.jpg",
            "medium": "https://covers.openlibrary.org/b/id/8821355-M.jpg"
        },
        "publish_date": "Aug 21, 2018",
        "key": "/books/OL27358054M",
        "authors": [
            {
                "url": "https://openlibrary.org/authors/OL2686930A/Star_Wars",
                "name": "Star Wars"
            }
        ]
    }
}
""".data(using: .utf8)!

    let mockURLSession = MockURLSession(nextData: data)
    let op = FetchBookOperation(session: mockURLSession, openLibraryId: "OL27358054M")

    testQueue.addOperations([op], waitUntilFinished: true)

    guard let result = op.result else {
      XCTFail("FetchBookOperation failed to yield a result")
      return
    }

    switch result {
    case .success(let book):
      XCTAssertEqual(book.title, "Star Wars Build Your Own", "FetchBookOperation failed to parse a valid book")
    case .failure(_):
      XCTFail("FetchBookOperation incorrectly communicated a parsing error")
    }
  }
}
