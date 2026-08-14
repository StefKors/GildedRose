//
//  GildedRoseBasicScenariosTests.swift
//  GildedRose
//
//  Created by Stef Kors on 14/08/2026.
//


@testable import GildedRose
import XCTest

// Basic Scenarios:
// [x] All items have a SellIn value which denotes the number of days we have to sell the items
// [x] All items have a Quality value which denotes how valuable the item is
// [x] At the end of each day our system lowers both values for every item
class GildedRoseBasicScenariosTests: XCTestCase {
    func testEachDayLowersBothValues() {
        let items = [Item(name: "Elixir of the Mongoose", sellIn: 5, quality: 7)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 4)
        XCTAssertEqual(app.items[0].quality, 6)
    }
}
