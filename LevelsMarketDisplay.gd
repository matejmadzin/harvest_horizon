extends HBoxContainer

class_name MarketItemDisplay

@onready var texture_rect : TextureRect = $TextureRect
@onready var number : Label = $number
@onready var less : Button = $less
@onready var more : Button = $more

@export var sell_count : Label 
@export var sell_button : Button
@export var money_count : Label
@export var end_money : Label
@onready var ButtonSFX : AudioStreamPlayer = $"../../../../ButtonSfx"
@onready var SellingSFX : AudioStreamPlayer = $"../../../../SellingSfx"
var sell_counter : int = 0
var market_changed_type : ResourceItem
var market_changed_count : int

@onready var resource_type: ResourceItem : 
	set(new_type):
		resource_type = new_type
		texture_rect.texture = resource_type.texture


var player_inventory : Inventory

func _ready():
	var player : Player = get_tree().get_first_node_in_group("player")
	player_inventory = player.find_child("Inventory") as Inventory
	player_inventory.connect("resource_count_changed", _on_market_changed)
	
func update_count(count : int):
	number.text = str(count)

func _on_market_changed(type : ResourceItem, new_count : int) -> void :
	if type.display_name=="wood":
		update_count(new_count)
		market_changed_type = type
		market_changed_count = new_count
		
func _on_more_button_up():
	print("Yes")
	ButtonSFX.volume_db=Global.soundValue
	ButtonSFX.play(0.23)
	if int(number.text)>sell_counter:
		sell_counter += 1
		sell_count.text = str(sell_counter)


func _on_less_button_up():
	print("Yes")
	ButtonSFX.volume_db=Global.soundValue
	ButtonSFX.play(0.23)
	if int(sell_count.text)>0:
		sell_counter -= 1
		sell_count.text = str(sell_counter)


func _on_sell_button_up():
	if market_changed_type and market_changed_type.display_name == "wood":
		if sell_count.text != str(0):
			SellingSFX.volume_db=Global.soundValue
			SellingSFX.play()
		Global.money += sell_counter*4
		market_changed_count-=sell_counter
		update_count(market_changed_count)
		player_inventory.add_resources(market_changed_type, -sell_counter)
		sell_counter=0
		sell_count.text=str(sell_counter)
		money_count.text = str(Global.money)
		end_money.text = str(Global.money)
		#emit_signal("money_changed")
	if sell_count.text == str(0):
		ButtonSFX.volume_db=Global.soundValue
		ButtonSFX.play(0.23)
		
