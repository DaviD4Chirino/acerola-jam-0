extends Node3D
class_name Level
## Path to the next level to teleport to
@export var next_level: String
@export var pause_menu: CanvasLayer

static var is_paused: bool = false

func _ready():
	g.playground = self
	
	SignalBus.level_paused.connect(_on_game_paused)
	SignalBus.level_resumed.connect(_on_game_resumed)
	SignalBus.level_restarted.connect(_on_game_resumed)

	ready()

func ready():
	pass

func _input(event):
	if event.is_action_pressed("ACTION_PAUSE"):
		if is_paused:
			Level.resume()
			return
		Level.pause()

	if event.is_action_pressed("ACTION_START"):
		is_paused = false
		Level.resume()

func _on_game_paused():
	if not DialogManager.in_dialog:
		pause_menu.show()
		pass
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_game_resumed():
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

static func pause() -> void:
	is_paused = true
	Utility.pause_game()
	SignalBus.level_paused.emit()

static func resume() -> void:
	is_paused = false
	Utility.resume_game()
	SignalBus.level_resumed.emit()

static func restart() -> void:
	is_paused = false
	Utility.restart_level()
	SignalBus.level_restarted.emit()
