//
//  AgedBrieStrategyTests.swift
//  GildedRose
//
//  Created by Stef Kors on 16/08/2026.
//


@testable import GildedRose
import XCTest

class AgedBrieStrategyTests: XCTestCase {
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

    func testQualityIsNotMoreThan50() {
        let items = [Item(name: "Aged Brie", sellIn: 10, quality: 49)]
        let app = GildedRose(items: items)

        app.updateQuality()
        XCTAssertLessThanOrEqual(app.items[0].quality, 50)
    }

    func testQualityIsNotMoreThan50NearBoundary() {
        let items = [Item(name: "Aged Brie", sellIn: 3, quality: 50)]
        let app = GildedRose(items: items)

        app.updateQuality()
        XCTAssertLessThanOrEqual(app.items[0].quality, 50)
    }
}
