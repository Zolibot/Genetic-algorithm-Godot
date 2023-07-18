class_name DNA


var genes:Array
var fitness:float
var random:RandomNumberGenerator
var dna = load( 'res://GenetiAlgoText/DNA.gd')

func _init(num:int) -> void:
    random = RandomNumberGenerator.new()
    random.randomize()
    for x in range(num):
        genes.append(char(random.randi_range(28,128)))

# Converts character array to a String
func get_phrase()->String:
    var a = ""
    for x in genes:
        a+=x
    return a

# Fitness function (returns floating point % of "correct" characters)
func fitness_cal(target:String)->void:
    var size_target = len(target)
    var score:float = 0 
    var index:int = 0
    for x in genes:
        if x == target[index]:
            score+=1
        index+=1

    fitness = float(score/float(len(target)))
    
func crossover(partner:DNA)->DNA:
    var child:DNA = dna.new(len(genes))  #A new child
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
            genes[x] = char(random.randi_range(28,128))
