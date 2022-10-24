--Things to add
--Update log
--Bug reports
--Music by Juhani Junkala
--add hot key combat and abils
function love.load()
--timer require
Timer = require 'humptimer'

--atom testing

--spite setup
player = {x = 10, y = 10, w = 10, h = 10,health = 100, damage = 10}
enemy = {x = 30, y = 30, w = 10, h = 10,health = 20,damage = 5}
exit = {x = 165, y = 50, w = 10, h = 20}

--image import
background_main = love.graphics.newImage("main.png")
player_art = love.graphics.newImage("player_warrior.png")
enemy_art = love.graphics.newImage("skelly.png")
door = love.graphics.newImage("door.png")
arrow = love.graphics.newImage("arrow.png")
slash = love.graphics.newImage("slash.png")
hotbar_art = love.graphics.newImage("hotbar.png")
spellBook = love.graphics.newImage("spellBook.png")
healthPotion = love.graphics.newImage("healthPotion.png")
healthPotGui = love.graphics.newImage("healthPotGui.png")
sword = love.graphics.newImage("sword.png")
SpellGui = love.graphics.newImage("SpellGui.png")
boarder = love.graphics.newImage("boarder.png")

--audio setup
sounds = {}
sounds.background_audio = love.audio.newSource("background-audio-3.wav", "stream")
sounds.attack_effect = love.audio.newSource("attack.wav", "static")
sounds.pickup_sound = love.audio.newSource("pickup.wav", "static")

sounds.background_audio:setVolume(0.2)
sounds.attack_effect:setVolume(1.5)
sounds.pickup_sound:setVolume(1.5)

sounds.background_audio:play()

--font import and setup
font = love.graphics.newFont("main_font.ttf", 15)
love.graphics.setFont(font)

--setting screen settings
love.window.setTitle("The room")
screenx = 200
screeny = 220
love.window.setMode(screenx, screeny)

--setting default variables
player_alive = true
enemy_alive = true
battle = false
move = true
level_end = false
level = 1
intro = true
index = false
hotbar = true
buff = false
potions = 1
spells = 1
pickup = false
selected = 1

end

function love.update(dt)
--setting timer
Timer.update(dt)
--loop bg audio
if not sounds.background_audio:isPlaying( ) then
		love.audio.play(sounds.background_audio)
	end

if battle == false then
selected = 1
end
--while battling if health is less than 0 do stuff
if battle == true then
if player.health <= 0 then
        battleSeq = false
        battle = false
        move = false
        player_alive = false
    end
if enemy.health <= 0 then
        battle = false
        move = true
        enemy_alive = false
        battleSeq = false
				pickup = false
				pickup_choice = math.random(1,2)
    end
    end

--collision detections
if enemy_alive == true then
battleSeq = detectCollision(player.x,enemy.x,player.y,enemy.y,20)
    end

if enemy_alive == false then
        exit_collide = detectCollision(player.x,exit.x + 5,player.y,exit.y + 10,20)
    end

if pickup == false then
        item_collide = detectCollision(player.x,enemy.x,player.y,enemy.y,10)
    end

if item_collide == true then
pickup = true
item_collide = false
sounds.pickup_sound:play()
if pickup_choice == 1 then
			potions = potions + 1
		elseif pickup_choice == 2 then
			spells = spells + 1
		end
		pickup_choice = 0
	end
--what happens once collisions occur
if exit_collide == true then
        level_end = true
        move = false
    end

if battleSeq == true then
battle = true
move = false
end

end



function love.draw()
    --draw background
    for i = 0, love.graphics.getWidth() / background_main:getWidth() do
          for j = 0, love.graphics.getHeight() / background_main:getHeight() do
              love.graphics.draw(background_main, i * background_main:getWidth(), j * background_main:getHeight())
          end
      end

