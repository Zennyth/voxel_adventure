extends Node

const ItemDatabase = preload("res://scripts/databases/item_database.gd")
const RaceDatabase = preload("res://scripts/databases/race_database.gd")
const ClassDatabase = preload("res://scripts/databases/class_database.gd")

var items: ItemDatabase = ItemDatabase.new()
var races: RaceDatabase = RaceDatabase.new()
var classes: ClassDatabase = ClassDatabase.new()
