//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/3/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicator {    
    func sendMessage(string : String, to userID : String, completionHandler : ((_ success : Bool, _ error : Error?) -> ())?)
    var delegate: ICommunicationManager? {get set}
    var online: Bool {get set}
    func start()
    func stop()
    var myDisplayName: String {get set}
}

class MultipeerCommunicator : NSObject, ICommunicator {
    
    private let serviceType = "tinkoff-chat"
    private let advertiserService : MCNearbyServiceAdvertiser
    private let browserService : MCNearbyServiceBrowser
    private let myPeerID : MCPeerID = MCPeerID(displayName: (UIDevice.current.identifierForVendor?.uuidString)!)
    private let discoveryInfo = ["userName": "Ilia 7 Varfolomeev"]
    
    weak var delegate: ICommunicationManager?
    
    var online: Bool
    var myDisplayName: String
    var sessions : [String : MCSession] = [String : MCSession]()
    
    override init() {
        self.advertiserService = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: self.discoveryInfo, serviceType: self.serviceType)
        self.browserService = MCNearbyServiceBrowser(peer: self.myPeerID, serviceType: self.serviceType)
        self.online = true
        self.myDisplayName = self.myPeerID.displayName
        super.init()
        self.advertiserService.delegate = self
        self.browserService.delegate = self        
    }
    
    func start() {
        self.browserService.startBrowsingForPeers()
        self.advertiserService.startAdvertisingPeer()
    }
    
    func stop() {
        self.browserService.stopBrowsingForPeers()
        self.advertiserService.stopAdvertisingPeer()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        let messageJson = [ "eventType" : "TextMessage",
                            "messageId" : Message.generateMessageId(),
                            "text" : string ]
        do {
            let messageData = try JSONSerialization.data(withJSONObject: messageJson, options: [])
            if let session = self.sessions[userID] {
                try session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
            }
        } catch let error {
            print("MultipeerCommunicator: Ошибка сериализации или отправки")
            completionHandler?(false, error)
        }
        
        completionHandler?(true, nil)
    }
}

// MARK: - Advertiser Delegate
extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        var session = self.sessions[peerID.displayName]
        if session == nil {
            session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
            session!.delegate = self
            self.sessions[peerID.displayName] = session
        }
        
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        self.delegate?.failedToStartAdvertising(error: error)
    }
}

// MARK: Browser Delegate
extension MultipeerCommunicator : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard peerID.displayName != myPeerID.displayName else {
            return
        }
        
        guard let userInfo = info else {
            return
        }
        
        guard let userName = userInfo["userName"] else {
            return
        }
        
        var session = self.sessions[peerID.displayName]
        if session == nil {
            session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
            session!.delegate = self
            self.sessions[peerID.displayName] = session
        }
        
        browser.invitePeer(peerID, to: session!, withContext: nil, timeout: 30)
        self.delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
       self.delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        self.delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

// MARK: - Session Delegate
extension MultipeerCommunicator : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Пользователь \(peerID.displayName) подключен")
        case .connecting:
            print("Пользователь \(peerID.displayName) подключается")
        default:
            print("Пользователь \(peerID.displayName) отключен")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONSerialization.jsonObject(with: data, options: [])
            guard let incomingMessage = message as? [String: String] else {
                return
            }
            
            guard let incomingMessageText = incomingMessage["text"] else {
                return
            }
            
            self.delegate?.didReceiveMessage(text: incomingMessageText, fromUser: peerID.displayName, toUser: self.myPeerID.displayName)
        } catch {
            print("MultipeerCommunicator: Ошибка десериализации")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
}
