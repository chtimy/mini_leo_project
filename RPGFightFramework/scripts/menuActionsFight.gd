extends Control

const MENU_ATTACK_SIZE = Vector2(0.1, 0.2)
const MENU_ATTACK_POSITION = Vector2(0.1, 0.15)

#struct Button
#{
#	string name
#	textureButton button
#	int actionId
#}

const NORMAL_TEXTURE = 0
const ACTIVE_TEXTURE = 1

var m_buttons = []
var m_currentButton = 0

#attention il y a redondance des informations #pour que ce soit plus clair
#listActions : liste d'actions dans le fichier texte d'actions (dictionnaire)
#actions : liste d'actions lié aux personnages (strings)
func _init(var i_listActionsDico, var i_actionsStringsCharacter):
	for actionStringCharacter in i_actionsStringsCharacter:
		var action = i_listActionsDico.m_actions[actionStringCharacter]
		#nouveau bouton pour l'action
		var button = {
			#nom de l'action
			name = action.name,
			#assignation des textures
			actionner = addItem(action.pathToTextures[0], action.pathToTextures[1]),
			#id de l'action
			actionId = action.id
		}
		m_buttons.append(button)

func reinit():
	m_currentButton = 0
	var i = 0
	for button in m_buttons:
		setActiveButton(i, NORMAL_TEXTURE)
		i += 1
	setActiveButton(0, ACTIVE_TEXTURE)
	
#Ajout d'un nouveau< TextureButton avec 
#pathTexture (texture normale) et 
#pathTexturePressed (texture press) en entrée
func addItem(var pathTexture, var pathTexturePressed):
	var choice = {
		textureButton = TextureButton.new(),
		textures = [load(pathTexture), load(pathTexturePressed)]
	}
	choice.textureButton.set_normal_texture(load(pathTexture))
	choice.textureButton.set_expand(true)
	return choice

# On gère le control du menu courant
func getAction():
	var action
	if Input.is_action_just_released("ui_take"):
		action = m_buttons[m_currentButton].name
	elif Input.is_action_just_released("ui_down"):
		if m_currentButton < m_buttons.size() - 1:
			m_currentButton = m_currentButton + 1
			setActiveButton(m_currentButton - 1, NORMAL_TEXTURE)
			setActiveButton(m_currentButton, ACTIVE_TEXTURE)
	elif Input.is_action_just_released("ui_up"):
		if m_currentButton > 0:
			m_currentButton = m_currentButton - 1
			setActiveButton(m_currentButton + 1, NORMAL_TEXTURE)
			setActiveButton(m_currentButton, ACTIVE_TEXTURE)
	return action

func setActiveButton(var index, var indexTexture):
	m_buttons[index].actionner.textureButton.set_normal_texture(m_buttons[index].actionner.textures[indexTexture])

func enable(var boolean):
	print(boolean)
	set_visible(boolean)
	if !boolean:
		reinit()
		
func _ready():
	var viewportSize = get_viewport().get_size()
	var scroll = ScrollContainer.new()
	scroll.set_name("ScrollContainer")
	var vbox = VBoxContainer.new()
	vbox.set_name("VBoxContainer")
	add_child(scroll)
	scroll.add_child(vbox)
	scroll.set_custom_minimum_size(MENU_ATTACK_SIZE * viewportSize)
	scroll.set_size(MENU_ATTACK_SIZE * viewportSize)
	set_position(MENU_ATTACK_POSITION * viewportSize)
	
	var sizeMenu = MENU_ATTACK_SIZE * viewportSize
	for button in m_buttons:
		vbox.add_child(button.actionner.textureButton)
		#on essaye de scaler le bouton pour le case dans le layout à la bonne taille
		var scaleButton = (sizeMenu.y * 0.2) / button.actionner.textureButton.texture_normal.get_size().y
		button.actionner.textureButton.set_custom_minimum_size(button.actionner.textureButton.texture_normal.get_size() * scaleButton)
		#utile??
		button.actionner.textureButton.set_size(button.actionner.textureButton.texture_normal.get_size() * scaleButton)
	
	
		#if first option -> active the button
	if m_buttons.size() > 0:
		setActiveButton(0, ACTIVE_TEXTURE)