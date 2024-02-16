extends Control

# the inputs for cell size and ruleset
@onready var cell_size := $VBoxContainer/CellSize
@onready var ruleset := $VBoxContainer/Ruleset


# convert a decimal number to an 8-digit binary number as a string
func int_to_byte(number: int) -> String:
	# holds the binary number as a string
	var binary_string = ""
	
	# continue until the number is 0
	while number > 0:
		# find the quotient and the remainder
		var quotient = number / 2
		var remainder = number % 2
		# add the remainder to the binary string (will be 0 or 1)
		binary_string = str(remainder) + binary_string
		# set the number to the quotient
		number = quotient
	
	# ensure the binary number is 8 digits long
	while len(binary_string) < 8:
		binary_string = "0" + binary_string
	
	# return the finished string
	return binary_string


func _ready() -> void:
	randomize()
	
	# set the inputs to the currently selected values
	cell_size.value = Globals.cell_size
	ruleset.value = Globals.rule_num


func _on_start_pressed():
	# set the simulation settings
	Globals.cell_size = cell_size.value
	Globals.ruleset = int_to_byte(ruleset.value)
	Globals.rule_num = ruleset.value
	
	# go to the simulation screen
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_random_rule_pressed():
	# set the ruleset to a random number
	ruleset.value = randi_range(0, 255)
