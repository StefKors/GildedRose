public class GildedRose {
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
    
    private let factory = ItemStrategyFactory()

    public func updateQuality() {
        for item in items {
            let strategy = factory.make(for: item)
            strategy.update(item)
        }
    }
}
