//
//  DruvvCard.swift
//  Swipeable-View-Stack
//
//  Created by Dhruv  Sringari on 3/18/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit


class DruvvCard: SwipeableCardViewCard {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backgroundContainerView: UIView!
    
    /// Shadow View
    private weak var shadowView: UIView?
    
    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0
    
    var viewModel: DruvvModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }
    
    private func configure(forViewModel viewModel: DruvvModel?) {
        if let viewModel = viewModel {
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            imageView.image = viewModel.image
            
            backgroundContainerView.layer.cornerRadius = 14.0
        }
    }
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: DruvvCard.kInnerMargin,
                                              y: DruvvCard.kInnerMargin,
                                              width: bounds.width - (2 * DruvvCard.kInnerMargin),
                                              height: bounds.height - (2 * DruvvCard.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Roll/Pitch Dynamic Shadow
        //        if motionManager.isDeviceMotionAvailable {
        //            motionManager.deviceMotionUpdateInterval = 0.02
        //            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
        //                if let motion = motion {
        //                    let pitch = motion.attitude.pitch * 10 // x-axis
        //                    let roll = motion.attitude.roll * 10 // y-axis
        //                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
        //                }
        //            })
        //        }
        self.applyShadow(width: CGFloat(0.0), height: CGFloat(0.0))
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.15
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }

}
