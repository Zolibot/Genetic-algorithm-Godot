class_name Population_math


var mutation_rate:float
var population:Array
var mating_pool:Array
var target:float
var generation:int
var finished:bool
var perfect_score:int
var dna = load('res://GenetiAlgoMath/DNA_math.gd')
var random:RandomNumberGenerator


func _init(p:float,m:float,num:int) -> void:
	random = RandomNumberGenerator.new()
	random.randomize()
	target = p
	mutation_rate = m
	population = []
	for _x in range(num):
		population.append(dna.new(3))
		
	#calc_answer()
	calc_fitness()
	mating_pool = []
	finished = false
	generation = 0
	perfect_score = 1
	
func calc_answer()->void:
	for x in population:
		x.answer = x.func_math(x.genes[0],x.genes[1],x.genes[2])
	
func calc_fitness()->void:
	for x in population:
		x.fitness_cal(target,0,0)

func natural_selection()->void:
	mating_pool.clear()
	var max_fitness = 0.01
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

func get_best_answer()->String:
	var worldrecord:float = 0.0
	var index:int = 0
	
	for i in range(len(population)):
		if population[i].fitness > worldrecord:
			index = i
			worldrecord = population[i].fitness
	
	if worldrecord == perfect_score:
		finished = true
	
	return str(population[index].answer)


func finished() ->bool:
	return finished
	
func get_generations()->int:
	return generation
	
func get_average_fitness()->float:
	var total:float = 0.0
	for i in range(len(population)):
		total += population[i].fitness
	
	return total/(len(population))
	
func get_minimum_answer()->float:
	var m:float = INF
	for x in population:
		if m>x.answer:
			m = x.answer
	return m
	
func get_maximum_answer()->float:
	var m:float = -INF
	for x in population:
		if m<x.answer:
			m = x.answer
	return m
	
func all_prases()->String:
	var eveything:String = ""
	var display_limit:int = int(min(len(population),20))
	for i in range(display_limit):
		eveything += population[i].get_phrase() +"\n"
	return eveything

