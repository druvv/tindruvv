//
//  ViewController.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.`
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import JSSAlertView

class ViewController: UIViewController, SwipeableCardViewDataSource {
    
    @IBOutlet var heySayuri: UILabel!
    @IBOutlet var prom: UILabel!
    @IBOutlet var like: UIButton!
    @IBOutlet var dislike: UIButton!
    @IBOutlet var yes: UIButton!
    @IBOutlet var no: UIButton!
    
    var impactGenerator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    var showedLoading = false
    

    @IBOutlet private weak var swipeableCardView: SwipeableCardViewContainer!
    var viewModels: [DruvvModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        swipeableCardView.dataSource = self
        swipeableCardView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !showedLoading {
            performSegue(withIdentifier: "loadingVC", sender: self)
            showedLoading = true
        } else {
            let alert = JSSAlertView().show(self,
                                title: "Welcome to Tindruvv.",
                                text: "Swipe the card off to the right to like, left to dislike.",
                                color: #colorLiteral(red: 1, green: 0.229652375, blue: 0.2657560408, alpha: 1))
            alert.setTextTheme(.light)
            alert.addAction {
                self.insertCards()
            }
        }

    }
    
    @IBAction func sheSaidYes() {
        let flowers = """
                      🌹🌹🌹
                      🌹💐🌹
                      🌹🌹🌹
                      """
        JSSAlertView().show(self,
                            title: "Yayy!",
                            text: flowers)
        
    }
    
    @IBAction func ripDruvv() {
        fatalError("Ripp")
    }
    
    func insertCards() {
        let druvv1 = DruvvModel(title: "Dhruv Sringari", subtitle: "I just wanna say hi.", image: #imageLiteral(resourceName: "ohHi"))
        let druvv7 = DruvvModel(title: "Clueless Dhruv", subtitle: "How do I use tindruvv?", image: #imageLiteral(resourceName: "druvv3"))
        let druvv2 = DruvvModel(title: "No More Chen Druvv", subtitle: "What is wchen's existance?", image: #imageLiteral(resourceName: "wtfchen"))
        let druvv3 = DruvvModel(title: "Tired Druvv", subtitle: "It's probably not 10:30 yet.", image: UIImage(named: "druvv2")!)
        let druvv8 = DruvvModel(title: "Sup", subtitle: "Too good for this app.", image: #imageLiteral(resourceName: "IMG_1130"))
        let druvv4 = DruvvModel(title: "Chantal Alano", subtitle: "Confused? Keep going.", image: #imageLiteral(resourceName: "bonusChantal"))
        let druvv5 = DruvvModel(title: "No I'm Kevin", subtitle: "This is what happens when I try to take a good selfie.", image: #imageLiteral(resourceName: "kevinSmile"))
        let druvv6 = DruvvModel(title: "Best Gang", subtitle: "I'm the one on the right.", image: #imageLiteral(resourceName: "gang"))
        viewModels = [druvv1,druvv7, druvv5, druvv3,druvv8, druvv4, druvv2,druvv6]
          self.swipeableCardView.reloadData()
        UIView.animate(withDuration: 1) {
            self.like.alpha = 1
            self.dislike.alpha = 1
            self.swipeableCardView.alpha = 1
        }
    }
    
    func showProm() {
        let cX = self.view.center.x
        let cY = self.view.center.y
        // Hey Sayuri
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.like.alpha = 0
            self.dislike.alpha = 0
            self.heySayuri.alpha = 1
            
            let hW = self.heySayuri.frame.width
            let hH = self.heySayuri.frame.height
            self.heySayuri.frame = CGRect(x: cX - hW / 2, y: cY - hH - 32, width: hW, height: hH)
        }, completion: nil)
        // Prom
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            let pW = self.prom.frame.width
            let pH = self.prom.frame.height
            self.prom.alpha = 1
            self.prom.frame = CGRect(x: cX - pW / 2, y: cY, width: pW, height: pH)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.yes.isHidden = false
                self.yes.alpha = 1
                self.no.alpha = 1
                self.no.isHidden = false

            })
        })
    }

}


extension ViewController: SwipeableCardViewDelegate {
    func didSelect(card: SwipeableCardViewCard, atIndex index: Int) {
        
    }
    
    func tryedToSwipeLeft() {
        impactGenerator.notificationOccurred(.error)
        let alertview = JSSAlertView().show(self,
                                            title: "Whoops!",
                                            text: "Failed to dislike.",
                                            noButtons: false,
                                            buttonText: "Ok",
                                            cancelButtonText: nil,
                                            color: UIColorFromHex(0xe74c3c, alpha: 1),
                                            iconImage: nil,
                                            delay: 0.5,
                                            timeLeft: nil)
        alertview.setTextTheme(.light)
    }
    
    func didSwipe(card: SwipeableCardViewCard, toDirection direction: SwipeDirection, last: Bool) {
        if direction == .bottomRight || direction == .right || direction == .topRight {
            let alert = JSSAlertView().show(self,
                               title: "Liked",
                               text: nil,
                               noButtons: true,
                               buttonText: nil,
                               cancelButtonText: nil,
                               color: UIColorFromHex(0x2ecc71, alpha: 1),
                               iconImage: nil,
                               delay: 0.5,
                               timeLeft: nil)
            if last {
                alert.addAction(showProm)
            }
            impactGenerator.notificationOccurred(.success)
        }
    }
}


// MARK: - SwipeableCardViewDataSource

extension ViewController {

    func numberOfCards() -> Int {
        return viewModels.count
    }

    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let viewModel = viewModels[index]
        let cardView = DruvvCard()
        cardView.viewModel = viewModel
        return cardView
    }

    func viewForEmptyCards() -> UIView? {
        return nil
    }

}

