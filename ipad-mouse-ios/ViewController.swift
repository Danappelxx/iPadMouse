//
//  ViewController.swift
//  ipad-mouse
//
//  Created by Dan Appel on 7/19/16.
//  Copyright © 2016 dvappel. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    //TODO: Don't hardcode this
    static let ip = "192.168.1.132:8080"
    let socket = WebSocket(url: URL(string: "ws://\(ip)")!)

    // keeping track of single/double/etc tap
    var lastTapCount = 0

    @IBOutlet weak var lastTouchEvent: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var connect: UIButton!

    @IBAction func connectTapped() {
        self.socket.connect()
    }

    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        let drag = DragGestureRecognizer(delegate: self)
        self.view.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(drag)

        self.socket.delegate = self
        self.socket.connect()
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastTapCount = touches.first?.tapCount ?? 0
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastTapCount = 0
    }

    func didTap(gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: self.view)
        self.lastTouchEvent.text = "tapped: \(point), taps: \(lastTapCount)"

        // don't send point
        send(json: [
            "type": "tap",
            "tapCount": self.lastTapCount
        ])
    }
}

extension ViewController: DragGestureRecognizerDelegate {
    func didMove(gestureRecognizer: DragGestureRecognizer, tapCount: Int) {
        let point = gestureRecognizer.location(in: self.view)
        self.lastTouchEvent.text = "dragged: \(point), taps: \(tapCount)"

        send(json: [
            "type": "drag",
            "tapCount": tapCount,
            "state": gestureRecognizer.dragState.rawValue,
            "point": [
                "x": point.x,
                "y": point.y
            ]
        ])
    }
}

extension ViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocket) {
        print("connected!")
        self.status.text = "Connected"
        self.connect.isEnabled = false
    }

    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        print("disconnected; error: \(error)")
        self.status.text = "Disconnected"
        self.connect.isEnabled = true
    }

    // ignore
    func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {}
    func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {}
}

extension ViewController {
    func send(json: [String:AnyObject]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json as AnyObject, options: [])
            socket.write(data: data)
        } catch {
            print("error during serialization: \(error)")
        }
    }
}
