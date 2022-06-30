extends Node

const ItemDatabase = preload("res://scripts/databases/item_database.gd")
const RaceDatabase = preload("res://scripts/databases/race_database.gd")
const ClassDatabase = preload("res://scripts/databases/class_database.gd")

var items := ItemDatabase.new()
var races := RaceDatabase.new()
var classes := ClassDatabase.new()