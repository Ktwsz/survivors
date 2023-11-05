extends CanvasLayer

class_name CameraHUD

signal update_chosen_signal()
var update_chosen_index : int

@onready var levelDuration: int = get_node("/root/Level").levelDuration

@onready var timer = $UI/MarginContainer/VBoxContainer/HBoxContainer/Timer
@onready var experience = $UI/MarginContainer/VBoxContainer/Experience

@onready var upgradeMenu = $UpgradeUI

@onready var upgradeButtonsArr = [$UpgradeUI/MarginContainer/VBoxContainer/HBoxContainer/Upgrade1, 
							  $UpgradeUI/MarginContainer/VBoxContainer/HBoxContainer2/Upgrade2, 
							  $UpgradeUI/MarginContainer/VBoxContainer/HBoxContainer3/Upgrade3,
							  $UpgradeUI/MarginContainer/VBoxContainer/HBoxContainer4/Upgrade4]



var duration : int

# Called when the node enters the scene tree for the first time.
func _ready():
	duration = levelDuration
	timer.text = durationToString()
	
	experience.value = 0
	
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(false)
	t.timeout.connect(timerUpdate)
	add_child(t)
	t.start()
	
	SignalStatic.experience_changed.connect(experienceUpdate)
	
	upgradeButtonsArr[0].pressed.connect(upgradeButton1Pressed)
	upgradeButtonsArr[1].pressed.connect(upgradeButton2Pressed)
	upgradeButtonsArr[2].pressed.connect(upgradeButton3Pressed)
	upgradeButtonsArr[3].pressed.connect(upgradeButton4Pressed)

func upgradeButton1Pressed():
	update_chosen_index = 0
	emit_signal("update_chosen_signal")

func upgradeButton2Pressed():
	update_chosen_index = 1
	emit_signal("update_chosen_signal")

func upgradeButton3Pressed():
	update_chosen_index = 2
	emit_signal("update_chosen_signal")

func upgradeButton4Pressed():
	update_chosen_index = 3
	emit_signal("update_chosen_signal")

func durationToString() -> String:
	var tmp = duration
	var mins = int(tmp) / 60
	tmp -= mins * 60
	var secs = int(tmp)
	
	var res = str(mins) + ":"
	if secs < 10: res += "0"
	res += str(secs)
	return res

func timerUpdate():
	duration -= 1
	if duration == 0:
		SignalStatic.emit_signal("level_passed")
		return
		
	timer.text = durationToString()

func experienceUpdate(value, maxVal) -> void:
	experience.max_value = maxVal
	experience.value = value
	
func openLevelUpMenu(upgradesArr) -> int:
	var i = 0
	for upgr in upgradesArr:
		upgradeButtonsArr[i].visible = true
		upgradeButtonsArr[i].find_child("TitleLabel").text = upgr["title"]
		upgradeButtonsArr[i].find_child("DescLabel").text = upgr["desc"]
		
		i += 1
		
	while i < 4:
		upgradeButtonsArr[i].visible = false
		i += 1
		
	upgradeMenu.visible = true
	await update_chosen_signal
	upgradeMenu.visible = false
	
	return update_chosen_index


func _on_pause_button_pressed():
	SignalStatic.emit_signal("pause_pressed")
