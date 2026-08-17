//
//  AgedBrieStrategy.swift
//  GildedRose
//
//  Created by Stef Kors on 17/08/2026.
//


struct AgedBrieStrategy: QualityUpdateStrategy, SellInUpdateStrategy {
    func update(_ item: Item) {
        decreaseSellIn(of: item)
        increaseQuality(of: item)
        if item.sellIn < 0 {
            increaseQuality(of: item)
        }
    }
}