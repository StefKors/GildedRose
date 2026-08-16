//
//  ConjuredStrategyTests.swift
//  GildedRose
//
//  Created by Stef Kors on 14/08/2026.
//


@testable import GildedRose
import XCTest

class ConjuredStrategyTests: XCTestCase {
    func testConjuredItemsDegradeInQualityTwiceAsFast() {
        let items = [Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 2)
        XCTAssertEqual(app.items[0].quality, 4)
    }

    func testConjuredItemsPastSellInDegradeInQualityTwiceAsFast() {
        let items = [Item(name: "Conjured Mana Cake", sellIn: -1, quality: 6)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -2)
        XCTAssertEqual(app.items[0].quality, 2)
    }

    func testConjuredItemsShouldNotDegradePastZero() {
        let items = [Item(name: "Conjured Mana Cake", sellIn: -1, quality: 2)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -2)
        XCTAssertEqual(app.items[0].quality, 0)
    }
}
