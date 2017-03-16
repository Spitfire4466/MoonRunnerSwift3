//
//  Badges.swift
//  MoonRunner
//
//  Created by Spitfire on 01.03.17.
//  Copyright © 2017 Zedenem. All rights reserved.
//

import Foundation

let silverMultiplier = 1.05 // 5% speed increase
let goldMultiplier = 1.10 // 10% speed increase

class Badge {
    let name: String?
    let imageName: String?
    let information: String?
    let distance: Double?
    
    init(json: [String: String]) {
        name = json["name"]
        information = json["information"]
        imageName = json["imageName"]
        distance = (json["distance"] as? NSString)?.doubleValue
    }
}
class BadgeController {
    static let sharedController = BadgeController()
    
    lazy var badges : [Badge] = {
        var _badges = [Badge]()
        
        let filePath = Bundle.main.path(forResource: "badges", ofType: "json") as String!
        //let jsonData = NSData.dataWithContentsOfMappedFile(filePath!) as! NSData
        let jsonData: NSData?
        do {
            jsonData = try NSData(contentsOfFile: filePath!, options: NSData.ReadingOptions.alwaysMapped)
        } catch _ {
            jsonData = nil
        }
        
        do{
            let jsonBadges = try? JSONSerialization.jsonObject(with: jsonData as! Data,
                                             options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, String>]
            if (jsonBadges != nil){
                for jsonBadge in jsonBadges!! {
                    _badges.append(Badge(json: jsonBadge))
                }
            }
        }
        return _badges
    }()
    
    func badgeEarnStatusesForRuns(runs: [Run]) -> [BadgeEarnStatus] {
        var badgeEarnStatuses = [BadgeEarnStatus]()
        
        for badge in badges {
            let badgeEarnStatus = BadgeEarnStatus(badge: badge)
            
            for run in runs {
                if run.distance.doubleValue > badge.distance! {
                    
                    // This is when the badge was first earned
                    if badgeEarnStatus.earnRun == nil {
                        badgeEarnStatus.earnRun = run
                    }
                    
                    let earnRunSpeed = badgeEarnStatus.earnRun!.distance.doubleValue / badgeEarnStatus.earnRun!.duration.doubleValue
                    let runSpeed = run.distance.doubleValue / run.duration.doubleValue
                    
                    // Does it deserve silver?
                    if badgeEarnStatus.silverRun == nil && runSpeed > earnRunSpeed * silverMultiplier {
                        badgeEarnStatus.silverRun = run
                    }
                    
                    // Does it deserve gold?
                    if badgeEarnStatus.goldRun == nil && runSpeed > earnRunSpeed * goldMultiplier {
                        badgeEarnStatus.goldRun = run
                    }
                    
                    // Is it the best for this distance?
                    if let bestRun = badgeEarnStatus.bestRun {
                        let bestRunSpeed = bestRun.distance.doubleValue / bestRun.duration.doubleValue
                        if runSpeed > bestRunSpeed {
                            badgeEarnStatus.bestRun = run
                        }
                    }
                    else {
                        badgeEarnStatus.bestRun = run
                    }
                }
            }
            
            badgeEarnStatuses.append(badgeEarnStatus)
        }
        
        return badgeEarnStatuses
    }
    func bestBadgeForDistance(distance: Double) -> Badge {
        var bestBadge = badges.first as Badge!
        for badge in badges {
            if distance < badge.distance! {
                break
            }
            bestBadge = badge
        }
        return bestBadge!
    }
    
    func nextBadgeForDistance(distance: Double) -> Badge {
        var nextBadge = badges.first as Badge!
        for badge in badges {
            nextBadge = badge
            if distance < badge.distance! {
                break
            }
        }
        return nextBadge!
    }
}
class BadgeEarnStatus {
    let badge: Badge
    var earnRun: Run?
    var silverRun: Run?
    var goldRun: Run?
    var bestRun: Run?
    
    init(badge: Badge) {
        self.badge = badge
    }
}
