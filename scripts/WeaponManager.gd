extends Node2D

@export var weaponsArr = [load("res://scenes/weapons/KnifeSpawner.tscn"), load("res://scenes/weapons/AxeSpawner.tscn")]
@export var weaponsAddDesc = [{"title": "Knife", "desc": "Add Knife", "weaponId": 0}, {"title": "Axe", "desc": "Add Axe", "weaponId": 1}]
var weaponInstances = [null, null]

@export var defaultWeaponId = 0

func addUpgrade(weaponId):
	if weaponInstances[weaponId] != null:
		weaponInstances[weaponId].upgrade()
		return
	
	weaponInstances[weaponId] = weaponsArr[weaponId].instantiate()
	add_child(weaponInstances[weaponId])

	
func getUpgradesInfo():
	var upgradesInfoArr = []
	for id in range(len(weaponInstances)):
		if weaponInstances[id] == null:
			upgradesInfoArr.push_back(weaponsAddDesc[id])
		elif not weaponInstances[id].isMax():
			upgradesInfoArr.push_back(weaponInstances[id].getUpgradeInfo())
			
	return upgradesInfoArr

