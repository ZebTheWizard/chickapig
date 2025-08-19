class_name Card extends Resource

var id:int = 0
var description:String = ""
var fine_print:String = ""
var effect:Dictionary = {}

func _init(args:Dictionary={}):
	description = args.get("description", "")
	fine_print = args.get("fine_print", "")
	effect = args.get("effect", {})
	
func invoke_effect(game:GameState):
	var handle = effect.get("handle")
	if handle:
		return call(handle)
	game.player.played_cards = game.player.played_cards.filter(func (c:Card): return c.id != self.id)
	
