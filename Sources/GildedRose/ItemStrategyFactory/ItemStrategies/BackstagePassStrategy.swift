//
//  BackstagePassStrategy.swift
//  GildedRose
//
//  Created by Stef Kors on 17/08/2026.
//


struct BackstagePassStrategy: QualityUpdateStrategy, SellInUpdateStrategy {
    func update(_ item: Item) {
        decreaseSellIn(of: item)
        if item.sellIn < 0 {
            item.quality = 0
        } else if item.sellIn < 5 {
            increaseQuality(of: item, by: 3)
        } else if item.sellIn < 10 {
            increaseQuality(of: item, by: 2)
        } else {
            increaseQuality(of: item, by: 1)
        }
    }
}