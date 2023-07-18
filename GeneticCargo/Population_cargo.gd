class_name Population_cargo
extends Node2D


var mutation_rate:float
var population:Array
var mating_pool:Array
var target:Area2D
var generation:int
var finished:bool
var perfect_score:int
var dna = load('res://GeneticCargo/DNA_cargo.gd')
var random:RandomNumberGenerator
var boxes_size:Array
var the_best_population:Array
var target_poly:PoolVector2Array



func _init(p:Area2D,target_polygon:PoolVector2Array,mutation:float,num:int,box_size:Array,screen_size:Vector2) -> void:
	random = RandomNumberGenerator.new()
	random.randomize()
	target = p
	mutation_rate = mutation
	population = []
	boxes_size = boxes_size
	target_poly = target_polygon
	for _x in range(num):
		population.append(dna.new(screen_size,box_size))


	calc_fitness()
	mating_pool = []
	finished = false
	generation = 0
	perfect_score = 12

func calc_fitness()->void:
	for x in population:
		x.fitness_cal(target,target_poly)

func natural_selection()->void:
	mating_pool.clear()
	var max_fitness = 0.001
	for i in population:
		if i.fitness > max_fitness:
			max_fitness = i.fitness

	for x in range(len(population)):
		var fitness = range_lerp(population[x].fitness,0,max_fitness,0,1)
		var num:int=int(fitness*100)
		for _y in range(num):
			mating_pool.append(population[x])

func generate()->void:	
	for i in range(len(population)):
		var a:int = random.randi_range(0,len(mating_pool)-1)
		var b:int = random.randi_range(0,len(mating_pool)-1)
		var partnerA = mating_pool[a]
		var partnerB = mating_pool[b]
		var child = partnerA.crossover(partnerB)
		child.mutate(mutation_rate)
		population[i] = child

	generation+=1

func get_best()->String:
	var worldrecord:float = 0.0
	var index:int = 0

	for i in range(len(population)):
		if population[i].fitness > worldrecord:
			index = i
			worldrecord = population[i].fitness

	if worldrecord == perfect_score:
		finished = true

	return population[index].get_phrase()

func get_best_genes()->Array:
	var worldrecord:float = 0.0
	var index:int = 0

	for i in range(len(population)):
		if population[i].fitness > worldrecord:
			index = i
			worldrecord = population[i].fitness

	if worldrecord == perfect_score:
		finished = true
	
	return population[index].genes
	
func get_best_population()->Array:
	var worldrecord:float = 0.0
	var index:int = 0

	for i in range(len(population)):
		if population[i].fitness > worldrecord:
			index = i
			worldrecord = population[i].fitness

	if worldrecord == perfect_score:
		finished = true
	
	return population[index]

# warning-ignore:function_conflicts_variable
func finished() -> bool:
	return finished

func get_generations()->int:
	return generation

func get_average_fitness()->float:
	var total:float = 0.0
	for i in range(len(population)):
		total += population[i].fitness

	return total/(len(population))


