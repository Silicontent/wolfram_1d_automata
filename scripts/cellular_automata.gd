extends Node2D

# the TileMap that displays the cells on-screen
@onready var cell_map := $Cells
# the label that tells the user how to return to the menu
@onready var leave_notice := $LeaveNotice

var cells := []
# the current generation
var generation := 0

# determines if new generations should be drawn
var stop_sim := false


func _ready() -> void:
	leave_notice.hide()
	
	# set the cell size
	cell_map.scale = Vector2i(Globals.cell_size, Globals.cell_size)
	
	# fill the cells list with blanks
	cells.resize((1280 / Globals.cell_size))
	cells.fill(0)
	
	# add the only "on" cell
	cells[len(cells) / 2] = 1


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# toggle the simulation on and off
		stop_sim = not stop_sim
		leave_notice.visible = stop_sim
	
	if Input.is_action_just_pressed("exit") and stop_sim:
		# return to the main menu
		get_tree().change_scene_to_file("res://scenes/config.tscn")
	
	# create and display the generation
	if not stop_sim:
		draw_generation()
		# create new generation
		cells = make_next_generation()
		# increase the generation number
		generation += 1


# SIMULATION LOGIC =======================================================
# draw one whole row
func draw_generation() -> void:
	# loop over every cell spot on-screen
	for index in range(len(cells)):
		# set the cell state
		set_cell(index, cells[index])


func make_next_generation() -> Array:
	# get the amount of cells
	var cell_amount = len(cells)
	
	# create new array to hold new generation
	var new_cells = []
	new_cells.resize(cell_amount)
	new_cells.fill(0)
	
	for i in range(cell_amount):
		# determine the cell's neighbors, wrapping around the screen if necessary
		var neighborhood = [
			cells[(i - 1 + cell_amount) % cell_amount],
			cells[i],
			cells[(i + 1 + cell_amount) % cell_amount]
		]
		
		# determine the state of the current cell
		new_cells[i] = determine_state(neighborhood)
	
	return new_cells


# use a neighborhood of three cells 
func determine_state(n: Array) -> int:
	if n[0] == 1 and n[1] == 1 and n[2] == 1: return int(Globals.ruleset[0])
	if n[0] == 1 and n[1] == 1 and n[2] == 0: return int(Globals.ruleset[1])
	if n[0] == 1 and n[1] == 0 and n[2] == 1: return int(Globals.ruleset[2])
	if n[0] == 1 and n[1] == 0 and n[2] == 0: return int(Globals.ruleset[3])
	if n[0] == 0 and n[1] == 1 and n[2] == 1: return int(Globals.ruleset[4])
	if n[0] == 0 and n[1] == 1 and n[2] == 0: return int(Globals.ruleset[5])
	if n[0] == 0 and n[1] == 0 and n[2] == 1: return int(Globals.ruleset[6])
	else: return int(Globals.ruleset[7])


# set the state of a specific cell
func set_cell(index: int, state: int) -> void:
	# set the cell at the position
	cell_map.set_cell(0, Vector2i(index, generation), 0, Vector2i(state, 0))
