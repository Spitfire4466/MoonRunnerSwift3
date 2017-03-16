//
//  BadgeDetailsViewController.swift
//  MoonRunner
//
//  Created by Spitfire on 01.03.17.
//  Copyright © 2017 Zedenem. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class BadgeDetailsViewController: UIViewController {
    var badgeEarnStatus: BadgeEarnStatus!
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var silverImageView: UIImageView!
    @IBOutlet weak var goldImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
  
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var bestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/8.0))
        
        nameLabel.text = badgeEarnStatus.badge.name
        
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: badgeEarnStatus.badge.distance!)
        distanceLabel.text = distanceQuantity.description
        badgeImageView.image = UIImage(named: badgeEarnStatus.badge.imageName!)
        
        if let run = badgeEarnStatus.earnRun {
            earnedLabel.text = "Reached on " + formatter.string(from: run.timestamp)
        }
        
        if let silverRun = badgeEarnStatus.silverRun {
            silverImageView.transform = transform
            silverImageView.isHidden = false
            silverLabel.text = "Earned on " + formatter.string(from: silverRun.timestamp)
        }
        else {
            silverImageView.isHidden = true
            /*let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
            let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: badgeEarnStatus.earnRun!.duration.doubleValue / badgeEarnStatus.earnRun!.distance.doubleValue)*/
            silverLabel.text = "Walk faster > \(String((badgeEarnStatus.earnRun!.distance.doubleValue/badgeEarnStatus.earnRun!.duration.doubleValue*3.6*10).rounded()/10)) km/h for silver!"
        }
        
        if let goldRun = badgeEarnStatus.goldRun {
            goldImageView.transform = transform
            goldImageView.isHidden = false
            goldLabel.text = "Earned on " + formatter.string(from: goldRun.timestamp)
        }
        else {
            goldImageView.isHidden = true
            /*let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
            let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: badgeEarnStatus.earnRun!.duration.doubleValue / badgeEarnStatus.earnRun!.distance.doubleValue)*/
            
            goldLabel.text = "Walk faster > \(String((badgeEarnStatus.earnRun!.distance.doubleValue/badgeEarnStatus.earnRun!.duration.doubleValue*3.6*10).rounded()/10)) km/h for gold!"
        }
        
        if let bestRun = badgeEarnStatus.bestRun {
            /*let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
            let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: bestRun.duration.doubleValue / bestRun.distance.doubleValue)*/
            bestLabel.text = "Best: \(String((bestRun.distance.doubleValue/bestRun.duration.doubleValue*3.6*10).rounded()/10)), \(formatter.string(from: bestRun.timestamp)) km/h"
        }
    }
}
