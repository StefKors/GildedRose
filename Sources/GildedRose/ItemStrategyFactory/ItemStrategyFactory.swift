//
//  ItemStrategyFactory.swift
//  GildedRose
//
//  Created by Stef Kors on 15/08/2026.
//

struct ItemStrategyFactory {
    func make(for item: Item) -> ItemStrategy {
        switch item.name {
        case "Aged Brie":
            return AgedBrieStrategy()
        case "Backstage passes to a TAFKAL80ETC concert":
            return BackstagePassStrategy()
        case "Sulfuras, Hand of Ragnaros":
            return SulfurasStrategy()
        default:
            return NormalStrategy()
        }
    }
}
