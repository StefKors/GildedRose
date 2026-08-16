//
//  SulfurasStrategy.swift
//  GildedRose
//
//  Created by Stef Kors on 16/08/2026.
//


@testable import GildedRose
import XCTest

class SulfurasStrategy: XCTestCase {
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
