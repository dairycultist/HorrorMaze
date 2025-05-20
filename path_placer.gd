extends Node

# basement https://www.youtube.com/watch?v=dRwbjwCj1oY

# monster only moves when not rendered:
# rendering the object to a secondary viewport and comparing pixels
# fast footstep sounds
# https://www.tiktok.com/@graggl_/video/7471697355100654891

# TODO LIST
# 2. make good models for room, path, and wall

# horror game where you search the dark corridors of a randomly generated maze
# (made with randomized depth-first search) while keeping an inconsistent
# weeping angel at bay (it makes offputting sounds)
# need pathfinding, but that's just putting a node inside every room

# wall-based meshing instead of room-based (allows for large rooms!)

#nah 3D maze. you're underground and you find a big metal cube
#emerge from cramped metal corridors to slightly less cramped stone ones

@export_group("Maze Size")
@export var MAZE_WIDTH = 6
@export var MAZE_LENGTH = 4

const ROOM = preload("res://room.tscn")
const PATH = preload("res://path.tscn")
const WALL = preload("res://wall.tscn")

const ROOM_DIMENSIONS : float = 5
const PATH_LENGTH : float = 1
const ROOM_PLUS_PATH : float = ROOM_DIMENSIONS + PATH_LENGTH

func _ready() -> void:
	
	var maze_data = []
	
	for w in range(0, MAZE_WIDTH):
		
		maze_data.append([])
		
		for l in range(0, MAZE_LENGTH):
			
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
			
		if current.y + 1 < MAZE_LENGTH and not visited.has(current + Vector2i(0, 1)):
			possible_directions.append(1) # +y
			
		if current.x + 1 < MAZE_WIDTH and not visited.has(current + Vector2i(1, 0)):
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
	for w in range(0, MAZE_WIDTH):
		for l in range(0, MAZE_LENGTH):
			for dir_index in range(0, 4):
				
				var dir = dir_index_to_vec2(dir_index)
				
				if maze_data[w][l].has(dir_index):
				
					# path
					var path_position_2d = Vector2(w, l) * ROOM_PLUS_PATH + dir * (ROOM_PLUS_PATH / 2)
					var path := PATH.instantiate()
					add_child(path)
					path.position = Vector3(path_position_2d.x, 0, path_position_2d.y)
					path.rotation = Vector3(0, dir_index * PI / 2, 0)
					
				elif not within_maze_bounds(w + dir.x, l + dir.y) or not maze_data[w + dir.x][l + dir.y].has((dir_index + 2) % 4):
					
					# wall (only if other side doesn't have path)
					var wall_position_2d = Vector2(w, l) * ROOM_PLUS_PATH + dir * (ROOM_DIMENSIONS / 2)
					var wall := WALL.instantiate()
					add_child(wall)
					wall.position = Vector3(wall_position_2d.x, 0, wall_position_2d.y)
					wall.rotation = Vector3(0, dir_index * PI / 2, 0)

func within_maze_bounds(x: int, z: int) -> bool:
	
	return x >= 0 and z >= 0 and x < MAZE_WIDTH and z < MAZE_LENGTH

func dir_index_to_vec2(dir: int) -> Vector2i:
	
	match dir:
		0: return Vector2i(-1, 0)
		1: return Vector2i(0, 1)
		2: return Vector2i(1, 0)
		_: return Vector2i(0, -1)
