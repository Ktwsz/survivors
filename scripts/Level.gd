extends Node2D

@onready var player = $Player
@onready var hud = $Player/Camera2D/CameraHUD

@export var levelDuration : int = 300

func getPlayerPos() -> Vector2:
	if player == null: return Vector2(0, 0)
	return player.position
	
func _ready():
	player.addDefaultWeapon()
	
	SignalStatic.pause_pressed.connect(pauseGame)
	SignalStatic.levelUp.connect(openLevelUpMenu)

func pauseGame():#TODO actual pause menu
	get_tree().paused = !get_tree().paused

func openLevelUpMenu():
	get_tree().paused = true
	var upgradesArr = player.getUpgradesInfo()
	print(upgradesArr)
	var upgradeIndex : int = await hud.openLevelUpMenu(upgradesArr)
	player.addUpgrade(upgradesArr[upgradeIndex]["weaponId"])
	get_tree().paused = false
