extends Node

const ROOM_DIMENSIONS : float = 1.5
const PATH_LENGTH : float = 1
const ROOM_PLUS_PATH : float = ROOM_DIMENSIONS + PATH_LENGTH
# gonna also need "wall," blocks off sides where there aren't paths

const ROOM = preload("res://room.tscn")
const PATH = preload("res://path.tscn")

@export var maze_width = 6
@export var maze_length = 4

func _ready() -> void:
	
	for w in range(0, maze_width):
		for l in range(0, maze_length):
			
			var room := ROOM.instantiate()
			add_child(room)
			room.position = Vector3(w * ROOM_PLUS_PATH, 0, l * ROOM_PLUS_PATH)
	
	# generaze maze with randomized depth-first search
	var stack = [ Vector2i(0, 0) ]
	var visited = [ Vector2i(0, 0) ]
	
	while not stack.is_empty():
		
		var current = stack.back()
		
		var possible_directions = []
		
		if current.x - 1 >= 0 and not visited.has(current + Vector2i(-1, 0)):
			possible_directions.append(Vector2i(-1, 0))
			
		if current.x + 1 < maze_width and not visited.has(current + Vector2i(1, 0)):
			possible_directions.append(Vector2i(1, 0))
			
		if current.y - 1 >= 0 and not visited.has(current + Vector2i(0, -1)):
			possible_directions.append(Vector2i(0, -1))
			
		if current.y + 1 < maze_length and not visited.has(current + Vector2i(0, 1)):
			possible_directions.append(Vector2i(0, 1))
		
		# push a random neighbor that hasn't already been built
		# if you can't, pop
		if possible_directions.is_empty():
			stack.pop_back()
		else:
			var chosen_direction = possible_directions.pick_random()
			var new_position = current + chosen_direction
			
			stack.push_back(new_position)
			visited.push_back(new_position)
			
			var path_position_2d = current * ROOM_PLUS_PATH + chosen_direction * (ROOM_PLUS_PATH / 2)
			var path := PATH.instantiate()
			add_child(path)
			path.position = Vector3(path_position_2d.x, 0, path_position_2d.y)
			if chosen_direction.y != 0:
				path.rotation = Vector3(0, PI / 2, 0)
	
	pass

# basement https://www.youtube.com/watch?v=dRwbjwCj1oY

#horror game where you search the dark corridors of a randomly generated maze (made with randomized depth-first search) while keeping an inconsistent weeping angel at bay (it makes offputting sounds)
#need , I L T and X rooms (with rotations)
#and pathfinding, but that's just putting a node inside every room

#nah 3D maze. you're underground and you find a big metal cube
#emerge from cramped metal corridors to slightly less cramped stone ones
#maybe it'd be smarter to make this wall-based meshing instead of room-based
#plus allows for some large rooms
