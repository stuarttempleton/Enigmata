extends Node


enum AUDIO_KEY {
	BUTTON_ACCEPT,
	BUTTON_CANCEL,
	OPTION_CHANGE,
	
	ITEM_PICKUP,
	ITEM_DROP,
	ITEM_TURN_IN,
	BOX_COLLISION,
	
	GAME_COMPLETE
	}

export var Audio = {
	AUDIO_KEY.BUTTON_ACCEPT:"res://AudioPlayer/Audio/Kenney/click1.ogg",
	AUDIO_KEY.BUTTON_CANCEL:"res://AudioPlayer/Audio/Kenney/click2.ogg",
	AUDIO_KEY.OPTION_CHANGE:"res://AudioPlayer/Audio/Kenney/click4.ogg",
	
	AUDIO_KEY.ITEM_PICKUP:"res://AudioPlayer/Audio/Kenney/handleSmallLeather2.ogg",
	AUDIO_KEY.ITEM_DROP:"res://AudioPlayer/Audio/Kenney/handleSmallLeather.ogg",
	AUDIO_KEY.ITEM_TURN_IN:"res://AudioPlayer/Audio/Kenney/glass_005.ogg",
	AUDIO_KEY.BOX_COLLISION:"res://AudioPlayer/Audio/Kenney/glass_005.ogg",
	
	AUDIO_KEY.GAME_COMPLETE:"res://AudioPlayer/Audio/Kenney/glass_005.ogg"
	}

var doFade = false
var fade_out = true
var fade_counter = 1.0
var fade_speed = 1.0


func _process(delta):
	if doFade:
		if fade_out:
			fade_counter -= delta * fade_speed
		else:
			fade_counter += delta * fade_speed
		
		if fade_counter < 0:
			fade_counter = 0
			$MusicPlayer.stop()
			fade_out = false #done!
		elif fade_counter > 1:
			fade_counter = 1
			doFade = false #done done!
		$MusicPlayer.volume_db = linear2db(fade_counter)

func FadeOutMusic(spd = 1.0):
	fade_counter = 1.0
	fade_speed = spd
	fade_out = true
	doFade = true

func StopUI(): 
	$UIPlayer.stop()
	
func StopSFX(): 
	$SFXPlayer.stop()
	
func StopMusic(): 
	$MusicPlayer.stop()
	

func PlayUI(key):
	$UIPlayer.stream = load(Audio[key])
	$UIPlayer.play()

func PlayMusic(key):
	$MusicPlayer.stream = load(Audio[key])
	$MusicPlayer.play()

func PlaySFX(key):
	$SFXPlayer.stream = load(Audio[key])
	$SFXPlayer.play()
