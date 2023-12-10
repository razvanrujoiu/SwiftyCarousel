```markdown
# SwiftyCarousel

SwiftyCarousel is a Swift library for creating a customizable carousel component in SwiftUI. It provides an easy way to display a collection of items in a carousel format with various customization options.

## Features

- Display a carousel of items
- Customizable card width, height, and spacing
- Zoom in/out effect for inactive cards
- Adjust carousel spacing with inactive card width
- Set card corner radius
- Show/hide paging indicator with customizable colors and size
- Supports any SwiftUI Views as items
- Requires a minimum version of iOS 15

## Installation

You can install SwiftyCarousel using Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/razvanrujoiu/SwiftyCarousel.git", from: "1.0.0")
]
```

## Usage

### Import SwiftyCarousel

```swift
import SwiftyCarousel
```

### Create a SwiftyCarousel

```swift
struct ContentView: View {
    let items: [AnyView] // Make sure items conform to View
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let spacing: CGFloat
    let inactiveCardHeight: CGFloat
    let inactiveCardWidth: CGFloat
    let cardCornerRadius: CGFloat
    let showPagingIndicator: Bool
    let pagingIndicatorActiveColor: Color
    let pagingIndicatorInactiveColor: Color
    let pagingIndicatorSize: CGFloat

    var body: some View {
        SwiftyCarousel(
            items: items,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            spacing: spacing,
            inactiveCardHeight: inactiveCardHeight,
            inactiveCardWidth: inactiveCardWidth,
            cardCornerRadius: cardCornerRadius,
            showPagingIndicator: showPagingIndicator,
            pagingIndicatorActiveColor: pagingIndicatorActiveColor,
            pagingIndicatorInactiveColor: pagingIndicatorInactiveColor,
            pagingIndicatorSize: pagingIndicatorSize
        )
    }
}
```

### Example

```swift
let sampleItems: [AnyView] = [
    AnyView(Text("Item 1")),
    AnyView(Image(systemName: "star.fill")),
    AnyView(Rectangle().foregroundColor(.blue))
]

struct ContentView: View {
    var body: some View {
        SwiftyCarousel(
            items: sampleItems,
            cardWidth: 200,
            cardHeight: 150,
            spacing: 16,
            inactiveCardHeight: 120,
            inactiveCardWidth: 100,
            cardCornerRadius: 10,
            showPagingIndicator: true,
            pagingIndicatorActiveColor: .blue,
            pagingIndicatorInactiveColor: .gray,
            pagingIndicatorSize: 8
        ).environmentObject(CarouselState())
    }
}
```

## Parameters

### `items: [AnyView]`

An array of SwiftUI Views that will be displayed in the carousel. Ensure that each item conforms to the `View` protocol.

### `cardWidth: CGFloat`

The width of each card in the carousel.

### `cardHeight: CGFloat`

The height of each card in the carousel.

### `spacing: CGFloat`

The spacing between the cards.

### `inactiveCardHeight: CGFloat`

The height of inactive cards for the zoom in/out effect when swiping between cards.

### `inactiveCardWidth: CGFloat`

Adjusts the carousel spacing by specifying the width of inactive cards.

### `cardCornerRadius: CGFloat`

The radius of the cards.

### `showPagingIndicator: Bool`

A flag to show/hide the paging indicator.

### `pagingIndicatorActiveColor: Color`

The color of the active paging indicator dot.

### `pagingIndicatorInactiveColor: Color`

The color of the inactive paging indicator dots.

### `pagingIndicatorSize: CGFloat`

The size of the paging indicator dots.

## License

SwiftyCarousel is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
```
