//
//  NormalStrategy.swift
//  GildedRose
//
//  Created by Stef Kors on 17/08/2026.
//


struct NormalStrategy: QualityUpdateStrategy, SellInUpdateStrategy {
    func update(_ item: Item) {
        decreaseSellIn(of: item)
        decreaseQuality(of: item)
        if item.sellIn < 0 {
            decreaseQuality(of: item)
        }
    }
}