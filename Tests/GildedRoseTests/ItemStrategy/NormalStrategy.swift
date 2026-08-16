//
//  NormalStrategyTests.swift
//  GildedRose
//
//  Created by Stef Kors on 16/08/2026.
//


@testable import GildedRose
import XCTest

class NormalStrategyTests: XCTestCase {
    func testEachDayLowersBothValues() {
        let items = [Item(name: "Elixir of the Mongoose", sellIn: 5, quality: 7)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 4)
        XCTAssertEqual(app.items[0].quality, 6)
    }

    func testPastSellByQualityDegradesTwiceAsFast() {
        let items = [Item(name: "+5 Dexterity Vest", sellIn: 0, quality: 10)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -1)
        XCTAssertEqual(app.items[0].quality, 8)
    }

    func testQualityCantBeNegative() {
        let items = [Item(name: "+5 Dexterity Vest", sellIn: 0, quality: 0)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -1)
        XCTAssertGreaterThanOrEqual(app.items[0].quality, 0)
    }

    func testQualityCantBeNegativeAtBoundary() {
        let items = [Item(name: "+5 Dexterity Vest", sellIn: 0, quality: 1)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -1)
        XCTAssertGreaterThanOrEqual(app.items[0].quality, 0)
    }
}
