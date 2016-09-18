//
//  ViewController.swift
//  PandaFit
//
//  Created by Felix Sonntag on 16/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameMoodLabel: UILabel!
    
    let networkController = PGNetworkController()

    var panda: Panda? {
        didSet {
            if let panda = panda {
                moodLabel.text = "\(panda.mood)".uppercased()
                scoreLabel.text = panda.score.description
                nameMoodLabel.text = "\(panda.name)'s Mood"
                
                switch panda.mood {
                case .ecstatic:
                    imageView.animationImages = [UIImage(named: "ecstatic1")!, UIImage(named: "ecstatic2")!]
                case .happy:
                    imageView.animationImages = [UIImage(named: "happy1")!, UIImage(named: "happy2")!]
                case .content:
                    imageView.animationImages = [UIImage(named: "content1")!, UIImage(named: "content2")!]
                case .angry:
                    imageView.animationImages = [UIImage(named: "angry1")!, UIImage(named: "angry2")!]
                case .dying:
                    imageView.animationImages = [UIImage(named: "dying1")!, UIImage(named: "dying2")!]
                }
                imageView.animationDuration = 1.0
                
                imageView.startAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            while true {
                if let name = UserDefaults.standard.value(forKey: "name") as? String {
                    self.networkController.getPandaState(name: name, completion: { (newPanda) in
                        self.panda = newPanda
                    })
                }
                sleep(10)
            }
        }
    }
    
    func updateViews(score: Int) {
        if let panda = panda {
            panda.score = score
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

