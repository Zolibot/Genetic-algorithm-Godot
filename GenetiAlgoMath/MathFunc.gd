extends Control


var MUTATION_RATE:float = 0.01
var POP_MAX:int = 300
var taget:float = 37
var population
var start:bool = false

onready var list_phrases:Label =$margin_container/v_box_container/h_box_container/label
onready var statistic_algo:Label = $margin_container/v_box_container/h_box_container/v_box_container/label2

func _ready() -> void:
	$margin_container/v_box_container/h_box_container/v_box_container/button.set_toggle_mode(true)
	
func _process(delta: float) -> void:
	if population != null:
		if population.finished():
			start = false
		
	
	if start:
		population.natural_selection()
		population.generate()
		#population.calc_answer()
		population.calc_fitness()
	
	if population != null:
		list_phrases.set_text(population.all_prases())
		statistic_algo.set_text(diplay_statistic())
	
func diplay_statistic()->String:
	var best = "Best phrase:   \n"
	best+= population.get_best()+"\n"
	var total = "total generations:     "
	total+= str(population.get_generations())+"\n"
	var fit = "average fitness:       "
	fit+= str(population.get_average_fitness()) +"\n"
	var tot_pop = "total population: "
	tot_pop+= str(POP_MAX) +"\n"
	var mutation = "mutation rate:         " 
	mutation+= str(MUTATION_RATE)+"\n"
	var best_answer = "best_answer:         " 
	best_answer+= str(population.get_best_answer())+"\n"
	return best+total+fit+tot_pop+mutation+best_answer


func _on_Button_pressed() -> void:	
	JavaScript.eval("alert('Calling JavaScript per GDScript!');")
	
	
	taget = float($margin_container/v_box_container/h_box_container2/text_edit.get_text())
	
	$margin_container/v_box_container/panel/func.set_text("3*x^3+2*y+10*a= " + str(taget))
	population = Population_math.new(taget,MUTATION_RATE,POP_MAX)
	start=true


func _on_h_scroll_bar_value_changed(value: float) -> void:
	$margin_container/v_box_container/h_box_container/v_box_container/label22.set_text("Population:  "+str(value))
	POP_MAX = value
