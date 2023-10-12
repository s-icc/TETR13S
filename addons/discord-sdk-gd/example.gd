class_name DiscordSDKTutorial
extends Node

func _ready():
	if !discord_sdk.get_is_discord_working():
		discord_sdk.app_id = 1161750178940850237
		discord_sdk.large_image = "icon"
		discord_sdk.state = "Idle"
		discord_sdk.start_timestamp = int(Time.get_unix_time_from_system())
		# Always refresh after changing the values!
		discord_sdk.refresh()
