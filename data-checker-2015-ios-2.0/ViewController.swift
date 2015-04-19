//
//  ViewController.swift
//  data-checker-2015-ios-2.0
//
//  Created by Citrus Circuits on 4/18/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import UIKit

let path = DBPath.root().childPath("Database File").childPath("pre_champs_testing.realm")

class ViewController: UIViewController {

    @IBOutlet weak var display: UITextView!
    var competition: Competition!
    var matches: [Match]!
    
    enum ChangePacket: Int {
        case redScout1 = 0
        case redScout2 = 1
        case redScout3 = 2
        case blueScout1 = 3
        case blueScout2 = 4
        case blueScout3 = 5
        case redSuper = -1
        case blueSuper = 6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "databaseUpdated:", name: CC_NEW_REALM_NOTIFICATION, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadUIBecauseDropboxIsLinkedNow", name: CC_DROPBOX_LINK_NOTIFICATION, object: nil)

        CCRealmSync.setRealmDropboxPath(path)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        CCDropboxLinkingAppDelegate.getCCDropboxAppDelegate().possiblyLinkFromController(self)
    }

    @IBAction func missingChangePacketsTapped() {
        displayMissingChangePackets(findMissingChangePackets())
    }
    
    func databaseUpdated(note: NSNotification) {
        println("Database updated.")
        missingChangePacketsTapped()
    }
    
    func reloadUIBecauseDropboxIsLinkedNow() {
        println("Dbx linked.")
        missingChangePacketsTapped()
    }
    
    func findCompetition(realm: RLMRealm) -> Competition? {
        competition = Competition.allObjectsInRealm(realm).firstObject() as? Competition
        return competition
    }
    
    func hasBeenPlayed(match: Match) -> Bool {
        var teamsHavePlayed = false
        for timData in (rlmArrayToArray(match.teamInMatchDatas) as! [TeamInMatchData]) {
            if timData.uploadedData.maxFieldToteHeight != -1 || timData.uploadedData.stackPlacing != -1 {
                teamsHavePlayed == true
            }
        }
        
        return match.officialRedScore != -1 || match.officialBlueScore != -1 || teamsHavePlayed
    }
    
    func findPlayedMatches(realm: RLMRealm) -> AnyObject {
        var playedMatches: [Match] = []
        if let matches = competition.matches where matches.count > 0 {
            for i in 0...(matches.count - 1) {
                let match = matches[i] as! Match
                if hasBeenPlayed(match) {
                    playedMatches.append(match)
                }
            }
        }
        
        matches = playedMatches
        return playedMatches
    }
    
    func missingChangePacketsInMatch(match: Match) -> [ChangePacket] {
        var missing: [ChangePacket] = []
        for timData in (rlmArrayToArray(match.teamInMatchDatas) as! [TeamInMatchData]) {
            if timData.uploadedData.maxFieldToteHeight == -1 {
                if contains((rlmArrayToArray(match.redTeams) as! [Team]).map( { $0.number } ), timData.team.number) {
                    missing.append(ChangePacket(rawValue: find((rlmArrayToArray(match.redTeams) as! [Team]).map( { $0.number } ), timData.team.number)!)!)
                }
                if contains((rlmArrayToArray(match.blueTeams) as! [Team]).map( { $0.number } ), timData.team.number) {
                    missing.append(ChangePacket(rawValue: find((rlmArrayToArray(match.blueTeams) as! [Team]).map( { $0.number } ), timData.team.number)! + 3)!)
                }
            }
            if timData.uploadedData.stackPlacing == -1 {
                if contains((rlmArrayToArray(match.redTeams) as! [Team]).map( { $0.number } ), timData.team.number) {
                    if !contains(missing, ChangePacket.redSuper) {
                        missing.append(ChangePacket(rawValue: -1)!)
                    }
                }
                if contains((rlmArrayToArray(match.blueTeams) as! [Team]).map( { $0.number } ), timData.team.number) {
                    if !contains(missing, ChangePacket.blueSuper) {
                        missing.append(ChangePacket(rawValue: 6)!)
                    }
                }
            }
        }
        
        return missing
    }
    
    func findMissingChangePackets() -> [Match: [ChangePacket]] {
        var missing = [Match: [ChangePacket]]()
        if let competition = objectFromRealm(findCompetition) as? Competition,
           let matches = objectFromRealm(findPlayedMatches) as? [Match] {
            for match in matches {
                missing[match] = missingChangePacketsInMatch(match)
            }
        }
        
        return missing
    }
    
    @IBAction func shareMissingData() {
        let textToShare = "Hello,\nOn behalf of the app programmers, please make sure that the following data gets reuploaded:\n\n" + display.text + "\nThank you very much!\n--The App Team\n"
        let kittyPic:UIImage = UIImage(named: "kittyLime")!
        let activityItems = [textToShare, kittyPic]
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: activityItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    func displayMissingChangePackets(missing: [Match: [ChangePacket]]) {
        let toDisplay = NSMutableAttributedString()
        for match in matches {
            for missingPacket in missing[match]! {
                toDisplay.appendAttributedString(changePacketToMissingMessage(missingPacket, match: match.0))
            }
            toDisplay.appendAttributedString(NSAttributedString(string: "\n"))
        }
        
        display.attributedText = toDisplay
    }
    
    let colorMap = [true : UIColor.redColor(), false : UIColor.blueColor()]
    func changePacketToMissingMessage(packet: ChangePacket, match: Match) -> NSAttributedString {
        return NSAttributedString(string: changePacketMessage(packet, match: match), attributes: [NSForegroundColorAttributeName : colorMap[isRed(packet)]!])
    }
    
    let packetColorMap = [true : "Red", false : "Blue"]
    let superMap = [true : "Super", false : "Regular Scout"]
    func changePacketMessage(packet: ChangePacket, match: Match) -> String {
        let index = packet.rawValue
        if isSuper(packet) {
            return "\(packetColorMap[isRed(packet)]!) Super in Match \(match.match)\n"
        } else {
            return "\(packetColorMap[isRed(packet)]!) Scout for Team \(changePacketToTeamNumber(packet, inMatch: match)) in Match \(match.match)\n"
        }
    }
    
    func isSuper(packet : ChangePacket) -> Bool {
        return packet.rawValue == -1 || packet.rawValue == 6
    }
        
    func isRed(packet : ChangePacket) -> Bool {
        return packet.rawValue < 3
    }
    
    func changePacketToTeamNumber(packet : ChangePacket, inMatch match : Match) -> Int {
        if isRed(packet) {
            return match.redTeams[UInt(packet.rawValue)].number
        } else {
            return match.blueTeams[UInt(packet.rawValue - 3)].number
        }
    }

    func objectFromRealm(function: (RLMRealm) -> AnyObject?) -> AnyObject? {
        var object: AnyObject? = nil
        CCRealmSync.defaultReadonlyDropboxRealm({ (realm: RLMRealm!) in
            object = function(realm)
        })
        
        return object
    }
    
    func rlmArrayToArray(rlmArray: RLMArray) -> [RLMObject] {
        var a: [RLMObject] = []
        for i in 0...(rlmArray.count - 1) {
            a.append(rlmArray.objectAtIndex(i) as! RLMObject)
        }
        
        return a
    }
}

