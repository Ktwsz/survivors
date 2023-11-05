extends Node2D

var cooldown : float
var projectileNum : int
var projectileDmg : int
var projectileSpeed : float

var upgrades = [{"cooldown": 3.0, "projectileNum": 1, "projectileDmg": 5, "projectileSpeed": 150.0, "desc": "Add Knife"},
				{"cooldown": 3.0, "projectileNum": 1, "projectileDmg": 5, "projectileSpeed": 300.0, "desc": "Raise projectile speed"},
				{"cooldown": 2.0, "projectileNum": 1, "projectileDmg": 5, "projectileSpeed": 300.0, "desc": "Decrease cooldown"},
				{"cooldown": 1.0, "projectileNum": 2, "projectileDmg": 5, "projectileSpeed": 300.0, "desc": "Decrease cooldown, add one projectile"},
				{"cooldown": 1.0, "projectileNum": 3, "projectileDmg": 10, "projectileSpeed": 300.0, "desc": "Add one projectile, increase damage"}]
				
var upgradeIndex = 0

var weaponId = 0

@onready var timer : Timer = Timer.new()
@onready var projectile = load("res://Scenes/weapons/KnifeProjectile.tscn")
@onready var player = $"../../"

func spawnProjectile() -> void:
	for i in range(projectileNum):
		var newProjectile = projectile.instantiate()
		newProjectile.setVariables(position, player.direction.angle(), projectileSpeed, projectileDmg)
		add_child(newProjectile)

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrade()
	
	self.timer.set_one_shot(false)
	self.timer.timeout.connect(spawnProjectile)
	add_child(self.timer)
	self.timer.start()

func upgrade():
	cooldown = upgrades[upgradeIndex]["cooldown"]
	self.timer.set_wait_time(cooldown)
	projectileNum = upgrades[upgradeIndex]["projectileNum"]
	projectileDmg = upgrades[upgradeIndex]["projectileDmg"]
	projectileSpeed = upgrades[upgradeIndex]["projectileSpeed"]
	
	upgradeIndex += 1
	
func getUpgradeInfo():
	return {"title": "Knife", "desc": upgrades[upgradeIndex]["desc"], "weaponId": weaponId}
	
func isMax():
	return upgradeIndex == upgrades.size()
