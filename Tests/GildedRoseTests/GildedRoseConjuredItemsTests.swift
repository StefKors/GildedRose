//
//  GildedRoseConjuredItemsTests.swift
//  GildedRose
//
//  Created by Stef Kors on 14/08/2026.
//


@testable import GildedRose
import XCTest

// New Scenarios:
// [ ] "Conjured" items degrade in Quality twice as fast as normal items
class GildedRoseConjuredItemsTests: XCTestCase {
    func testConjuredItemsDegradeInQualityTwiceAsFast() {
        let items = [Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 2)
        XCTAssertEqual(app.items[0].quality, 4)
    }
}
