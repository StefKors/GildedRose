public class GildedRose {
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    public func updateQuality() {
        let factory = ItemStrategyFactory()

        for item in items {
            let strategy = factory.make(for: item)
            strategy.update(item)
        }
    }
}
