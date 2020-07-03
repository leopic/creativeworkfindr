import XCTest

class FetchMovieOperationTests: XCTestCase {
  private let testQueue = OperationQueue()

  func testParseError() {
    let mockURLSession = MockURLSession(nextData: "{}".data(using: .utf8)!)
    let op = FetchMovieOperation(session: mockURLSession, imdbId: "my movie")

    testQueue.addOperations([op], waitUntilFinished: true)

    guard let result = op.result else {
      XCTFail("FetchMovieOperation failed to yield a result")
      return
    }

    switch result {
    case .success(_):
      XCTFail("FetchMovieOperation incorrectly parsed an incomplete movie")
    case .failure(let error):
      XCTAssertEqual(error, .parseError, "FetchMovieOperation did not communicate a parsing error")
    }
  }

  func testSuccess() {
    let data = """
  {
      "Title": "The Lord of the Rings: The Fellowship of the Ring",
      "Year": "2001",
      "Rated": "PG-13",
      "Released": "19 Dec 2001",
      "Runtime": "178 min",
      "Genre": "Action, Adventure, Drama, Fantasy",
      "Director": "Peter Jackson",
      "Writer": "J.R.R. Tolkien (novel), Fran Walsh (screenplay), Philippa Boyens (screenplay), Peter Jackson (screenplay)",
      "Actors": "Alan Howard, Noel Appleby, Sean Astin, Sala Baker",
      "Plot": "An ancient Ring thought lost for centuries has been found, and through a strange twist in fate has been given to a small Hobbit named Frodo. When Gandalf discovers the Ring is in fact the One Ring of the Dark Lord Sauron, Frodo must make an epic quest to the Cracks of Doom in order to destroy it! However he does not go alone. He is joined by Gandalf, Legolas the elf, Gimli the Dwarf, Aragorn, Boromir and his three Hobbit friends Merry, Pippin and Samwise. Through mountains, snow, darkness, forests, rivers and plains, facing evil and danger at every corner the Fellowship of the Ring must go. Their quest to destroy the One Ring is the only hope for the end of the Dark Lords reign!",
      "Language": "English, Sindarin",
      "Country": "New Zealand",
      "Awards": "Won 4 Oscars. Another 114 wins & 124 nominations.",
      "Poster": "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_SX300.jpg",
      "Ratings": [
          {
              "Source": "Internet Movie Database",
              "Value": "8.8/10"
          },
          {
              "Source": "Rotten Tomatoes",
              "Value": "91%"
          },
          {
              "Source": "Metacritic",
              "Value": "92/100"
          }
      ],
      "Metascore": "92",
      "imdbRating": "8.8",
      "imdbVotes": "1,606,070",
      "imdbID": "tt0120737",
      "Type": "movie",
      "DVD": "06 Aug 2002",
      "BoxOffice": "$314,000,000",
      "Production": "New Line Cinema",
      "Website": "N/A",
      "Response": "True"
  }
  """.data(using: .utf8)!

    let mockURLSession = MockURLSession(nextData: data)
    let op = FetchMovieOperation(session: mockURLSession, imdbId: "tt0120737")

    testQueue.addOperations([op], waitUntilFinished: true)

    guard let result = op.result else {
      XCTFail("FetchMovieOperation failed to yield a result")
      return
    }

    switch result {
    case .success(let movie):
      let expected = "The Lord of the Rings: The Fellowship of the Ring"
      XCTAssertEqual(movie.title, expected, "FetchMovieOperation failed to parse a valid movie")
    case .failure(_):
      XCTFail("FetchMovieOperation incorrectly communicated a parsing error")
    }
  }
}
