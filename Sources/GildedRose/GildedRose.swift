extension Item {
    enum Category {
        case sulfuras
        case brie
        case backstage
        case normalItems
    }

    var isBrie: Bool {
        self.category == .brie
    }

    var isBackstage: Bool {
        self.category == .backstage
    }

    var isSulfuras: Bool {
        self.category == .sulfuras
    }

    var isNormalItem: Bool {
        self.category == .normalItems
    }

    var category: Category {
        if self.name == "Aged Brie" {
            return .brie
        } else if self.name == "Backstage passes to a TAFKAL80ETC concert" {
            return .backstage
        } else if self.name == "Sulfuras, Hand of Ragnaros" {
            return .sulfuras
        } else {
            return .normalItems
        }
    }
}

public class GildedRose {
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    fileprivate func improveQuality(_ item: Item) {
        if item.quality < 50 {
            item.quality = item.quality + 1
        }
    }
    
    fileprivate func reduceQuality(_ item: Item) {
        if item.quality > 0 {
            item.quality = item.quality - 1
        }
    }
    
    fileprivate func reduceSellIn(_ item: Item) {
        item.sellIn = item.sellIn - 1
    }
    
    public func updateQuality() {
        for item in items {
            reduceSellIn(item)

            if item.isSulfuras {
                // do nothing
            }

            if item.isBrie {
                improveQuality(item)

                if item.sellIn < 0 {
                    improveQuality(item)
                }
            }

            if item.isBackstage {
                improveQuality(item)

                // sellin after reduce
                if item.sellIn < 10 {
                    improveQuality(item)
                }

                // sellin after reduce
                if item.sellIn < 5 {
                    improveQuality(item)
                }

                // sellin after reduce
                if item.sellIn < 0 {
                    item.quality = 0
                }
            }

            if item.category != .brie && item.category != .backstage {
                reduceQuality(item)

                if item.sellIn < 0 {
                    reduceQuality(item)
                }
            }


        }
    }
}
