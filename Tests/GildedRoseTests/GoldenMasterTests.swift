//
//  GoldenMasterTests.swift
//  GildedRose
//
//  Created by Stef Kors on 15/08/2026.
//


@testable import GildedRose
import XCTest
import UniformTypeIdentifiers

enum SnapshotError: Error {
    case missingSnapshot(name: String)
}

class GoldenMasterTests: XCTestCase {
    private func attach(text result: String) {
        if let data = result.data(using: .utf8) {
            let attachment = XCTAttachment(data: data, uniformTypeIdentifier: UTType.plainText.identifier)
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    private func readSnapshot(for name: String) throws -> String {
        guard let url = Bundle.module.url(forResource: "snapshot-\(name)", withExtension: "txt") else {
            throw SnapshotError.missingSnapshot(name: name)
        }
        let snapshot = try String(contentsOf: url, encoding: .utf8)
        return snapshot.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private let items = [
        Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20),
        Item(name: "Aged Brie", sellIn: 2, quality: 0),
        Item(name: "Elixir of the Mongoose", sellIn: 5, quality: 7),
        Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80),
        Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 80),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: 20),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 49),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 49)
    ]

    func testGoldenMasterSnapshot() throws {
        let app = GildedRose(items: items)

        var output: [String] = []
        for day in 0...30 {
            output.append("-------- day \(day) --------")
            output.append("name, sellIn, quality")
            app.items.forEach {
                output.append($0.description)
            }
            app.updateQuality()
        }
        let result = output.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        attach(text: result)

        let snapshot = try readSnapshot(for: "testGoldenMasterSnapshot")
        // The swift-snapshot-testing library can make this more readable
        // https://github.com/pointfreeco/swift-snapshot-testing
        XCTAssertEqual(
            result,
            snapshot,
            "result differs from snapshot: \n\(result.difference(from: snapshot))"
        )
    }
}
