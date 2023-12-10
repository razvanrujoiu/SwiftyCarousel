//
//  SwiftyCarousel.swift
//  SwiftyCarousel
//
//  Created by Razvan Rujoiu on 09.12.2023.
//

import SwiftUI

public struct Constants {
    public static let spacing: CGFloat = 16
    public static let cardWidth: CGFloat = UIScreen.width * 0.7
    public static let cardHeight: CGFloat = cardWidth * 0.66
    public static let inactiveCardWidth: CGFloat = cardWidth * 0.15
    public static let cardRadius: CGFloat = 12
    public static let cardShadowRadius: CGFloat = 6
}

public class CarouselState: ObservableObject {
    @Published var activeCardIndex: Int = 0
    @Published var screenDrag: Float = 0.0
    
    public init(activeCardIndex: Int, screenDrag: Float) {
        self.activeCardIndex = activeCardIndex
        self.screenDrag = screenDrag
    }
}

struct CarouselCard<Content: View>: View {
    @EnvironmentObject var carouselState: CarouselState
    let index: Int
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let cardCornerRadius: CGFloat
    var inactiveCardHeight: CGFloat?
    let content: Content
    
    @inlinable init(index: Int,
                    cardWidth: CGFloat,
                    cardHeight: CGFloat,
                    cardCornerRadius: CGFloat,
                    inactiveCardHeight: CGFloat? = nil,
                    @ViewBuilder _ content: () -> Content) {
        self.index = index
        self.cardWidth = cardWidth
        self.cardHeight = cardHeight
        self.cardCornerRadius = cardCornerRadius
        self.inactiveCardHeight = inactiveCardHeight
        self.content = content()
    }
    
    var body: some View {
        content
            .cornerRadius(cardCornerRadius)
            .frame(width: cardWidth, height: carouselState.activeCardIndex == index ? cardHeight : inactiveCardHeight ?? cardHeight)
            .shadow(radius: 6)
            .transition(.slide)
            .animation(.spring(response: 0.4, dampingFraction: 0.9))
    }
}

struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat
    var spacing: CGFloat
    var inactiveCardWidth: CGFloat
    let totalSpacing: CGFloat
    var cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    @EnvironmentObject var carouselState: CarouselState
    
    @inlinable public init(
        numberOfItems: Int,
        spacing: CGFloat,
        cardWidth: CGFloat,
        inactiveCardWidth: CGFloat,
        @ViewBuilder _ items: () -> Items) {
            self.items = items()
            self.spacing = spacing
            self.cardWidth = cardWidth
            self.inactiveCardWidth = inactiveCardWidth
            self.numberOfItems = CGFloat(numberOfItems)
            self.totalSpacing = (self.numberOfItems - 1) * spacing
            self.cardWidth = UIScreen.width - (inactiveCardWidth * 2) - (spacing * 2)
        }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.width) / 2
        let leftPadding = inactiveCardWidth + spacing
        let totalMovement = cardWidth + spacing
        
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(carouselState.activeCardIndex))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(carouselState.activeCardIndex) + 1)
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + carouselState.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            carouselState.screenDrag = Float(currentState.translation.width)
        }.onEnded { value in
            self.carouselState.screenDrag = 0
            
            if (value.translation.width < -50) && carouselState.activeCardIndex < Int(numberOfItems) - 1 {
                carouselState.activeCardIndex = carouselState.activeCardIndex + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            
            if (value.translation.width > 50) && carouselState.activeCardIndex > 0 {
                carouselState.activeCardIndex = carouselState.activeCardIndex - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}

public struct SwiftyCarousel<T: View>: View where T:Hashable {
    @EnvironmentObject var carouselState: CarouselState
    public let items: [T]
    public var cardWidth: CGFloat
    public var cardHeight: CGFloat
    public var spacing: CGFloat
    public var inactiveCardHeight: CGFloat?
    public var inactiveCardWidth: CGFloat
    public var cardCornerRadius: CGFloat
    public var showPagingIndicator: Bool
    public var pagingIndicatorActiveColor: Color
    public var pagingIndicatorInactiveColor: Color
    
    public init(items: [T],
         cardWidth: CGFloat = Constants.cardWidth,
         cardHeight: CGFloat = Constants.cardHeight,
         spacing: CGFloat = Constants.spacing,
         inactiveCardHeight: CGFloat? = nil,
         inactiveCardWidth: CGFloat = Constants.inactiveCardWidth,
         cardCornerRadius: CGFloat = Constants.cardRadius,
         showPagingIndicator: Bool = true,
         pagingIndicatorActiveColor: Color = .blue,
         pagingIndicatorInactiveColor: Color = .gray) {
        self.items = items
        self.cardWidth = cardWidth
        self.cardHeight = cardHeight
        self.spacing = spacing
        self.inactiveCardHeight = inactiveCardHeight
        self.inactiveCardWidth = inactiveCardWidth
        self.cardCornerRadius = cardCornerRadius
        self.showPagingIndicator = showPagingIndicator
        self.pagingIndicatorActiveColor = pagingIndicatorActiveColor
        self.pagingIndicatorInactiveColor = pagingIndicatorInactiveColor
    }
        
    public var body: some View {
        VStack(spacing: 16) {
            Carousel(numberOfItems: items.count,
                     spacing: spacing,
                     cardWidth: cardWidth,
                     inactiveCardWidth: inactiveCardWidth) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    CarouselCard(index: index,
                                 cardWidth: cardWidth,
                                 cardHeight: cardHeight,
                                 cardCornerRadius: cardCornerRadius,
                                 inactiveCardHeight: inactiveCardHeight) {
                        item
                    }
                }
            }
            if showPagingIndicator {
                PagingIndicator()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func PagingIndicator() -> some View {
        HStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Circle()
                    .fill(index == carouselState.activeCardIndex ? pagingIndicatorActiveColor : pagingIndicatorInactiveColor)
                    .frame(width: 8, height: 8)
            }
        }
    }
}

extension UIScreen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let screenSize = UIScreen.main.bounds.size
}
