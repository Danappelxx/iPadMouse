import JSON

extension DragState {
    init(json: JSON) throws {
        switch try json.asString() {
            case "started": self = .started
            case "dragging": self = .dragging
            case "ended": self = .ended
            case _: throw JSON.Error.incompatibleType
        }
    }
}

extension TouchEvent {
    init(json: JSON) throws {

        let typeStr: String = try json.get("type")
        let tapCount = try Int(json.get("tapCount") as Double)

        switch typeStr {

            case "tap":
                self = .tap(count: tapCount)

            case "drag":
                guard let
                    point = json["point"],
                    state = try json["state"].map(DragState.init)
                    else {
                        throw JSON.Error.incompatibleType
                }

                let x: Double = try point.get("x")
                let y: Double = try point.get("y")

                self = .drag(count: tapCount, point: (x: x, y: y), state: state)

            default:
                throw JSON.Error.incompatibleType
        }
    }
}
