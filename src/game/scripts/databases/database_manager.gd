extends Node

const ItemDatabase = preload("res://scripts/databases/item_database.gd")
const RaceDatabase = preload("res://scripts/databases/race_database.gd")

var item: ItemDatabase = ItemDatabase.new()
var race: RaceDatabase = RaceDatabase.new()