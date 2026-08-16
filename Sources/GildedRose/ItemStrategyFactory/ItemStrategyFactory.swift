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
        case _ where item.name.contains("Backstage passes"):
            return BackstagePassStrategy()
        case "Sulfuras, Hand of Ragnaros":
            return SulfurasStrategy()
        case _ where item.name.contains("Conjured"):
            return ConjuredStrategy()
        default:
            return NormalStrategy()
        }
    }
}
