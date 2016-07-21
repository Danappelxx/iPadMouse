import HTTPServer
import WebSocketServer
import JSON

let server = WebSocketServer { request, ws in
    print("connected")

    ws.onBinary { data in
        let json = try JSONParser().parse(data: data)
        let event = try TouchEvent(json: json)
        //print(event)
        event.execute()
    }

    ws.onClose { _ in
        print("disconnected")
    }
}

try Server(responder: server).start()
