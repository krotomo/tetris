extends Node2D
@onready var tile_map_layer = $TileMapLayer
@onready var fall_timer = $FallTimer
@onready var next_piece = randi_range(0, 6)
var piece : Array[Vector3i]
var blocks : Array[Array]
var grid_size : Vector2i = Vector2i(10, 20)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in grid_size.y:
		blocks.append([])
		for j in grid_size.x:
			blocks[i].append(-1)
	fall_timer.timeout.connect(func(): fall_piece())
	spawn_piece()
	update_tile_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	print("Game Over")


func update_tile_map():
	for i in grid_size.x:
		for j in grid_size.y:
			tile_map_layer.set_cell(Vector2i(i, j), -1)
	for tile in piece:
		tile_map_layer.set_cell(
			Vector2i(tile.x, tile.y), 0, Vector2i(tile.z % 4, tile.z / 4)
		)
	for row in grid_size.y:
		for col in grid_size.x:
			var value = blocks[row][col]
			if (value != -1):
				tile_map_layer.set_cell(Vector2i(col, row), 0, Vector2i(value % 4, value / 4))


func spawn_piece():
	if next_piece == 0:
		piece = [
			Vector3i(3, 0, 0), Vector3i(3, 1, 0), Vector3i(4, 1, 0), Vector3i(5, 1, 0)
		]
	elif next_piece == 1:
		piece = [
			Vector3i(3, 1, 1), Vector3i(4, 1, 1), Vector3i(5, 1, 1), Vector3i(5, 0, 1)
		]
	elif next_piece == 2:
		piece = [
			Vector3i(3, 1, 2), Vector3i(4, 1, 2), Vector3i(4, 0, 2), Vector3i(5, 0, 2)
		]
	elif next_piece == 3:
		piece = [
			Vector3i(3, 0, 3), Vector3i(4, 0, 3), Vector3i(4, 1, 3), Vector3i(5, 1, 3)
		]
	elif next_piece == 4:
		piece = [
			Vector3i(3, 1, 4), Vector3i(4, 1, 4), Vector3i(5, 1, 4), Vector3i(6, 1, 4)
		]
	elif next_piece == 5:
		piece = [
			Vector3i(4, 0, 5), Vector3i(4, 1, 5), Vector3i(5, 0, 5), Vector3i(5, 1, 5)
		]
	elif next_piece == 6:
		piece = [
			Vector3i(3, 1, 6), Vector3i(4, 0, 6), Vector3i(4, 1, 6), Vector3i(5, 1, 6)
		]
	if not can_place_piece(Vector2i(0, 0)):
		game_over()
	next_piece = randi_range(0, 6)


func fall_piece():
	if can_place_piece(Vector2i(0, 1)):
		for i in piece.size():
			piece[i].y += 1
		update_tile_map()
	else:
		for tile in piece:
			blocks[tile.y][tile.x] = tile.z
		spawn_piece()


func can_place_piece(direction : Vector2i) -> bool:
	for tile in piece:
		var pos = Vector2i(tile.x, tile.y) + direction
		if (pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y):
			return false
		if (blocks[pos.y][pos.x] != -1):
			return false
	return true
