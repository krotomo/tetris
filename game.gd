extends Node2D
@onready var tile_map_layer = $TileMapLayer
@onready var fall_timer = $FallTimer
@onready var end_turn_timer = $EndTurnTimer
@onready var next_piece = randi_range(0, 6)
const GRID_SIZE : Vector2i = Vector2i(10, 20)
const FAST_FALL_TIME : float = 0.05
const FALL_TIME : float = 0.5
var piece : Array[Vector3i]
var center : Vector2i
var blocks : Array[Array]
var fall_time : float = FALL_TIME

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in GRID_SIZE.y:
		blocks.append([])
		for j in GRID_SIZE.x:
			blocks[i].append(-1)
	fall_timer.timeout.connect(func(): fall_piece())
	end_turn_timer.timeout.connect(func(): end_turn())
	spawn_piece()
	update_tile_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("left"):
		if can_move_piece(piece, Vector2i(-1, 0)):
			for i in piece.size():
				piece[i].x -= 1
			center.x -= 2
			update_tile_map()
	elif event.is_action_pressed("right"):
		if can_move_piece(piece, Vector2i(1, 0)):
			for i in piece.size():
				piece[i].x += 1
			center.x += 2
			update_tile_map()
	elif event.is_action_pressed("up"):
		rotate_piece()
	elif event.is_action_pressed("down"):
		fall_time = FAST_FALL_TIME
		fall_timer.start(fall_time)
	elif event.is_action_released("down"):
		fall_time = FALL_TIME
		fall_timer.start(fall_time)


func game_over():
	print("Game Over")


func update_tile_map():
	for i in GRID_SIZE.x:
		for j in GRID_SIZE.y:
			tile_map_layer.set_cell(Vector2i(i, j), -1)
	for tile in piece:
		tile_map_layer.set_cell(
			Vector2i(tile.x, tile.y), 0, Vector2i(tile.z % 4, tile.z / 4)
		)
	for row in GRID_SIZE.y:
		for col in GRID_SIZE.x:
			var value = blocks[row][col]
			if (value != -1):
				tile_map_layer.set_cell(Vector2i(col, row), 0, Vector2i(value % 4, value / 4))


func spawn_piece():
	if next_piece == 0:
		piece = [
			Vector3i(3, 0, 0), Vector3i(3, 1, 0), Vector3i(4, 1, 0), Vector3i(5, 1, 0)
		]
		center = Vector2i(8, 2)
	elif next_piece == 1:
		piece = [
			Vector3i(3, 1, 1), Vector3i(4, 1, 1), Vector3i(5, 1, 1), Vector3i(5, 0, 1)
		]
		center = Vector2i(8, 2)
	elif next_piece == 2:
		piece = [
			Vector3i(3, 1, 2), Vector3i(4, 1, 2), Vector3i(4, 0, 2), Vector3i(5, 0, 2)
		]
		center = Vector2i(8, 2)
	elif next_piece == 3:
		piece = [
			Vector3i(3, 0, 3), Vector3i(4, 0, 3), Vector3i(4, 1, 3), Vector3i(5, 1, 3)
		]
		center = Vector2i(8, 2)
	elif next_piece == 4:
		piece = [
			Vector3i(3, 1, 4), Vector3i(4, 1, 4), Vector3i(5, 1, 4), Vector3i(6, 1, 4)
		]
		center = Vector2i(9, 3)
	elif next_piece == 5:
		piece = [
			Vector3i(4, 0, 5), Vector3i(4, 1, 5), Vector3i(5, 0, 5), Vector3i(5, 1, 5)
		]
		center = Vector2i(9, 1)
	elif next_piece == 6:
		piece = [
			Vector3i(3, 1, 6), Vector3i(4, 0, 6), Vector3i(4, 1, 6), Vector3i(5, 1, 6)
		]
		center = Vector2i(8, 2)
	if not can_move_piece(piece, Vector2i(0, 0)):
		game_over()
	next_piece = randi_range(0, 6)
	fall_timer.start(fall_time)


func end_turn():
	if can_move_piece(piece, Vector2i(0, 1)):
		return
	for tile in piece:
		blocks[tile.y][tile.x] = tile.z
	spawn_piece()
	update_tile_map()


func fall_piece():
	if can_move_piece(piece, Vector2i(0, 1)):
		for i in piece.size():
			piece[i].y += 1
		center.y += 2
		update_tile_map()
		if not can_move_piece(piece, Vector2i(0, 1)):
			end_turn_timer.start()
	fall_timer.start(fall_time)


func rotate_piece():
	print(center)
	var rotated_piece : Array[Vector3i] = []
	for tile in piece:
		var x = tile.x * 2 - center.x
		var y = tile.y * 2 - center.y
		# Rotate 90 degrees clockwise: (x,y) -> (y,-x)
		var new_x = -y + center.x
		var new_y = x + center.y
		rotated_piece.append(Vector3i(new_x / 2, new_y / 2, tile.z))
	for offset in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0), Vector2i(2, 0), Vector2i(-2, 0)]:
		if can_move_piece(rotated_piece, offset):
			for i in rotated_piece.size():
				rotated_piece[i] += Vector3i(offset.x, offset.y, 0)
			center.x += offset.x * 2
			center.y += offset.y * 2
			piece = rotated_piece
			update_tile_map()
			return


func can_move_piece(piece_to_move : Array[Vector3i], offset : Vector2i) -> bool:
	for tile in piece_to_move:
		var pos = Vector2i(tile.x, tile.y) + offset
		if (pos.x < 0 or pos.x >= GRID_SIZE.x or pos.y < 0 or pos.y >= GRID_SIZE.y):
			return false
		if (blocks[pos.y][pos.x] != -1):
			return false
	return true
