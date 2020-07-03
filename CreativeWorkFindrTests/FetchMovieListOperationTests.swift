import XCTest

@testable import CreativeWorkFindr

class FetchMovieListOperationTests: XCTestCase {
  let testQueue = OperationQueue()

  func testInvalidSearchTerm() {
    let op = FetchMovieListOperation(searchTerm: "")

    testQueue.addOperations([op], waitUntilFinished: true)

    switch op.result {
    case .some(.failure(let error)):
      let expected: CreativeWorkFindrError = .invalidSearchTerm(term: "")
      XCTAssertEqual(error, expected, "FetchMovieListOperationTests did not communicate an invalid search term error")
    default:
      XCTFail("FetchMovieListOperationTests incorrectly parsed an incomplete list of ids")
    }
  }

  func testParseError() {
    let mockURLSession = MockURLSession(nextData: "{}".data(using: .utf8)!)
    let op = FetchMovieListOperation(session: mockURLSession, searchTerm: "ready player one")

    testQueue.addOperations([op], waitUntilFinished: true)

    switch op.result {
    case .some(.failure(let parseError)):
      let expected: CreativeWorkFindrError = .parseError
      XCTAssertEqual(parseError, expected, "FetchMovieListOperation did not communicate a parsing error")
    default:
      XCTFail("FetchMovieListOperation incorrectly parsed an incomplete list of ids")
    }
  }

  func testEmptyResponse() {
    let data = """
    {
      "Response": "False",
      "Error": "Movie not found!"
    }
    """.data(using: .utf8)!

    let mockURLSession = MockURLSession(nextData: data)
    let op = FetchMovieListOperation(session: mockURLSession, searchTerm: "some random movie that does not exist")

    testQueue.addOperations([op], waitUntilFinished: true)

    switch op.result {
    case .some(.success(let movies)):
      XCTAssertEqual(movies.count, 0, "FetchMovieListOperation was unable to handle an empty list")
    default:
      XCTFail("FetchMovieListOperation incorrectly communicated an error for an empty list")
    }
  }

  func testSuccess() {
    let data = """
    {
        "Search": [
            {
                "Title": "Ready Player One",
                "Year": "2018",
                "imdbID": "tt1677720",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BY2JiYTNmZTctYTQ1OC00YjU4LWEwMjYtZjkwY2Y5MDI0OTU3XkEyXkFqcGdeQXVyNTI4MzE4MDU@._V1_SX300.jpg"
            },
            {
                "Title": "Ready Player One LIVE at SXSW",
                "Year": "2018–",
                "imdbID": "tt8045574",
                "Type": "series",
                "Poster": "https://m.media-amazon.com/images/M/MV5BMjIwMjQ5Mzg5MF5BMl5BanBnXkFtZTgwMjAxMzAwNTM@._V1_SX300.jpg"
            },
            {
                "Title": "RiffTrax: Ready Player One",
                "Year": "2018",
                "imdbID": "tt10327974",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BNjhkMjNkMTUtOWQyMy00ZWUzLTkxZDUtMDU1MmUxNTAwN2JkXkEyXkFqcGdeQXVyODk1MTg5MDU@._V1_SX300.jpg"
            }
        ],
        "totalResults": "3",
        "Response": "True"
    }
    """.data(using: .utf8)!

    let mockURLSession = MockURLSession(nextData: data)
    let op = FetchMovieListOperation(session: mockURLSession, searchTerm: "ready player one")

    testQueue.addOperations([op], waitUntilFinished: true)

    switch op.result {
    case .some(.success(let movies)):
      XCTAssertEqual(movies.count, 3, "FetchMovieListOperation was unable to parse a valid response")
      XCTAssertEqual(movies.first, "tt1677720")
    default:
      XCTFail("FetchMovieListOperation incorrectly communicated a parsing error")
    }
  }
}
