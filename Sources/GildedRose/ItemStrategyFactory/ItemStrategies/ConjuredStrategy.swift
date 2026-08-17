//
//  ConjuredStrategy.swift
//  GildedRose
//
//  Created by Stef Kors on 17/08/2026.
//


struct ConjuredStrategy: QualityUpdateStrategy, SellInUpdateStrategy {
    func update(_ item: Item) {
        decreaseSellIn(of: item)
        decreaseQuality(of: item, by: 2)
        if item.sellIn < 0 {
            decreaseQuality(of: item, by: 2)
        }
    }
}