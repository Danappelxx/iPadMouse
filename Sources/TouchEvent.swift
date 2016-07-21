import Cocoa

enum DragState: String {
    case started
    case dragging
    case ended
}

enum TouchEvent {
    case tap(count: Int)
    case drag(count: Int, point: (x: Double, y: Double), state: DragState)

    func execute() {

        switch self {

        case let .tap(count: count):

            let event = self.event(type: .leftMouseDown)

            // do as many taps as registered on the client
            for taps in 0..<count {
                event.setIntegerValueField(.mouseEventClickState, value: Int64(taps + 1))

                event.type = .leftMouseDown
                event.post(tap: .cghidEventTap)
                event.type = .leftMouseUp
                event.post(tap: .cghidEventTap)
            }

        case let .drag(count: count, point: point, state: state):

            switch state {

            case .started:
                guard count > 1 else { return }

                let event = self.event(type: .leftMouseDown)
                event.post(tap: .cghidEventTap)

            case .dragging:
                let event = self.event(
                    type: count == 2
                        ? .leftMouseDragged
                        : .mouseMoved,
                    position: point)
                event.post(tap: .cghidEventTap)

            case .ended:
                let event = self.event(type: .leftMouseUp)
                event.post(tap: .cghidEventTap)

            }
        }
    }

    func event(type: CGEventType, position: (x: Double, y: Double)? = nil) -> CGEvent {
        let position = position.map(CGPoint.init) ?? CGEvent.mouseLocation()

        return CGEvent(
            mouseEventSource: nil,
            mouseType: type,
            mouseCursorPosition: position,
            mouseButton: .left
        )!
    }
}


extension CGEvent {
    class func mouseLocation() -> CGPoint {
        return CGEvent(source: nil)!.location
    }
}
