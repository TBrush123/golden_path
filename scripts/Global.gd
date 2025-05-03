extends Node


signal dialogueEnd(scene)
signal startTrade
signal dialogueInit(dialogueName)
signal worldChanged
signal newItem(item)
signal newItemGiven

var isNPCSpawned: bool = false
var given_item: Dictionary
