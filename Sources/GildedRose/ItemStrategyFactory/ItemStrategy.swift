//
//  ItemStrategy.swift
//  GildedRose
//
//  Created by Stef Kors on 15/08/2026.
//


// MARK: - Generic Protocol
protocol ItemStrategy {
    func update(_ item: Item)
}


// MARK: - Quality
protocol QualityUpdateStrategy: ItemStrategy {
    func update(_ item: Item)
}

extension QualityUpdateStrategy {
    func increaseQuality(of item: Item, by amount: Int = 1) {
        item.quality = min(item.quality + amount, 50)
    }

    func decreaseQuality(of item: Item, by amount: Int = 1) {
        item.quality = max(item.quality - amount, 0)
    }
}


// MARK: - SellIn
protocol SellInUpdateStrategy: ItemStrategy {
    func update(_ item: Item)
}

extension SellInUpdateStrategy {
    func decreaseSellIn(of item: Item) {
        item.sellIn = item.sellIn - 1
    }
}










