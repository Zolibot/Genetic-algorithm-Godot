extends Control

var MUTATION_RATE:float = 0.01
var POP_MAX:int = 250
var taget:String = "https://github.com/Zolibot/"
var population
var start:bool = false

onready var list_phrases:Label = $tab_container/Genetic_Words/HBoxContainer/Label
onready var statistic_algo:Label = $tab_container/Genetic_Words/HBoxContainer/VBoxContainer/Label2

func _ready() -> void:
    $tab_container/Genetic_Words/HBoxContainer/VBoxContainer/Button.set_toggle_mode(true)
    
# warning-ignore:unused_argument
func _process(delta: float) -> void:
    if population != null:
        if population.finished():
            start = false
    if start:
        population.natural_selection()
        population.generate()
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
    return best+total+fit+tot_pop+mutation


func _on_Button_pressed() -> void:	
    taget = $tab_container/Genetic_Words/HBoxContainer/VBoxContainer/text_edit.get_text()
    population = Population.new(taget,MUTATION_RATE,POP_MAX)
    start=true


func _on_h_scroll_bar_value_changed(value: float) -> void:
    $tab_container/Genetic_Words/HBoxContainer/VBoxContainer/v_box_container/label.set_text("population:  "+str(value))
# warning-ignore:narrowing_conversion
    POP_MAX = value
