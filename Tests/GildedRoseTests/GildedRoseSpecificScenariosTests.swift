//
//  GildedRoseSpecificScenariosTests.swift
//  GildedRose
//
//  Created by Stef Kors on 14/08/2026.
//


@testable import GildedRose
import XCTest

// Specific Scenarios:
// [x] Once the sell by date has passed, Quality degrades twice as fast
// [x] The Quality of an item is never negative
// [x] The Quality of an item is never more than 50
// [x] "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
// [x] Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
// [x] Quality drops to 0 after the concert
class GildedRoseSpecificScenariosTests: XCTestCase {
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

    func testBackstageQualityIsCappedAt50NearBoundary() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 4, quality: 49)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 3)
        XCTAssertEqual(app.items[0].quality, 50)
    }

    func testBackstagePassesIncreasesInValue() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 20, quality: 13)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 19)
        XCTAssertEqual(app.items[0].quality, 14)
    }

    func testBackstagePassesIncreaseInValueBy2WhenLessThan10DaysNearBoundary() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 11, quality: 8)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 10)
        XCTAssertEqual(app.items[0].quality, 9)
    }

    func testBackstagePassesIncreaseInValueBy2WhenLessThan10DaysAtBoundary() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 8)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 9)
        XCTAssertEqual(app.items[0].quality, 10)
    }

    func testBackstagePassesIncreaseInValueBy2WhenLessThan10Days() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 9, quality: 10)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 8)
        XCTAssertEqual(app.items[0].quality, 12)
    }

    func testBackstagePassesIncreaseInValueBy3WhenLessThan5DaysAtBoundary() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 6, quality: 18)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 5)
        XCTAssertEqual(app.items[0].quality, 20)
    }

    func testBackstagePassesIncreaseInValueBy3WhenLessThan5Days() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 20)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 4)
        XCTAssertEqual(app.items[0].quality, 23)
    }

    func testBackstagePassesAtConcertBoundary() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 1, quality: 34)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, 0)
        XCTAssertEqual(app.items[0].quality, 37)
    }

    func testBackstagePassesAre0AfterConcert() {
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 37)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, -1)
        XCTAssertEqual(app.items[0].quality, 0)
    }
}
