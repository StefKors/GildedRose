//
//  ItemStrategy.swift
//  GildedRose
//
//  Created by Stef Kors on 15/08/2026.
//

protocol ItemStrategy {
    func update(_ item: Item)
}

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

protocol SellInUpdateStrategy: ItemStrategy {
    func update(_ item: Item)
}

extension SellInUpdateStrategy {
    func decreaseSellIn(of item: Item) {
        item.sellIn = item.sellIn - 1
    }
}

struct SulfurasStrategy: ItemStrategy {
    func update(_ item: Item) {
        // Intentionally left blank
    }
}

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

struct AgedBrieStrategy: QualityUpdateStrategy, SellInUpdateStrategy {
    func update(_ item: Item) {
        decreaseSellIn(of: item)
        increaseQuality(of: item)
        if item.sellIn < 0 {
            increaseQuality(of: item)
        }
    }
}

struct NormalStrategy: QualityUpdateStrategy, SellInUpdateStrategy {
    func update(_ item: Item) {
        decreaseSellIn(of: item)
        decreaseQuality(of: item)
        if item.sellIn < 0 {
            decreaseQuality(of: item)
        }
    }
}
