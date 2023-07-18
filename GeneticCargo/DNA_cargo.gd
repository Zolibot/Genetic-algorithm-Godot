class_name DNA_cargo


var genes:Array
var fitness:float
var random:RandomNumberGenerator
var dna = load( 'res://GeneticCargo/DNA_cargo.gd')
var size:Vector2
var cargo_size:Array

# Array Area2d
var Cargo:Array

func _init(screen_size:Vector2,box_size:Array) -> void:
	self.size = screen_size
	self.cargo_size = box_size
	random = RandomNumberGenerator.new()
	random.randomize()
	randomize()
	for pos in cargo_size:
		var x = random.randi_range(0,size.x)
		var y = random.randi_range(220,size.y-220)
		genes.append(Vector2(x,y))

# Converts character array to a String
func get_phrase()->String:
	return str(genes)

# Fitness function (returns floating point % of "correct" characters)
#func fitness_cal(target:Area2D,target_poly:PoolVector2Array)->void:
#	var _score = 0
#
#	var _flag = false
#	for _x in genes:
#		for _poly in cargo_size:
#			if _check_poly_in_poly(_x,_poly,target_poly):
#
#				for _b in cargo_size:
#					if not _check_poly_in_poly(_x,_b,_poly):
#						_flag = true
#						break
#
#			else:
#				break
#			if _flag:
#				_score += 1.0
#				_flag = false
#
#
#	if _score==0.0:
#		fitness=0.0
#	else:
#		fitness = float(float(_score) / float(len(genes)))

func fitness_cal(target:Area2D,target_poly:PoolVector2Array)->void:
	var _score = 0
	var _index:int = 0
	var _flag = false
	for _x in genes:
		for _poly in cargo_size:
			if _check_poly_in_poly(_x,_poly,target_poly):
				_flag = true
				_score+=0.5
				break
	
	if _score > 4.0:
		for _x in range(len(genes)):
			for _y in range(len(cargo_size)):
				if   _check_poly_in_polyy(genes[_x],
							cargo_size[_y],cargo_size[_x]):
					_score-=0.5
					break
				else:
					_score+=0.5
					break
			_index += 1

	if _score <= 0.0:
		fitness=0.001
	else:
		fitness = float(float(_score)/ float(len(genes)))

func _check_poly_in_polyy(f:Vector2,ArrayVector:Array,PoolVec:Array)->bool:
	var _index = 0
	var _flag = false
	var _temp:Array = PoolVec.duplicate()
#	print(_temp)
	for _x in range(len(_temp)):
		_temp[_x]+=f
#	print("+++++++++++++++++++++++++++")
#	print(_temp)
	
	for _x in ArrayVector:
		if Geometry.is_point_in_polygon(_x+f,PoolVector2Array(_temp)):
			_index += 1
	
	if _index == len(ArrayVector):
		_flag = true
	else:
		_flag = false
	return _flag	


func _check_poly_in_poly(f:Vector2,ArrayVector:Array,PoolVec:PoolVector2Array)->bool:
	var _index = 0
	var _flag = false
	for _x in ArrayVector:
		if Geometry.is_point_in_polygon(_x+f,PoolVec):
			_index += 1
	
	if _index == len(ArrayVector):
		_flag = true
	else:
		_flag = false
	return _flag	
	

func crossover(partner:DNA_cargo)->DNA_cargo:
	randomize()
	var child:DNA_cargo = dna.new(size,cargo_size)  #A new child
	var midpoint:int = int(random.randi_range(0,len(genes)))
	# Half from one, half from the other
	for x in range(len(genes)):
		if x > midpoint:
			child.genes[x] = genes[x]
		else:
			child.genes[x] = partner.genes[x]
	return child

func mutate(mutation_rate:float):
	randomize()
	for _x in range(len(genes)):
		if (random.randf()<mutation_rate):
			var x = random.randi_range(0,size.x)
			var y = random.randi_range(0,size.y)
			genes[_x] = Vector2(x,y)
