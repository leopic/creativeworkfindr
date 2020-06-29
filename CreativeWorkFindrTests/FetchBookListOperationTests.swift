import XCTest

@testable import CreativeWorkFindr

class FetchBookListOperationTests: XCTestCase {
  let testQueue = OperationQueue()

  func testInvalidSearchTerm() {
    let op = FetchBookListOperation(searchTerm: "")

    testQueue.addOperations([op], waitUntilFinished: true)

    XCTAssertEqual(op.results.count, 0, "FetchBookListOperation incorrectly parsed an incomplete list of ids")
    XCTAssertEqual(op.error, .invalidSearchTerm(term: ""), "FetchBookListOperation did not communicate an invalid search term error")
  }

  func testParseError() {
    let mockURLSession = MockURLSession(nextData: "{}".data(using: .utf8)!)
    let op = FetchBookListOperation(session: mockURLSession, searchTerm: "ready player one")

    testQueue.addOperations([op], waitUntilFinished: true)

    XCTAssertEqual(op.results.count, 0, "FetchBookListOperation incorrectly parsed an incomplete list of ids")
    XCTAssertEqual(op.error, .parseError, "FetchBookListOperation did not communicate a parsing error")
  }

  func testEmptyResponse() {
    let data = """
    {
        "start": 0,
        "num_found": 0,
        "numFound": 0,
        "docs": []
    }
    """.data(using: .utf8)!

    let mockURLSession = MockURLSession(nextData: data)
    let op = FetchBookListOperation(session: mockURLSession, searchTerm: "some random book that does not exist")

    testQueue.addOperations([op], waitUntilFinished: true)

    XCTAssertEqual(op.results.count, 0, "FetchBookListOperation was unable to handle an empty list")
    XCTAssertNil(op.error, "FetchBookListOperation incorrectly communicated an error for an empty list")
  }

