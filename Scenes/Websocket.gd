extends Node

signal event_received

var websocket_url = "ws://127.0.0.1:5000"

var socket = WebSocketPeer.new()

var id = null

func _ready():
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		await get_tree().create_timer(2).timeout

func _process(_delta):
	socket.poll()

	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var message = socket.get_packet().get_string_from_utf8()

			var json = JSON.new()
			var error = json.parse(message)
			if error == OK:
				if typeof(json.data) == TYPE_DICTIONARY:
					if json.data.has("id"):
						id = json.data["id"]
					elif json.data.has("source"):
						if id == null:
							return
						if json.data["source"] == id:
							return
						var event = json.data["event"]
						emit_signal("event_received", event)

	# WebSocketPeer.STATE_CLOSING means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.

func send_event(event):
	var state = socket.get_ready_state()

	if !state == WebSocketPeer.STATE_OPEN:
		return

	if id == null:
		return
		
	var message = {
		"source": id,
		"event": event, 
	}
	
	socket.send_text(JSON.stringify(message))
