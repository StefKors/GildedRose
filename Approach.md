# Gilded Rose Challenge  

*💬 This repo contains detailed notes on my approach to solving the [Gilded Rose Kata in Swift](https://github.com/emilybache/GildedRose-Refactoring-Kata)*  

## Technical Approach and Design Decisions  

### Preface  

If this was real life:  

1. **My first instinct would be to beeline for the goblin.** My co-worker has been at the Gilded Rose Inn much longer than I have, and they clearly have the technical knowledge and expertise to design and build software. Either they know something I don't about why changing the `Item` class and `items` property is such a terrible idea, or perhaps they have been sitting in their corner for so long that no one has bothered to ask them to update their code.  
Doing so could eliminate the main constraint of the problem and, as a result, make easier solutions possible. Or at least create opportunities for a discussion about better design solutions. *As a bonus, it might even improve the work environment, fewer chances of having a co-worker insta-rage and one-shot you, or another colleague having to cover for you to prevent goblin-human violence.*

2. If goblin-human relations were truly not possible, **still**, before digging into refactoring and software redesign, **I would speak with Allison, the innkeeper**, to understand what they actually want from the new feature. Here I'm assuming Allison wrote the requirements given that there are already quite a few UX clues that might help us decide between different software design strategies. For example, Allison thinks in terms of items ("All items have a SellIn value…", "All items have a Quality value…"). Items are described as moving through different states (stable, degrading, or improving at different rates).
Perhaps Allison wants to visualize changes rather than just show the current values, receive notifications when an item is approaching an important event or has expired, or explain unusual behaviour to prevent another clerk from throwing out the Aged Brie just before its quality starts improving. In such cases, maybe we could leave the existing Gilded Rose algorithm largely untouched and build a presentation/UX layer around it.
  
### From Real Life to the Technical Assignment  

Based on our previous discussion, I saw this challenge as a good opportunity to show some of the technical aspects of my experience that we haven’t gotten to yet. In particular:  
  
* Code review  
* Testing  
* Working with legacy code  
* Refactoring  
* Clean code principles  
* Software design patterns  
  
### My Approach  

#### Gather requirements and constraints

Before coding anything, I started by reading the kata and gathering any constraints or requirements. *In a real-world situation, I would also talk to the innkeeper, Allison, and the goblin to gather additional context about the system, including undocumented behaviours, bugs, and use cases.*  
Since this an abstract scoped assignment I used [GildedRoseRequirements.md](https://github.com/emilybache/GildedRose-Refactoring-Kata/blob/main/GildedRoseRequirements.md) as the source of truth, to make the following overview:  
  
```markdown
Constraints:
[ ] `Item` class can never change
[ ] The `items` property can never change

Basic Rules:
[ ] All items have a SellIn value which denotes the number of days we have to sell the items
[ ] All items have a Quality value which denotes how valuable the item is
[ ] At the end of each day our system lowers both values for every item

Specific Rules:
[ ] Once the sell by date has passed, Quality degrades twice as fast
[ ] The Quality of an item is never negative
[ ] The Quality of an item is never more than 50
[ ] "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
[ ] Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
[ ] Quality drops to 0 after the concert

Edge Cases:
[ ] "Aged Brie" actually increases in Quality the older it gets
[ ] "Sulfuras", being a legendary item, never has to be sold or decreases in Quality

New Rules:
[ ] "Conjured" items degrade in Quality twice as fast as normal items
```
  
#### Reviewing the existing code  

[GildedRose.swift](https://github.com/StefKors/GildedRose/blob/2491ed7d98acbde6dec635dde4728c052723f2ad/Sources/GildedRose/GildedRose.swift#L8-L58) I then went through the code for the first time and I took some quick notes of what I observed:  

* The code is not easily readable.
* Repeated magic strings matching in multiple places.
* The `Item` class is essentially just data.
* `updateQuality()` has deeply nested if/else statements up to 5 levels deep.  
  * Several chunks of `updateQuality()` perform distinct jobs and could be extracted/named  
  * Long Function —> contains all the business rules  
* Code paths are tangled, Normal items, Aged Brie, Backstage Passes, and Sulfuras are all handled within `updateQuality()`, meaning that changing the behaviour of one item type requires modifying shared logic that also impacts the others. (violation of the Single Responsibility Principle)  
* Repeated code blocks with same / similar behaviour. (not DRY)  
  
Having gone through everything, I made sure I had all the information I needed and that I didn’t have any questions. I then spent some time thinking about how I would approach this. I decided to first write a test suite to document the existing behaviour. Once that's in place, I can then tackle the long conditional through incremental refactorings. When the code is in a better state, I can safely and confidently add support for the new Conjured feature.

### Adding tests  

[Commit](https://github.com/StefKors/GildedRose/commit/2491ed7d98acbde6dec635dde4728c052723f2ad) Before touching any of the production code I implemented testing:  

* **First, I wrote a comprehensive suite of unit tests**. I started by translating the requirements and constraints I had identified for each item type into test cases, including boundary conditions such as SellIn reaching zero, quality reaching its limits, and the different behaviour of the special items.
* **Then I realised I had started from the wrong end.** Those tests describe what the code *should* do according to the requirements. On legacy code that isn't the first thing I needed to do, because I don't yet know whether the code actually matches the requirements. What I first needed is a record of what the existing code *actually does*, including any behaviour that turns out to be a bug. So I went back and wrote a **characterisation/golden master test** that runs the existing implementation for 30 days and records its output. That gave me a way to document the existing behaviours. It can then alert me if any changes to the code unintentionally alter that behaviour.
* Keeping both was worthwhile: the golden master catches accidental changes during refactoring, and the unit tests document the intended rules and pin down the boundaries.
* **I then used Xcode's built-in code coverage** to find the gaps, which got the suite to 100%. In reality of course 100% code coverage is often not possible or worth it due to time or complexity constraints.
* **Finally, I considered mutation testing.** Mutation testing would have been a useful next step because code coverage tells me which code was executed, whereas mutation testing can give me some indication of whether the tests would actually detect incorrect behaviour. However, this is a small piece of code, and setting one up from scratch in Swift is fiddly enough that pulling in an external testing library felt like overkill for the scope.
  
With this combination of unit and approval testing, I could then go into refactoring following a **Green / Green approach:** make a small structural change, run the tests, and verify that the observable behaviour remained unchanged before moving on to the next change  
  
### Refactoring

#### Step 1: Extract methods  

[Commit](https://github.com/StefKors/GildedRose/commit/8ff280c75cabe439aae79a9b455030232a45498b) In order to make the code more readable and improve clarity, I started by extracting the most deeply nested repeated code into methods: `increaseQuality`, `decreaseQuality`, `decreaseSellIn`. Then I also consolidated the magic string matching into a single place, which I temporarily mapped to an enum for now, to reduce duplication and make the code safer to change.
  
```swift
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
```
  
What is good to note is that at this point I intentionally kept most of the original structure intact. For example in instances where the original code reads:  
  
```swift
if items[i].name != "Aged Brie" && items[i].name != "Backstage passes to a TAFKAL80ETC concert"
```
  
You might be tempted to turn it around to increase readability, as such:  
  
```swift
if item.name == "Aged Brie" ||
   item.name == "Backstage passes to a TAFKAL80ETC concert"
```
  
However, these two conditions aren’t necessarily interchangeable. The original means “If this is neither Brie nor a Backstage Pass...” while the inverted condition means “If this is either Brie or a Backstage Pass...”, and would require more restructuring to maintain the original behaviour. So although some conditions could be expressed more readably, changing their logical direction also requires moving or inverting the associated behaviour. That would make this refactoring step larger and harder to verify. So I opted against it.  
  
#### Almost Step 2: Design Pattern: Chain of Responsibility  

[Commit](https://github.com/StefKors/GildedRose/commit/7d2bf07324474f25def90b08504124d43b68d278) As I began looking into untangling the nested conditional, after I simplified the basic operations around `quality` and `sellIn`. I noticed that the different items have repeated blocks of behaviour between them.

With this in mind I wanted a cleaner way of handling the different item types and their rules. Maybe because I spent a lot of time working on Web APIs, my thinking was that each item is composed of a chain of small rules that are applied in order, similar to how Web API middleware or handler chains often work. The Conjured feature pushed me in that direction too, because it isn't really a completely new set of rules, it's more of a modifier to the degradation rate of a normal item.

However as I was implmentating and I almost doing a Chain of Responsibility design pattern, I realised this wasn't the right fit. Because it was way more powerful than the problem needed, it made the control flow harder to trace, and it felt out of place from the patterns usually used in Swift.

At this point the code looked like this (before I abandoned this approach):  
  
```swift
// MARK: - Generic composable rules
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


// MARK: - Item specifics grouping the rules
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
```
  
So I took a step back and compared the trade-offs of the three options before picking my next step. I did want to keep some of the composability I had with the Chain of Responsibility version, without paying for a full rules engine, and Strategy with a small Factory turned out to be the better balance.
  
| Dimension | Strategy | Strategy w/Factory | Chain of Responsibility |
| ----------------------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Reuse | Common behaviour tends to be repeated between strategies. | Some duplication between strategies, e.g. Normal and Conjured have very similar structures. | Rules such as decreasing sellIn or doubling effects can be shared. |
| Adding a variant or item (Conjured) | New strategy type, plus editing the selection logic wherever the caller happens to pick a strategy | New strategy type + one new case in the factory; the edit stays confined to a single known place | New rule list from existing rules; maybe one new rule |
| Testability | Test each strategy; dispatch tested via enum | Test each strategy and the factory mapping in isolation; factory enables injecting test-double strategies | Test each rule in isolation plus compositions — largest surface area |
| Readability | Individual strategies are easy, but selection can become unclear. | Business rules are grouped together and easy to find by domain name. | Behaviour is distributed across multiple rules and ordering matters. |
| Complexity | Low | Moderate | High |

#### Step 2 : Design Pattern: Strategy with Factory  

[Commit](https://github.com/StefKors/GildedRose/commit/8943bbeb850051e858781e4fde7fa38d69bd5d72) Instead I refactored the code into a Strategy pattern with a small Factory for selecting the appropriate strategy. Where the Factory is responsible for mapping the items to the ItemStrategy and the Strategy is expressed through a small set of protocols. Starting with the base `ItemStrategy` protocol:
  
```swift
protocol ItemStrategy {
    func update(_ item: Item)
}

```
  
Which is used by the `QualityUpdateStrategy` and `SellInUpdateStrategy` protocols that provide reusable methods to update an `Item`.  
  
```swift
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
```
  
These generic pieces then allow for easily writing the business logic into self contained pieces of code. See for example the Aged Brie and Normal strategies below:  
  
```swift
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

```
  
The `ItemStrategyFactory` is then responsible for mapping the items to the item specific strategy:  
  
```swift
struct ItemStrategyFactory {
    func make(for item: Item) -> ItemStrategy {
        switch item.name {
        case "Aged Brie":
            return AgedBrieStrategy()
        case "Backstage passes to a TAFKAL80ETC concert":
            return BackstagePassStrategy()
        case "Sulfuras, Hand of Ragnaros":
            return SulfurasStrategy()
        default:
            return NormalStrategy()
        }
    }
}
```
  
This meant `updateQuality()` simply becomes:  
  
```swift
public func updateQuality() {
    for item in items {
        let strategy = factory.make(for: item)
        strategy.update(item)
    }
}

```
  
#### Adding new feature: Conjured items  

[Commit](https://github.com/StefKors/GildedRose/commit/afd1ce7a334bec10f35d2756022d7ac99d03e90c) With the refactored code in place adding support for the `Conjured` items becomes as simple as updating the switch and adding a `ConjuredStrategy`.

```swift
struct ConjuredStrategy: QualityUpdateStrategy, SellInUpdateStrategy {
    func update(_ item: Item) {
        decreaseSellIn(of: item)
        decreaseQuality(of: item, by: 2)
        if item.sellIn < 0 {
            decreaseQuality(of: item, by: 2)
        }
    }
}
```

```swift
        case _ where item.name.contains("Conjured"):
            return ConjuredStrategy()
```
  
#### Cleanup and Organization  

[Commit](https://github.com/StefKors/GildedRose) Finally, I spent some time cleaning up.  
  
* [Commit 223090c](https://github.com/StefKors/GildedRose/commit/223090cf9c94a904990d4c9104cbe22d6c36895a) I also made the Factory's item matching less dependent on the exact item names. For Backstage Passes, rather than matching the complete name ("Backstage passes to a TAFKAL80ETC concert"), it now checks whether the name contains "Backstage passes". This means variations in the concert name can still be recognised as Backstage Passes and mapped to the correct strategy.
* The tests are now organised around the different item strategies rather than the structure of the original requirements. This makes the tests reflect the design of the refactored code more closely.  
* [Commit 06d1a1c](https://github.com/StefKors/GildedRose/commit/06d1a1c8a9c6b357276a83a128e64f0d8748f3c3?diff=split) The strategies were moved into an `ItemStrategies` folder, making it easier for the next developer to see where the behaviour for new item types is defined and where to create a strategy when introducing new business logic.  
  
### The Layout  

Here is a quick overview of the folder structure after the Gilded Rose Kata Solution:

```markdown
Sources
├── GildedRose
│   ├── GildedRose.swift                    <- Main class that orchestrates the daily updates
│   ├── Item.swift                          <- Base data model, untouchable per the goblin in the corner
│   └── ItemStrategyFactory                 <- Folder for handling the strategy factory
│       ├── ItemStrategies                  <- Folder containing all item specific strategies
│       │   ├── AgedBrieStrategy.swift
│       │   ├── BackstagePassStrategy.swift
│       │   ├── ConjuredStrategy.swift
│       │   ├── NormalStrategy.swift
│       │   └── SulfurasStrategy.swift
│       ├── ItemStrategy.swift              <- Shared abstractions and helpers
│       └── ItemStrategyFactory.swift       <- Factory that maps item names to strategies
└── GildedRoseApp
    └── main.swift                          <- Executable entry point, runs the inn for a fixed number of days

Tests
└── GildedRoseTests
    ├── GoldenMasterTests.swift             <- 30-day characterisation snapshot, guards against regressions
    └── ItemStrategy                        <- Unit tests covering each strategy in isolation
        ├── AgedBrieStrategyTests.swift
        ├── BackstagePassStrategyTests.swift
        ├── ConjuredStrategyTests.swift
        ├── NormalStrategyTests.swift
        └── SulfurasStrategyTests.swift
  
```

## Known Limitations & Other Considerations  


* **Conjured Aged Brie** How would a Conjured Aged Brie work? There comes a point where mapping specific items to their own strategies becomes cumbersome and less maintainable. That will probably happen when we will get multiple items that have similar behaviours but with slight variations. However handling that in a more composable way can quickly become very complex as we can see with the abandoned chain of responsibility approach.
* **What happens if we run `updateQuality()` multiple times a day?** Right now that responsibility is on the caller, but it might be better to protect against this within the `updateQuality()` method itself.
* **Over-engineering:** I think there is a case to be made that this solution could have stopped after pulling up the methods. Using a switch that just calls different methods would be simpler and more straightforward. It would look something like this:

```swift
func updateQuality() {
    for item in items {
        update(item)
    }
}
 
private func update(_ item: Item) {
    switch item.name {
        case "Aged Brie": 
            updateAgedBrie(item)
        case _ where item.name.contains("Backstage passes"): 
            updateBackstagePass(item)
        case "Sulfuras, Hand of Ragnaros": 
            break
        case _ where item.name.contains("Conjured"): 
            updateConjured(item)
        default: 
            updateNormal(item)
    }
}

```

For example the `updateAgedBrie()` method would contain the exact same logic as the `AgedBrieStrategy` struct, calling `increaseQuality()`, `decreaseQuality()`, and `decreaseSellIn()` internally. That keeps the logic explicit, testable, and easy to change, while removing the file-per-item, protocol, and factory overhead. The jump to Strategy with a Factory only really pays off once you have many item types or the rules are genuinely polymorphic. For five hard-coded items in a single module it is arguably extensive and premature. If I'm being honest that part of the motivation for choosing this solution was showing that I'm familiar with established software design patterns.  
  
* **Code Size Trade-off:** The refactoring grew the code from about 57 lines inside the `updateQuality()` method at the start to a little over 100 lines of code at the end. Although the overall amount of code increased, the complexity of the `updateQuality()` method was significantly reduced by distributing the behaviour across focused strategies. Additionally this makes the codebase easier to maintain in the long run and introducing new item types or changing existing ones can be done without extensively altering the existing code.  
  
* **Future Improvements:** A good time to refactor away from item named strategies like `AgedBrieStrategy()` to something more generic like `AppreciatingItemStrategy()` is when there will be more products using the exact same strategy.  
