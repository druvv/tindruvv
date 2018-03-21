//
//  SwipeableStackView.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

class SwipeableCardViewContainer: UIView, SwipeableViewDelegate {

    static let horizontalInset: CGFloat = 12.0

    static let verticalInset: CGFloat = 12.0

    var dataSource: SwipeableCardViewDataSource? {
        didSet {
            reloadData()
        }
    }

    var delegate: SwipeableCardViewDelegate?

    private var cardViews: [SwipeableCardViewCard] = []

    var visibleCardViews: [SwipeableCardViewCard] {
        return subviews as? [SwipeableCardViewCard] ?? []
    }

    fileprivate var remainingCards: Int = 0

    static let numberOfVisibleCards: Int = 2

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else {
            return
        }

        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards

        for index in 0..<min(numberOfCards, SwipeableCardViewContainer.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }

        if let emptyView = dataSource.viewForEmptyCards() {
            addEdgeConstrainedSubView(view: emptyView)
        }

        setNeedsLayout()
    }

    func addCardView(cardView: SwipeableCardViewCard, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }

    private func removeAllCardViews() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }

    /// Sets the frame of a card view provided for a given index. Applies a specific
    /// horizontal and vertical offset relative to the index in order to create an
    /// overlay stack effect on a series of cards.
    ///
    /// - Parameters:
    ///   - cardView: card view to update frame on
    ///   - index: index used to apply horizontal and vertical insets
    private func setFrame(forCardView cardView: SwipeableCardViewCard, atIndex index: Int) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * SwipeableCardViewContainer.horizontalInset)
        let verticalInset = CGFloat(index) * SwipeableCardViewContainer.verticalInset

        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset

        cardView.frame = cardViewFrame
    }

}

// MARK: - SwipeableViewDelegate

extension SwipeableCardViewContainer {

    func didTap(view: SwipeableView) {
        if let cardView = view as? SwipeableCardViewCard,
            let index = cardViews.index(of: cardView) {
            delegate?.didSelect(card: cardView, atIndex: index)
        }
    }

    func didBeginSwipe(onView view: SwipeableView) {
        // React to Swipe Began?
    }

    func didEndSwipe(onView view: SwipeableView, direction: SwipeDirection) {
        guard let dataSource = dataSource else {
            return
        }
        
         if direction == .bottomLeft || direction == .topLeft || direction == .left {
            self.delegate?.tryedToSwipeLeft()
            return
        }

        // Remove swiped card
        UIView.animate(withDuration: 0.4, animations: {
            view.layer.opacity = 0
        }) { _ in
            view.removeFromSuperview()
        }

        // Only add a new card if there are cards remaining
        if remainingCards > 0 {

            // Calculate new card's index
            let newIndex = dataSource.numberOfCards() - remainingCards

            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 1)
        }
        
        if let cardView = view as? SwipeableCardViewCard {
            delegate?.didSwipe(card: cardView, toDirection: direction, last: visibleCardViews.count == 1)
        }
        
        // Update all existing card's frames based on new indexes, animate frame change
        // to reveal new card from underneath the stack of existing cards.
        for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
            UIView.animate(withDuration: 1, animations: {
                cardView.center = self.center
                self.setFrame(forCardView: cardView, atIndex: cardIndex-1)
                self.layoutIfNeeded()
            })
        }
        
        
    }

}
