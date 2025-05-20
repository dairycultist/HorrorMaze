extends Node

# basement https://www.youtube.com/watch?v=dRwbjwCj1oY

# monster only moves when not rendered:
# rendering the object to a secondary viewport and comparing pixels
# fast footstep sounds
# https://www.tiktok.com/@graggl_/video/7471697355100654891

# TODO LIST
# 1. add character controller
# 2. make wall code (origin goes right on edge of room, aka ROOM_DIMENSIONS / 2)
# 3. make good models for room, path, and wall

#horror game where you search the dark corridors of a randomly generated maze (made with randomized depth-first search) while keeping an inconsistent weeping angel at bay (it makes offputting sounds)
#need pathfinding, but that's just putting a node inside every room

# wall-based meshing instead of room-based (allows for large rooms!)

#nah 3D maze. you're underground and you find a big metal cube
#emerge from cramped metal corridors to slightly less cramped stone ones

const ROOM_DIMENSIONS : float = 1.5
const PATH_LENGTH : float = 1
const ROOM_PLUS_PATH : float = ROOM_DIMENSIONS + PATH_LENGTH

const ROOM = preload("res://room.tscn")
const PATH = preload("res://path.tscn")
#const WALL

@export var maze_width = 6
@export var maze_length = 4

func _ready() -> void:
	
	var maze_data = []
	
	for w in range(0, maze_width):
		
		maze_data.append([])
		
		for l in range(0, maze_length):
			
			maze_data[w].append([])
			
			var room := ROOM.instantiate()
			add_child(room)
			room.position = Vector3(w * ROOM_PLUS_PATH, 0, l * ROOM_PLUS_PATH)
	
	# generaze maze array with randomized depth-first search
	var stack = [ Vector2i(0, 0) ]
	var visited = [ Vector2i(0, 0) ]
	
	while not stack.is_empty():
		
		var current = stack.back()
		
		var possible_directions = []
		
		if current.x - 1 >= 0 and not visited.has(current + Vector2i(-1, 0)):
			possible_directions.append(0) # -x
			
		if current.y + 1 < maze_length and not visited.has(current + Vector2i(0, 1)):
			possible_directions.append(1) # +y
			
		if current.x + 1 < maze_width and not visited.has(current + Vector2i(1, 0)):
			possible_directions.append(2) # +x
			
		if current.y - 1 >= 0 and not visited.has(current + Vector2i(0, -1)):
			possible_directions.append(3) # -y
		
		# push a random neighbor that hasn't already been built
		# if you can't, pop
		if possible_directions.is_empty():
			stack.pop_back()
		else:
			var chosen_direction = possible_directions.pick_random()
			var new_position = current + dir_index_to_vec2(chosen_direction)
			
			stack.push_back(new_position)
			visited.push_back(new_position)
			
			maze_data[current.x][current.y].append(chosen_direction)
	
	# generate mesh from maze array
	for w in range(0, maze_width):
		for l in range(0, maze_length):
			for dir_index in maze_data[w][l]:
				
				var path_position_2d = Vector2(w, l) * ROOM_PLUS_PATH + dir_index_to_vec2(dir_index) * (ROOM_PLUS_PATH / 2)
				var path := PATH.instantiate()
				add_child(path)
				path.position = Vector3(path_position_2d.x, 0, path_position_2d.y)
				path.rotation = Vector3(0, dir_index * PI / 2, 0)


func dir_index_to_vec2(dir: int) -> Vector2i:
	
	match dir:
		0: return Vector2i(-1, 0)
		1: return Vector2i(0, 1)
		2: return Vector2i(1, 0)
		_: return Vector2i(0, -1)
