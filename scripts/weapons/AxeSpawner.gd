extends Node2D

var cooldown : float
var projectileNum : int #TODO add projectile delay
var projectileDmg : int
var projectileSpeed : float

var upgrades = [{"cooldown": 5.0, "projectileNum": 1, "projectileDmg": 20, "projectileSpeed": 1.0, "desc": "Add Axe"},
				{"cooldown": 2.0, "projectileNum": 2, "projectileDmg": 20, "projectileSpeed": 150.0, "desc": "Raise projectile speed"},
				{"cooldown": 2.0, "projectileNum": 3, "projectileDmg": 20, "projectileSpeed": 150.0, "desc": "Decrease cooldown"},
				{"cooldown": 2.0, "projectileNum": 3, "projectileDmg": 25, "projectileSpeed": 300.0, "desc": "Decrease cooldown, add one projectile"},
				{"cooldown": 2.0, "projectileNum": 4, "projectileDmg": 30, "projectileSpeed": 300.0, "desc": "Add one projectile, increase damage"}]
				
var upgradeIndex = 0

var weaponId = 1

@onready var timer : Timer = Timer.new()
@onready var projectile = load("res://Scenes/weapons/AxeProjectile.tscn")
@onready var player =  $"../../"

func spawnProjectile() -> void:
	for i in range(projectileNum):
		var newProjectile = projectile.instantiate()
		newProjectile.setVariables(position, player.direction.x < 0, projectileSpeed, projectileDmg)
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
	return {"title": "Axe", "desc": upgrades[upgradeIndex]["desc"], "weaponId": weaponId}
	
func isMax():
	return upgradeIndex == upgrades.size()
