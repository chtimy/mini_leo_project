extends Control

var menuAttackSize = Vector2(0.1, 0.2)
var menuAttackPosition = Vector2(0.7, 0.65)

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
func init(var i_listActionsDico, var i_actionsStringsCharacter, var viewportSize):
	var scroll = ScrollContainer.new()
	scroll.set_name("ScrollContainer")
	var vbox = VBoxContainer.new()
	vbox.set_name("VBoxContainer")
	add_child(scroll)
	scroll.add_child(vbox)
	scroll.set_custom_minimum_size(menuAttackSize * viewportSize)
	scroll.set_size(menuAttackSize * viewportSize)
	set_position(viewportSize * menuAttackPosition)
#	get_node("TextureRect").set_custom_minimum_size(get_node("ScrollContainer").get_size())
#	get_node("TextureRect").set_size(get_node("ScrollContainer").get_size())
#	get_node("TextureRect").set_expand(true)
	for actionStringCharacter in i_actionsStringsCharacter:
		var action = i_listActionsDico.m_actions[actionStringCharacter]
		#nouveau bouton pour l'action
		var button = {
			#nom de l'action
			name = action.name,
			#assignation des textures
			actionner = addItem(action.pathToTextures[0], action.pathToTextures[1], menuAttackSize * viewportSize),
			#id de l'action
			actionId = action.id
		}
		m_buttons.append(button)
		#if first option -> active the button
	if m_buttons.size() > 0:
		setActiveButton(0, ACTIVE_TEXTURE)

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
func addItem(var pathTexture, var pathTexturePressed, var sizeMenu):
	var choice = {
		textureButton = TextureButton.new(),
		textures = [load(pathTexture), load(pathTexturePressed)]
	}
	choice.textureButton.set_normal_texture(load(pathTexture))
	get_node("ScrollContainer/VBoxContainer").add_child(choice.textureButton)
	choice.textureButton.set_expand(true)
	#on essaye de scaler le bouton pour le case dans le layout à la bonne taille
	var scaleButton = (sizeMenu.y * 0.2) / choice.textureButton.texture_normal.get_size().y
	print(sizeMenu)
	print(choice.textureButton.texture_normal.get_size())
	choice.textureButton.set_custom_minimum_size(choice.textureButton.texture_normal.get_size() * scaleButton)
	#utile??
	choice.textureButton.set_size(choice.textureButton.texture_normal.get_size() * scaleButton)
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