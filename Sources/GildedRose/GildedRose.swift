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

protocol ItemRule {
    func update(_ item: Item)
}

struct When: ItemRule {
    let condition: (Item) -> Bool
    let rules: [ItemRule]

    init(condition: @escaping (Item) -> Bool, rule: ItemRule) {
        self.condition = condition
        self.rules = [rule]
    }

    init(condition: @escaping (Item) -> Bool, rules: [ItemRule]) {
        self.condition = condition
        self.rules = rules
    }

    func update(_ item: Item) {
        if condition(item) {
            for rule in rules {
                rule.update(item)
            }
        }
    }
}

// struct If: ItemRule {
//     let condition: (Item) -> Bool
//     let ifRules: [ItemRule]
//     let elseRules: [ItemRule]
// 
//     init(condition: @escaping (Item) -> Bool, rule: ItemRule) {
//         self.condition = condition
//         self.rules = [rule]
//     }
// 
//     init(condition: @escaping (Item) -> Bool, rules: [ItemRule]) {
//         self.condition = condition
//         self.rules = rules
//     }
// 
//     func update(_ item: Item) {
//         if condition(item) {
//             for rule in rules {
//                 rule.update(item)
//             }
//         }
//     }
// }


struct IncreasesQuality: ItemRule {
    let amount: Int
    let min: Int = 0
    let max: Int = 50

    init(by amount: Int = 1) {
        self.amount = amount
    }

    func update(_ item: Item) {
        /// brie update
    }
}

struct WorthlessQuality: ItemRule {
    func update(_ item: Item) {
        /// brie update
    }
}


struct DecreasesQuality: ItemRule {
    func update(_ item: Item) {
        /// brie update
    }
}

struct ReducesSellIn: ItemRule {
    func update(_ item: Item) {
        /// brie update
    }
}








protocol RuledItem {
    var rules: [ItemRule] { get set }

    func update(_ item: Item)
}

struct BackstagePassItem: RuledItem {
    var rules: [ItemRule] = [
        ReducesSellIn(),
        BackstagePassRule()
    ]

    func update(_ item: Item) {
        for rule in rules {
            rule.update(item)
        }
    }
}

struct AgedBrieItem: RuledItem {
    var rules: [ItemRule] = [
        ReducesSellIn(),
        IncreasesQuality(),
        When(
            condition: { $0.sellIn < 0 },
            rule: IncreasesQuality()
        )
    ]

    func update(_ item: Item) {
        for rule in rules {
            rule.update(item)
        }
    }
}



struct ItemRuleSet {
    let rules: [ItemRule]

    init(_ item: Item) {
        self.rules = Self.updaterFactory(for: item.name)
    }

    func update(_ item: Item) {
        rules.forEach { $0.update(item) }
    }

    static func setup(for name: String) -> RuledItem? {
        if name == "Aged Brie" {
            return AgedBrieItem()
        }

        if name == "Backstage passes to a TAFKAL80ETC concert" {
            return BackstagePassItem().update()
        }

        // if name == "Sulfuras" {
        //     return []
        // }
       
        return nil
    }

    static func updaterFactory(for name: String) -> [ItemRule] {
        if name == "Aged Brie" {
            return [
                ReducesSellIn(),
                IncreasesQuality(),
                When(
                    condition: { $0.sellIn < 0 },
                    rule: IncreasesQuality()
                )
            ]
        }

        if name == "Backstage passes to a TAFKAL80ETC concert" {
            return [
                ReducesSellIn(),
                IncreasesQuality(),
                When(condition: { $0.sellIn < 10 }, rule: IncreasesQuality()),
                When(condition: { $0.sellIn < 5 }, rule: IncreasesQuality()),
                When(condition: { $0.sellIn < 0 }, rule: WorthlessQuality())
            ]
        }

        if name == "Sulfuras" {
            return []
        }

        return []
    }
}







struct BackstagePassStrategy: ItemStrategy {
    func update(_ item: Item) {
        if item.sellIn < 0 {
            item.quality = 0
        } else if item.sellIn < 5 {
            improveQuality(item, by: 3)
        } else if item.sellIn < 10 {
            improveQuality(item, by: 2)
        } else {
            improveQuality(item, by: 1)
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
            ItemFactory.makeItem(from: item).update()
        }
        for item in items {
            handleSellIn(item)
            handleQuality(item)
        }
    }
}
