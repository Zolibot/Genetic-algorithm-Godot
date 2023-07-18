class_name DNA_math


var genes:Array
var fitness:float
var random:RandomNumberGenerator
var dna = load( 'res://GenetiAlgoMath/DNA_math.gd')
var answer:float = 0
var RANGE = 90

func _init(num:int) -> void:
	random = RandomNumberGenerator.new()
	random.randomize()
	for x in range(num):
		genes.append(random.randf_range(-RANGE,RANGE))
	
# Converts character array to a String
func get_phrase()->String:
	return str(genes)

func func_math(x:float,y:float,a:float)->float:
	return 3*pow(x,3)+2*y+10*a 
# Fitness function (returns floating point % of "correct" characters)
func fitness_cal(target:float,minimal:=0,maximum:=0)->void:
	answer = func_math(genes[0],genes[1],genes[2])
	if answer>target+0.4:
		self.fitness = 0.001
	else:
		self.fitness = smoothstep(0, target, answer)

	
func crossover(partner:DNA_math)->DNA_math:
	var child:DNA_math = dna.new(len(genes))  #A new child
	var midpoint:int = int(random.randi_range(0,len(genes)))
	# Half from one, half from the other
	for x in range(len(genes)):
		if x > midpoint:
			child.genes[x] = genes[x]
		else:
			child.genes[x] = partner.genes[x]
	return child
	
func mutate(mutation_rate:float):
	for x in range(len(genes)):
		if (random.randf()<mutation_rate):
			genes[x] = random.randf_range(-RANGE,RANGE)
