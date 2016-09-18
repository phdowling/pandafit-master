//
//  InterfaceController.swift
//  PandaFit WatchKit Extension
//
//  Created by Felix Sonntag on 16/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class StatusInterfaceController: WKInterfaceController {

    @IBOutlet var imageBackgroundGroup: WKInterfaceGroup!
    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var moodLabel: WKInterfaceLabel!
    @IBOutlet var scoreLabel: WKInterfaceLabel!
    
    let networkController: PGNetworkController = PGNetworkController()
    
    var name: String? = nil
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    var panda: Panda? {
        didSet {
            if let panda = panda {
                moodLabel.setText("\(panda.name) is \(panda.mood)")
                scoreLabel.setText(panda.score.description)
                
                let duration = 1.5
                switch panda.mood {
                case .ecstatic:
                    image.setImageNamed("ecstatic")
                    imageBackgroundGroup.setBackgroundColor(UIColor(red: 0.0, green: 153/255, blue: 1.0, alpha: 1.0))
                case .happy:
                    image.setImageNamed("happy")
                    imageBackgroundGroup.setBackgroundColor(UIColor(red: 0.0, green: 153/255, blue: 1.0, alpha: 1.0))
                case .content:
                    image.setImageNamed("content")
                    imageBackgroundGroup.setBackgroundColor(UIColor.blue)
                case .angry:
                    image.setImageNamed("angry")
                    imageBackgroundGroup.setBackgroundColor(UIColor(red: 1.0, green: 102/255, blue: 0.0, alpha: 1.0))
                case .dying:
                    image.setImageNamed("dying")
                    imageBackgroundGroup.setBackgroundColor(UIColor(red: 102/255, green: 0.0, blue: 0.0, alpha: 1.0))
                }
                
                image.startAnimatingWithImages(in: NSRange(location:0, length: 2), duration: duration, repeatCount: 0)
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.session = WCSession.default()
        self.session?.activate()
        
        DispatchQueue.global(qos: .background).async {
            while true {
                self.session?.sendMessage(["user" : ""], replyHandler: { (response) in
                    if let name = response["name"] as? String {
                        print("Got name: \(name)")
                        self.name = name
                    }
                    
                }) { (error) in
                    print("Error getting user from iPhone: \(error)")
                }
                
                if let name = self.name {
                    self.networkController.getPandaState(name: name, completion: { (newPanda) in
                        self.panda = newPanda
                    })
                } else {
//                    TODO uncomment this for demo maybe
//                    print("Watch couldn't get name, set name to 'Felix'")
//                    let name = "Felix"
//                    self.networkController.getPandaState(name: name, completion: { (newPanda) in
//                        self.panda = newPanda
//                    })
                }
                sleep(5)
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension StatusInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Session activcation failed with error: \(error.localizedDescription)")
            return
        }
    }
}
