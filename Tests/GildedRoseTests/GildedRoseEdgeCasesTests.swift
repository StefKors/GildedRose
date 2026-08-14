//
//  GildedRoseEdgeCasesTests.swift
//  GildedRose
//
//  Created by Stef Kors on 14/08/2026.
//


@testable import GildedRose
import XCTest

// Edge Cases:
// [x] "Aged Brie" actually increases in Quality the older it gets
// [x] "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
class GildedRoseEdgeCasesTests: XCTestCase {
    func testAgedBrieIncreasesInValue() {
        let items = [Item(name: "Aged Brie", sellIn: 10, quality: 13)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 9)
        XCTAssertEqual(app.items[0].quality, 14)
    }

    func testAgedBrieIncreasesInValueTwiceAsFastAfterSellInDate() {
        let items = [Item(name: "Aged Brie", sellIn: 0, quality: 10)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -1)
        XCTAssertEqual(app.items[0].quality, 12)
    }

    func testSulfurasDoesntDecreaseInSellInOrQuality() {
        let items = [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 10, quality: 80)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 10)
        XCTAssertEqual(app.items[0].quality, 80)
    }

    func testSulfurasWithNegativeSellInDoesntDecreaseInSellInOrQuality() {
        let items = [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 80)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -1)
        XCTAssertEqual(app.items[0].quality, 80)
    }
}