  func testSuccess() {
    let data = """
    {
        "start": 0,
        "num_found": 5,
        "numFound": 5,
        "docs": [
            {
                "title_suggest": "The Legend of Zelda : Breath of the Wild Extensive Guide",
                "publisher": [
                    "Independently published"
                ],
                "cover_i": 9186380,
                "id_amazon": [
                    "1981012907"
                ],
                "isbn": [
                    "1981012907",
                    "9781981012909"
                ],
                "has_fulltext": false,
                "title": "The Legend of Zelda : Breath of the Wild Extensive Guide",
                "edition_key": [
                    "OL27780909M"
                ],
                "last_modified_i": 1576189973,
                "edition_count": 1,
                "author_name": [
                    "Jake Baxter"
                ],
                "cover_edition_key": "OL27780909M",
                "seed": [
                    "/books/OL27780909M",
                    "/works/OL20538150W",
                    "/authors/OL7781582A"
                ],
                "first_publish_year": 2018,
                "publish_year": [
                    2018
                ],
                "key": "/works/OL20538150W",
                "text": [
                    "OL27780909M",
                    "1981012907",
                    "9781981012909",
                    "Jake Baxter",
                    "OL7781582A",
                    "Shrines, Quests, Strategies, Recipes, Locations, How Tos and More",
                    "The Legend of Zelda : Breath of the Wild Extensive Guide",
                    "/works/OL20538150W",
                    "Independently published"
                ],
                "publish_date": [
                    "May 15, 2018"
                ],
                "author_key": [
                    "OL7781582A"
                ],
                "type": "work",
                "ebook_count_i": 0
            },
            {
                "title_suggest": "The Legend of Zelda",
                "publisher": [
                    "Piggyback"
                ],
                "subtitle": "Breath of the Wild - Le Guide Officiel Complet – Édition Augmentée",
                "has_fulltext": false,
                "title": "The Legend of Zelda",
                "edition_key": [
                    "OL26626548M"
                ],
                "last_modified_i": 1545774317,
                "edition_count": 1,
                "isbn": [
                    "1911015508",
                    "9781911015505"
                ],
                "seed": [
                    "/books/OL26626548M",
                    "/works/OL18144312W"
                ],
                "first_publish_year": 2018,
                "publish_year": [
                    2018
                ],
                "key": "/works/OL18144312W",
                "text": [
                    "OL26626548M",
                    "Breath of the Wild - Le Guide Officiel Complet – Édition Augmentée",
                    "1911015508",
                    "9781911015505",
                    "The Legend of Zelda",
                    "/works/OL18144312W",
                    "Piggyback",
                    "The Legend of Zelda: Breath of the Wild - Le Guide Officiel Complet – Édition Augmentée"
                ],
                "publish_date": [
                    "2018"
                ],
                "type": "work",
                "ebook_count_i": 0
            },
            {
                "title_suggest": "The legend of Zelda",
                "edition_key": [
                    "OL27235349M"
                ],
                "isbn": [
                    "9781911015239",
                    "1911015230"
                ],
                "has_fulltext": false,
                "text": [
                    "OL27235349M",
                    "9781911015239",
                    "1911015230",
                    "Tony Gao",
                    "Price, James",
                    "OL7614947A",
                    "Computer adventure games",
                    "Video games",
                    "Handbooks, manuals",
                    "Legend of Zelda (Game)",
                    "breath of the wild : the complete official guide",
                    "The legend of Zelda",
                    "/works/OL20055334W",
                    "co-authors: Tony Gao, James Price",
                    "Piggyback",
                    "Breath of the wild"
                ],
                "author_name": [
                    "Tony Gao"
                ],
                "seed": [
                    "/books/OL27235349M",
                    "/works/OL20055334W",
                    "/subjects/computer_adventure_games",
                    "/subjects/video_games",
                    "/subjects/handbooks_manuals",
                    "/subjects/legend_of_zelda_(game)",
                    "/authors/OL7614947A"
                ],
                "contributor": [
                    "Price, James"
                ],
                "author_key": [
                    "OL7614947A"
                ],
                "subject": [
                    "Computer adventure games",
                    "Video games",
                    "Handbooks, manuals",
                    "Legend of Zelda (Game)"
                ],
                "title": "The legend of Zelda",
                "publish_date": [
                    "2017"
                ],
                "type": "work",
                "ebook_count_i": 0,
                "publish_place": [
                    "London"
                ],
                "edition_count": 1,
                "key": "/works/OL20055334W",
                "publisher": [
                    "Piggyback"
                ],
                "language": [
                    "eng"
                ],
                "last_modified_i": 1563577985,
                "publish_year": [
                    2017
                ],
                "first_publish_year": 2017
            },
            {
                "title_suggest": "The Legend of Zelda",
                "edition_key": [
                    "OL27366443M"
                ],
                "cover_i": 8829602,
                "subtitle": "Breath of the Wild-Creating a Champion",
                "has_fulltext": false,
                "text": [
                    "OL27366443M",
                    "Breath of the Wild-Creating a Champion",
                    "Nintendo",
                    "9781506710112",
                    "1506710115",
                    "OL2760789A",
                    "The Legend of Zelda",
                    "Video Games",
                    "Breath of the Wild-Creating a Champion Hero's Edition",
                    "The Legend of Zelda",
                    "/works/OL20181833W",
                    "Dark Horse Books",
                    "Hyrule"
                ],
                "author_name": [
                    "Nintendo"
                ],
                "seed": [
                    "/books/OL27366443M",
                    "/works/OL20181833W",
                    "/subjects/video_games",
                    "/subjects/the_legend_of_zelda",
                    "/subjects/place:hyrule",
                    "/authors/OL2760789A"
                ],
                "isbn": [
                    "9781506710112",
                    "1506710115"
                ],
                "author_key": [
                    "OL2760789A"
                ],
                "subject": [
                    "The Legend of Zelda",
                    "Video Games"
                ],
                "title": "The Legend of Zelda",
                "first_publish_year": 2018,
                "type": "work",
                "ebook_count_i": 0,
                "edition_count": 1,
                "key": "/works/OL20181833W",
                "publish_date": [
                    "Nov 20, 2018"
                ],
                "id_amazon": [
                    "1506710115"
                ],
                "last_modified_i": 1577033081,
                "publisher": [
                    "Dark Horse Books"
                ],
                "cover_edition_key": "OL27366443M",
                "publish_year": [
                    2018
                ],
                "place": [
                    "Hyrule"
                ]
            },
            {
                "title_suggest": "The Legend of Zelda",
                "edition_key": [
                    "OL27366426M"
                ],
                "cover_i": 8829585,
                "subtitle": "Breath of the Wild--Creating a Champion",
                "has_fulltext": false,
                "text": [
                    "OL27366426M",
                    "Breath of the Wild--Creating a Champion",
                    "Nintendo",
                    "1506710107",
                    "9781506710105",
                    "OL2760789A",
                    "The Legend of Zelda",
                    "Video Games",
                    "The Legend of Zelda",
                    "/works/OL20181816W",
                    "Dark Horse Books",
                    "Hyrule"
                ],
                "author_name": [
                    "Nintendo"
                ],
                "seed": [
                    "/books/OL27366426M",
                    "/works/OL20181816W",
                    "/subjects/video_games",
                    "/subjects/the_legend_of_zelda",
                    "/subjects/place:hyrule",
                    "/authors/OL2760789A"
                ],
                "isbn": [
                    "1506710107",
                    "9781506710105"
                ],
                "author_key": [
                    "OL2760789A"
                ],
                "subject": [
                    "The Legend of Zelda",
                    "Video Games"
                ],
                "title": "The Legend of Zelda",
                "publish_date": [
                    "Nov 20, 2018"
                ],
                "type": "work",
                "ebook_count_i": 0,
                "edition_count": 1,
                "key": "/works/OL20181816W",
                "publisher": [
                    "Dark Horse Books"
                ],
                "id_amazon": [
                    "1506710107"
                ],
                "language": [
                    "eng"
                ],
                "last_modified_i": 1577032907,
                "cover_edition_key": "OL27366426M",
                "publish_year": [
                    2018
                ],
                "first_publish_year": 2018,
                "place": [
                    "Hyrule"
                ]
            }
        ]
    }
    """.data(using: .utf8)!

    let mockURLSession = MockURLSession(nextData: data)
    let op = FetchBookListOperation(session: mockURLSession, searchTerm: "legend of zelda breath of the wild")

    testQueue.addOperations([op], waitUntilFinished: true)

    XCTAssertEqual(op.results.count, 5, "FetchBookListOperation was unable to parse a valid response")
    XCTAssertNil(op.error, "FetchBookListOperation incorrectly communicated a parsing error")
  }
}
