extends Node2D
@onready var tile_map_layer = $TileMapLayer
@onready var fall_timer = $FallTimer
@onready var next_piece = randi_range(0, 6)
var piece : Array[Vector3i]

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_piece()
	update_tile_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_tile_map():
	for tile in piece:
		tile_map_layer.set_cell(
			Vector2i(tile.x, tile.y), 0, Vector2i(tile.z % 4, tile.z / 4)
		)


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
			Vector3i(3, 0, 5), Vector3i(3, 1, 5), Vector3i(4, 0, 5), Vector3i(4, 1, 5)
		]
	elif next_piece == 6:
		piece = [
			Vector3i(3, 1, 6), Vector3i(4, 0, 6), Vector3i(4, 1, 6), Vector3i(5, 1, 6)
		]
	next_piece = randi_range(0, 6)
	

func can_move_piece(direction : Vector2i) -> bool:
	for tile in piece:
		var pos = Vector2i(tile.x, tile.y) + direction
		if (pos.x < 0 or pos.x > 9 or pos.y < 0 or pos.y > 19):
			return false
		if tile_map_layer.get_cell_source_id(0, pos) != -1:
			return false
	return true