if player_alive == true then
if pickup == false then
if battle == false then
if enemy_alive == false then
love.graphics.print("Chase your loot!",20,201)
end
end
end
end
    if intro == true then
        love.graphics.print("The room",60,50)
        love.graphics.print("Press space",45,100)
    end
    if index == true then
    if player_alive == false then
        love.graphics.print("You died at level",26,50)
        love.graphics.print(level,100,80)
        love.graphics.print("Press space",46,100)
    end
    --at the end of level art
    if level_end == true then
        love.graphics.print("You are at level",28,50)
        love.graphics.print(level,100,80)
        love.graphics.print("Press space", 50,200)
        love.graphics.draw(arrow, 50, 80)
    end
    --main game art
    if level_end == false then
    if enemy_alive == false then
			if pickup_choice == 1 then
					love.graphics.draw(healthPotion, enemy.x,enemy.y)
				elseif pickup_choice == 2 then
					love.graphics.draw(spellBook, enemy.x,enemy.y)
				end
    if player_alive == true then
    --love.graphics.rectangle("line",exit.x,exit.y,exit.w,exit.h)
    love.graphics.draw(door,exit.x,exit.y)
  end
    end
    if player_alive == true then
    --love.graphics.rectangle("fill",player.x,player.y,player.w,player.h)
    love.graphics.draw(player_art,player.x,player.y)
    end
    if enemy_alive == true then
    --love.graphics.rectangle("line",enemy.x,enemy.y,enemy.w,enemy.h)
    love.graphics.draw(enemy_art,enemy.x,enemy.y)
    end
    --battle text
    if battle == true then
		if hotbar == true then
					love.graphics.draw(hotbar_art, 60,160)
					itemx = 87
					itemy = 164
					if selected == 1 then
						love.graphics.draw(sword,itemx,itemy)
					elseif selected == 2 then
						love.graphics.draw(healthPotGui,itemx,itemy)
					elseif selected == 0 then
						love.graphics.draw(SpellGui,itemx,itemy)
					end
					love.graphics.draw(boarder, 87,164)
				end
    love.graphics.print("P:",10,201)
    love.graphics.print(player.health, 30,201)
    love.graphics.print("E:",130,201)
    love.graphics.print(enemy.health, 150,201)
    end
    end
    end
end

--collision detection function
function detectCollision(x1, x2, y1, y2, sens)
if math.abs(x1 - x2) < sens and math.abs(y1 - y2) < sens then
  return true
else
  return false
end
end

--key press function that runs once rather than a constant
function love.keypressed(key)
if intro == true then
if key == "space" then
intro = false
            index = true
        end
    end
if index == true then
if player_alive == false then
if key == "space" then
level = 1
pickup = 0
player.x = 10
player.y = 10
player.health = 100
player.damage = 10
enemy.x = 30
enemy.y = 30
enemy.health = 20
enemy.damage = 5
player_alive = true
enemy_alive = true
move = true
        end
    end
--get rid of level buffs
if level_end == true then
        if key == "space" then
        level_end = false
        exit_collide = false
        move = true
        print("2nd space goin")
        enemy_alive = true
        enemy.x = 50
        enemy.y = 50
				enemy.damage = enemy.damage + 2
        enemy.health = 20
        enemy.health = enemy.health * level / 2
        player.x = 10
        player.y = 10
        level = level + 1
        buffTwo = math.random(1,2)
        if buffTwo == 1 then
                player.damage = player.damage + 2
            elseif buffTwo == 2 then
                player.health = player.health + 10
            end
        end
    end

if battle == true then
  if enemy.health > 0 then
if key == "d" or key == "right" then
				if selected == 0 then
					selected = 1
				elseif selected == 1 then
					if potions > 0 then
						selected = 2
					end
				end
elseif key == "a" or key == "left" then
				if selected == 2 then
					selected = 1
				elseif selected == 1 then
					if spells > 0 then
						selected = 0
					end
				end
end
end
if buff ~= true then buff = false end
if key == "space" then
if selected == 1 then
sounds.attack_effect:play()
if buff == true then
player_attack = math.random(1,player.damage + 10)
enemy.health = enemy.health - player_attack
buff = false
end
if buff == false then
print("check")
player_attack = math.random(1,player.damage)
enemy.health = enemy.health - player_attack

end
				end
if selected == 0 then
					print("spell")
if spells > 0 then
buff = true
spells = spells - 1
					end
				end
if selected == 2 then
if potions > 0 then
						print("potion")
player.health = player.health + 10
potions = potions - 1
end
				end
			end


			enemy_attack = math.random(1,enemy.damage)
			player.health = player.health - enemy_attack
        end
--enemy movement
if move == true then
direction = math.random(1, 4)
if direction == 1 then
        if enemy.y > 10 then
            enemy.y = enemy.y - 10
        end
    end
if direction == 2 then
        if enemy.y < screeny - 30 then
            enemy.y = enemy.y + 10
        end
    end
if direction == 3 then
        if enemy.x > 10 then
            enemy.x = enemy.x - 10
        end
    end
if direction == 4 then
        if enemy.x < screenx - 20 then
            enemy.x = enemy.x + 10
        end
    end
--player movement
if key == "w" or key == "up" then
    if player.y > 10 then
    player.y = player.y - 10
        end
elseif key == "s" or key == "down" then
        if player.y < screeny - 30 then
    player.y = player.y + 10
        end
elseif key == "a" or key == "left" then
        if player.x > 10 then
    player.x = player.x - 10
        end
elseif key == "d" or key == "right" then
        if player.x < screenx - 20 then
    player.x = player.x + 10
        end
    end
        end
end
end
