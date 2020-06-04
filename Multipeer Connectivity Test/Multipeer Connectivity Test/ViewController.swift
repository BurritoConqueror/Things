//
//  ViewController.swift
//  Multipeer Connectivity Test
//
//  Created by 90302781 on 5/18/20.
//  Copyright © 2020 90302781. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import MapKit
class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
   
    

    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    var Location = CLLocation()
    var recievedMessage = ""
    @IBOutlet weak var sendMessage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConectivity()
        
    }
    func setUpConectivity() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    @IBAction func startConnectivity(_ sender: Any) {
         let actionSheet = UIAlertController(title: "ToDo Exchange", message: "Do you want to Host or Join a session?", preferredStyle: .actionSheet)
               
               actionSheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action:UIAlertAction) in
                   
                self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
                self.mcAdvertiserAssistant.start()
                   
               }))
               
               actionSheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action:UIAlertAction) in
                   let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
                   mcBrowser.delegate = self
                   self.present(mcBrowser, animated: true, completion: nil)
               }))
               
               actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               
               self.present(actionSheet, animated: true, completion: nil)
               
    }
    @IBAction func sendMessage(_ sender: Any) {
        let msg = "hi"

        let message = msg.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        do{
            try self.mcSession.send(message!, toPeers: self.mcSession.connectedPeers, with: .reliable)
        }catch{
            fatalError()
        }
        
        
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
       }
       
       func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.recievedMessage = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as! String
            self.sendMessage.titleLabel?.text = self.recievedMessage
        }
       }
       
       func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
           
       }
       
       func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
           
       }
       
       func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
           
       }
       
       func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
           dismiss(animated: true, completion: nil)
       }
       
       func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
           dismiss(animated: true, completion: nil)
       }

}

