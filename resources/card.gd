class_name Card extends Resource

var id:int = 0
var description:String = ""
var fine_print:String = ""
var effect:Dictionary = {}

func _init(args:Dictionary={}):
	description = args.get("description", "")
	fine_print = args.get("fine_print", "")
	effect = args.get("effect", {})
	
func use(game:GameState):
	var handle = effect.get("handle")
	if handle:
		return call(handle)
	
