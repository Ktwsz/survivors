extends Node

signal on_enemy_hit(node: Node, amount: int)
signal on_player_died()
signal level_passed()
signal experience_changed(amount: int, maxVal: int)
signal pause_pressed()
signal levelUp()
