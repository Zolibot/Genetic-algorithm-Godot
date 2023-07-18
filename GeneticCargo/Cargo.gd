extends Control


export(int, 1,20) var number = 10
export(int) var cargo_countity = 10
export var MUTATION_RATE:float = 0.011
export var POP_MAX:int = 100

var hold_ponts:Array = [
    Vector2(0,0),Vector2(0,14.8),
    Vector2(26.2,14.8),Vector2(35.7,10.5),
    Vector2(35.7,4.3),Vector2(26.2,0),
    Vector2(0,0)
]

var hold_w_h:Vector2 = 	Vector2(35.7,14.8)

var target:Area2D
var population
var start:bool = false
var screen:Vector2
var box_size:Array
var poligons:Array
var pool_vec:PoolVector2Array
var color_pool:PoolColorArray


onready var hold1_shape:CollisionShape2D = $node_2d/hold1/collision_shape_2d
onready var hold1:Area2D = $node_2d/hold1
onready var lable:Label = $v_box_container/label
onready var Random:RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
    randomize()

    for x in range(len(hold_ponts)):
        hold_ponts[x] = hold_ponts[x] - (hold_w_h/2)

    for x in range(len(hold_ponts)):
        hold_ponts[x] = hold_ponts[x] * number

    var shape:ConvexPolygonShape2D = ConvexPolygonShape2D.new()
    var pool_vec:PoolVector2Array = PoolVector2Array(hold_ponts)
    shape.set_points(PoolVector2Array(pool_vec))
    hold1_shape.set_shape(shape)


    screen = get_viewport().size
    target = hold1
    
    for x in range(len(pool_vec)):
        pool_vec[x]=screen/2 + pool_vec[x]
    
    for _x in range(cargo_countity):
        var _w = rand_range(40,40)
        var _h = rand_range(40,40)
        var _pos_x = 0
        var _pos_y = 0
        
        var _poly_box = [Vector2( _pos_x , _pos_y ),
                        Vector2( _pos_x + _w , _pos_y ),
                        Vector2( _pos_x + _w, _pos_y + _h),
                        Vector2( _pos_x , _pos_y + _h)]
                        
        box_size.append(_poly_box)
        color_pool.append(Color(randi()))
        
    population = Population_cargo.new(target,
                        pool_vec,
                        MUTATION_RATE,
                        POP_MAX,
                        box_size,
                        screen)
#	hold1.add_child(population)

func _draw() -> void:
    var pool_vec2:PoolVector2Array = PoolVector2Array(hold_ponts)
    for x in range(len(pool_vec2)):
        pool_vec2[x]=screen/2 + pool_vec2[x]
            
    draw_polyline(pool_vec2,Color.red, 2.0)


# warning-ignore:unused_argument
func _process(delta: float) -> void:
    
    update()
    if population != null and start:
        if not population.finished():
            population.natural_selection()
            population.generate()
            population.calc_fitness()
        
            for _x in $node_2d.get_children():
                if _x is Polygon2D:
    #				print(_x.name)
                    _x.queue_free()
                    
            
            var index = 0
            var best = population.get_best_population() 
            for _gene in best.genes:
                add_polygon_2d(_gene,best.cargo_size[index],color_pool[index])
                index+=1
                
            lable.set_text(diplay_statistic())
        
        
func diplay_statistic()->String:
    var best = "Best phrase:   \n"
#	best+= population.get_best()+"\n"
    var total = "total generations:     "
    total+= str(population.get_generations())+"\n"
    var fit = "average fitness:       "
    fit+= str(population.get_average_fitness()) +"\n"
    var best_fit = "Best fitness:       "
    best_fit+= str(population.get_best_population().fitness) +"\n"
    var tot_pop = "total population: "
    tot_pop+= str(POP_MAX) +"\n"
    var mutation = "mutation rate:         " 
    mutation+= str(MUTATION_RATE)+"\n"
    return best+total+best_fit+fit+tot_pop+mutation
    
func add_polygon_2d(pos:Vector2,_size:Array,color:Color)->void:
    var Poli:Polygon2D = Polygon2D.new()
    var f:Array = _size.duplicate(true)
    for x in range(len(f)):
        f[x]+=pos
        
    Poli.set_polygon(PoolVector2Array(f))
    Poli.set_color(color)
    $node_2d.add_child(Poli)


func _on_button_toggled(button_pressed: bool) -> void:
    if button_pressed:
        $"v_box_container/button".set_text("STOP")
#		population = Population_cargo.new(target,
#					pool_vec,
#					MUTATION_RATE,
#					POP_MAX,
#					box_size,
#					screen)

        start = true
    elif not button_pressed:
        $"v_box_container/button".set_text("START")
        start = false
    


