//
//  DragGestureRecognizer.swift
//  ipad-mouse-ios
//
//  Created by Dan Appel on 7/21/16.
//  Copyright © 2016 dvappel. All rights reserved.
//

import UIKit

protocol DragGestureRecognizerDelegate: class {
    func didMove(gestureRecognizer: DragGestureRecognizer, tapCount: Int)
}

final class DragGestureRecognizer: UIPanGestureRecognizer, UIGestureRecognizerDelegate {
    enum DragState: String {
        case started
        case dragging
        case ended
    }

    weak var dragDelegate: DragGestureRecognizerDelegate? = nil
    var lastTapCount = 0

    var dragState = DragState.dragging

    override var cancelsTouchesInView: Bool {
        get {
            return false
        }
        set {
            // ignore it :P
        }
    }

    init(delegate: DragGestureRecognizerDelegate) {
        self.dragDelegate = delegate
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(self.didPan))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.lastTapCount = touches.first?.tapCount ?? 0
        self.dragState = .started
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let tapCount = touches.first?.tapCount {
            self.lastTapCount = tapCount
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.lastTapCount = touches.first?.tapCount ?? 0
        self.dragState = .ended
        self.dragDelegate?.didMove(gestureRecognizer: self, tapCount: self.lastTapCount)
    }

    @objc private func didPan() {
        self.dragDelegate?.didMove(gestureRecognizer: self, tapCount: lastTapCount)
        self.dragState = .dragging
    }
}
