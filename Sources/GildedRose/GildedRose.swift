extension Item {
    enum Category {
        case sulfuras
        case brie
        case backstage
        case normal
    }

    var category: Category {
        if self.name == "Aged Brie" {
            return .brie
        } else if self.name == "Backstage passes to a TAFKAL80ETC concert" {
            return .backstage
        } else if self.name == "Sulfuras, Hand of Ragnaros" {
            return .sulfuras
        } else {
            return .normal
        }
    }
}

public class GildedRose {
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    fileprivate func improveQuality(_ item: Item, by amount: Int = 1) {
        if item.quality < 50 {
            item.quality = min(item.quality + amount, 50)
        }
    }
    
    fileprivate func reduceQuality(_ item: Item) {
        if item.quality > 0 {
            item.quality = item.quality - 1
        }
    }

    fileprivate func handleSellIn(_ item: Item) {
        guard item.category != .sulfuras else { return }
        item.sellIn = item.sellIn - 1
    }
    
    fileprivate func handleQuality(_ item: Item) {
        switch item.category {
        case .sulfuras:
            break
        case .brie:
            improveQuality(item)

            if item.sellIn < 0 {
                improveQuality(item)
            }
        case .backstage:
            if item.sellIn < 0 {
                item.quality = 0
            } else if item.sellIn < 5 {
                improveQuality(item, by: 3)
            } else if item.sellIn < 10 {
                improveQuality(item, by: 2)
            } else {
                improveQuality(item, by: 1)
            }
        case .normal:
            reduceQuality(item)

            if item.sellIn < 0 {
                reduceQuality(item)
            }
        }
    }
    
    public func updateQuality() {
        for item in items {
            handleSellIn(item)
            handleQuality(item)
        }
    }
}
