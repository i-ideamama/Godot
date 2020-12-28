extends TileMap


const BLOCK = preload("res://Scenes/Block.tscn")
enum POS_TYPE {EMPTY, OCCUPIED}

var grid = []
var grid_size = Vector2(10,10)
var block_count = 0
var block_list = []
var current_block


func _ready():
	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(y)
			grid[x][y] = POS_TYPE.EMPTY
			
	current_block = BLOCK.instance()
	block_list.append(current_block)
	add_child(current_block)
	current_block.position = Vector2(256,0)
	
	grid[9][9] = POS_TYPE.EMPTY


func _physics_process(delta):
	current_block.update_direction()
	move_block()
	if Input.is_action_just_pressed("ui"):
		pass



func check_if_all_elems_are_equal(lst):
	var element = lst[0]
	var check = true
	
	for item in lst:
		if element != item:
			check = false
			break
	return check


func move_block():
	var grid_pos = world_to_map(current_block.position)
	var prev_grid_pos = grid_pos
	var new_grid_pos = grid_pos + current_block.direction
	var target_pos
	var grid_target_pos


	if (new_grid_pos.x <= 9 and new_grid_pos.x >= 0) && (new_grid_pos.y <= 9 and new_grid_pos.y >= 0):
		if not grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.OCCUPIED:
			target_pos = map_to_world(new_grid_pos)
			grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

		else:
			target_pos = map_to_world(prev_grid_pos)
			grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

	else:
		target_pos = map_to_world(prev_grid_pos)
		grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

	grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY
	grid_target_pos = world_to_map(target_pos)
	
	current_block.position = target_pos
	current_block.direction.y = 0
	
	
	if grid_target_pos.y < 9:
		if not grid[grid_target_pos.x][grid_target_pos.y+1] == POS_TYPE.EMPTY:
			new_block()
	elif grid_target_pos.y == 9:
		new_block()


func _on_Timer_timeout():
	current_block.direction.y = 1


func new_block():
	var block = BLOCK.instance()
	var block_instance_grid_pos
	
	add_child(block)
	block_list.append(block)
	block.position = Vector2(256,0)
	block_instance_grid_pos = world_to_map(current_block.position)
	current_block = block_list[-1]

	grid[block_instance_grid_pos.x][block_instance_grid_pos.y] = POS_TYPE.OCCUPIED


func clear_row():
	pass
