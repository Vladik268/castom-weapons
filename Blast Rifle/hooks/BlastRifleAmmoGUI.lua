--written by Offyerrocker
--based on MisriahAmmoGui, also written by Offyerrocker
--thanks to Pawcio for making the horzine sight that taught me that i could just make extensions

BlastRifleAmmoGUI = BlastRifleAmmoGUI or class()

function BlastRifleAmmoGUI:init(unit)
	self._unit = self._unit or unit
	self._gui_object = self._gui_object or ""

	self.reserve_font_color = self.reserve_font_color or "ffffff"
	self._reserve_font_color = Color(self.reserve_font_color)
	self.reserve_font_name = self.reserve_font_name or "fonts/font_medium_mf"
	self.reserve_font_size = self.reserve_font_size or 16
	self.reserve_font_offset_x = self.reserve_font_offset_x or 0
	self.reserve_font_offset_y = self.reserve_font_offset_y or 1
	if self.reserve_is_monospaced == nil then 
		self.reserve_is_monospaced = false
	end
	self.reserve_kern = self.reserve_kern or nil
	self.reserve_halign = self.reserve_halign or "center"
	self.reserve_valign = self.reserve_valign or "top"
	
	self.magazine_font_name = self.magazine_font_name or "fonts/font_medium_mf"
	self.magazine_font_size = self.magazine_font_size or 36
	self.magazine_font_color = self.magazine_font_color or "ffffff"
	self._magazine_font_color = Color(self.magazine_font_color)
	self.magazine_font_offset_x = self.magazine_font_offset_x or 0
	self.magazine_font_offset_y = self.magazine_font_offset_y or 0
	if self.magazine_is_monospaced == nil then 
		self.magazine_is_monospaced = false
	end
	self.magazine_kern = self.magazine_kern or nil
	self.magazine_halign = self.magazine_halign or "center"
	self.magazine_valign = self.magazine_valign or "bottom"

	self.rangefinder_font_name = self.rangefinder_font_name or "fonts/font_medium_mf"
	self.rangefinder_font_size = self.rangefinder_font_size or 12
	self.rangefinder_font_color = self.rangefinder_font_color or "ffffff"
	self._rangefinder_font_color = Color(self.rangefinder_font_color)
	self.rangefinder_font_offset_x = self.rangefinder_font_offset_x or 0
	self.rangefinder_font_offset_y = self.rangefinder_font_offset_y or 0
	if self.rangefinder_is_monospaced == nil then 
		self.rangefinder_is_monospaced = false
	end
	self.rangefinder_kern = self.rangefinder_kern or nil
	self.rangefinder_halign = self.rangefinder_halign or "right"
	self.rangefinder_valign = self.rangefinder_valign or "top"
	
	self.kills_font_name = self.kills_font_name or "fonts/font_medium_mf"
	self.kills_font_size = self.kills_font_size or 12
	self.kills_font_color = self.kills_font_color or "ffffff"
	self._kills_font_color = Color(self.kills_font_color)
	self.kills_font_offset_x = self.kills_font_offset_x or 17
	self.kills_font_offset_y = self.kills_font_offset_y or 24
	if self.kills_is_monospaced == nil then 
		self.kills_is_monospaced = false
	end
	self.kills_kern = self.kills_kern or nil
	self.kills_halign = self.kills_halign or "left"
	self.kills_valign = self.kills_valign or "top"
	
	if self.ammotype_bitmap_rect_x and self.ammotype_bitmap_rect_y and self.ammotype_bitmap_rect_w and self.ammotype_bitmap_rect_h then
		self.ammotype_bitmap_rect = {
			self.ammotype_bitmap_rect_x,
			self.ammotype_bitmap_rect_y,
			self.ammotype_bitmap_rect_w,
			self.ammotype_bitmap_rect_h
		}
	else
		self.ammotype_bitmap_rect = {62,0,128,128} --self.ammotype_bitmap_rect or nil
	end
	self.ammotype_bitmap_x = self.ammotype_bitmap_x or 0
	self.ammotype_bitmap_y = self.ammotype_bitmap_y or 0
	self.ammotype_bitmap_w = self.ammotype_bitmap_w or 32
	self.ammotype_bitmap_h = self.ammotype_bitmap_h or 32
	
	self.deco_bitmap_texture = self.deco_bitmap_texture or nil
	if self.deco_bitmap_rect_x and self.deco_bitmap_rect_y and self.deco_bitmap_rect_w and self.deco_bitmap_rect_h then
		self.deco_bitmap_rect = {
			self.deco_bitmap_rect_x,
			self.deco_bitmap_rect_y,
			self.deco_bitmap_rect_w,
			self.deco_bitmap_rect_h
		}
	else
		self.deco_bitmap_rect = self.deco_bitmap_rect or nil
	end
	self.deco_bitmap_x = self.deco_bitmap_x or 0
	self.deco_bitmap_y = self.deco_bitmap_y or 0
	self.deco_bitmap_w = self.deco_bitmap_w or 32
	self.deco_bitmap_h = self.deco_bitmap_h or 32
	self.deco_bitmap_color = self.deco_bitmap_color or "ffffff"
	self._deco_bitmap_color = Color(self.deco_bitmap_color)
	
	self._kills_bitmap_name = self._kills_bitmap_name or "wp_target"
	self.kills_bitmap_x = self.kills_bitmap_x or 0
	self.kills_bitmap_y = self.kills_bitmap_y or 24
	self.kills_bitmap_w = self.kills_bitmap_w or 16
	self.kills_bitmap_h = self.kills_bitmap_h or 16
	self.kills_bitmap_color = self.kills_bitmap_color or "ffffff"
	self._kills_bitmap_color = Color(self.kills_bitmap_color)
	self.kills_bitmap_color_low = self.kills_bitmap_color_low or "ff0000"
	self._kills_bitmap_color_low = Color(self.kills_bitmap_color_low)
	
	self._bg_rect_alpha = self._bg_rect_alpha or 0.5
	self.bg_rect_color = self.bg_rect_color or "000000"
	self._bg_rect_color = Color(self.bg_rect_color)
	
	self.num_characters_rangefinder = self.num_characters_rangefinder or 4
	self.max_counter_value_rangefinder = self.max_counter_value_rangefinder or (math.pow(10,self.num_characters_rangefinder) - 1)
	
	self.num_characters_magazine = self.num_characters_magazine or 2
	self.num_characters_reserve = self.num_characters_reserve or 2
	self.max_counter_value_magazine = self.max_counter_value_magazine or (math.pow(10,self.num_characters_magazine) - 1)
	self.max_counter_value_reserve = self.max_counter_value_reserve or (math.pow(10,self.num_characters_reserve) - 1)
	
	self.offset_position_x = self.offset_position_x or 0
	self.offset_position_y = self.offset_position_y or 0
	self.offset_position_z = self.offset_position_z or 0
	
	self.offset_rotation_yaw = self.offset_rotation_yaw or 0
	self.offset_rotation_pitch = self.offset_rotation_pitch or 0
	self.offset_rotation_roll = self.offset_rotation_roll or 0
	
	self.PANEL_WIDTH = self.PANEL_WIDTH or 100
	self.PANEL_HEIGHT = self.PANEL_HEIGHT or 100
	self.WORLD_WIDTH = self.WORLD_WIDTH or 2
	self.WORLD_HEIGHT = self.WORLD_HEIGHT or 2
	
	self._new_gui = World:gui()
	
	self._syphon_spin_timer = 0 --init spin
	self.killcounter_num = 0 --init killcounter
	
	self._SYPHON_ANIM_ROT_SPEED = self._SYPHON_ANIM_ROT_SPEED or 720
	self._SYPHON_ANIM_SPIN_TIME = self._SYPHON_ANIM_SPIN_TIME or 1
	self.LOW_AMMO_THRESHOLD = self.LOW_AMMO_THRESHOLD or 1/4
	self.LOW_AMMO_FLASH_SPEED = self.LOW_AMMO_FLASH_SPEED or 500
	self.AMMO_ICONS_PATH = self.AMMO_ICONS_PATH or "guis/dlcs/mods/textures/pd2/blackmarket/icons/mods/"
	self.AMMO_ICONS_RECT = {
		wpn_fps_upg_blast_ammo_ap = {
			70,
			8,
			110,
			110
		},
		wpn_fps_upg_blast_ammo_fire = {
			72,
			5,
			110,
			110
			
		},
		wpn_fps_upg_blast_ammo_poison = {
			71,
			3,
			110,
			110
		},
		wpn_fps_upg_blast_ammo_stun = {
			70,
			8,
			110,
			110
			
		},
		wpn_fps_upg_blast_ammo_syphon = {
			69,
			6,
			112,
			112
			
		}
	}
	
	local object_name = self._gui_object 
--	log("blastrifle: " .. tostring(object_name or "ERROR bad object name"))
	local object_ids = object_name and Idstring(object_name)
--	log("blastrifle: " .. tostring(object_ids or "ERROR bad object ids"))
	local object = object_ids and self._unit:get_object(object_ids)
--	log("blastrifle: " .. tostring(object or ("ERROR bad object " .. tostring(object_name))))
	if not object then 
		object = self._unit:orientation_object()
--		log("blastrifle: defaulting to orientation object")
	end

	
	if object then 
		self:add_workspace(object)
	end
	
end

function BlastRifleAmmoGUI:add_workspace(gui_object)
	local onscreen_w = self.WORLD_WIDTH
	local onscreen_h = self.WORLD_HEIGHT
	local actual_w = self.PANEL_WIDTH
	local actual_h = self.PANEL_HEIGHT
	
	local ra = gui_object:rotation()
	
	local rb = Rotation(self.offset_rotation_yaw,self.offset_rotation_pitch,self.offset_rotation_roll)
	
	local rot = Rotation(ra:yaw() + rb:yaw(),ra:pitch() + rb:pitch(),ra:roll() + rb:roll())
	
	local x_axis = Vector3(onscreen_w,0,0)
	
	mvector3.rotate_with(x_axis,rot)
	
	local y_axis = Vector3(0,-onscreen_h,0)
	
	mvector3.rotate_with(y_axis,rot)
	
	local center = Vector3(onscreen_w / 2,onscreen_h / 2,0)
	
	mvector3.rotate_with(center,rot)
	
	local offset = Vector3(self.offset_position_x,self.offset_position_y,self.offset_position_z)
	
	mvector3.rotate_with(offset,rot)
	
	local position = gui_object:position()
	
	self._ws = self._new_gui:create_world_workspace(actual_w,actual_h,position,x_axis,y_axis)
	
	self._ws:set_linked(actual_w,actual_h,gui_object,position - center + offset,x_axis,y_axis)
	
	self._panel = self._ws:panel():panel({
		name = "ammo_counter_panel",
		layer = 1
	})
	
	self._reserve_text = self._panel:text({
		name = "reserve_text",
		font = self.reserve_font_name,
		font_size = self.reserve_font_size,
		text = "000",
		layer = 3,
		color = self._reserve_font_color,
		x = self.reserve_font_offset_x,
		y = self.reserve_font_offset_y,
		monospace = self.reserve_is_monospaced,
		kern = self.reserve_kern,
		align = self.reserve_halign,
		vertical = self.reserve_valign
	})
	self._magazine_text = self._panel:text({
		name = "magazine_text",
		font = self.magazine_font_name,
		font_size = self.magazine_font_size,
		text = "00",
		layer = 3,
		color = self._magazine_font_color,
		x = self.magazine_font_offset_x,
		y = self.magazine_font_offset_y,
		monospace = self.magazine_is_monospaced,
		kern = self.magazine_kern,
		align = self.magazine_halign,
		vertical = self.magazine_valign
	})
	
	self._rangefinder_text = self._panel:text({
		name = "rangefinder",
		font = self.kills_font_name,
		font_size = self.rangefinder_font_size,
		text = "0m",
		layer = 3,
		color = self._rangefinder_font_color,
		x = self.rangefinder_font_offset_x,
		y = self.rangefinder_font_offset_y,
		monospace = self.rangefinder_is_monospaced,
		kern = self.rangefinder_kern,
		align = self.rangefinder_halign,
		vertical = self.rangefinder_valign
	})
	
	self._ammotype_bitmap = self._panel:bitmap({
		name = "ammotype_bitmap",
		texture = "guis/textures/pd2/hud_radial_rim",
		texture_rect = {0,0,0,0},
		x = self.ammotype_bitmap_x,
		y = self.ammotype_bitmap_y,
		w = self.ammotype_bitmap_w,
		h = self.ammotype_bitmap_h,
		visible = true,
		layer = 2
	})
	
	self._deco_bitmap = self._panel:bitmap({
		name = "deco_bitmap",
		texture = self.deco_bitmap_texture,
		texture_rect = self.deco_bitmap_rect,
		x = self.deco_bitmap_x,
		y = self.deco_bitmap_y,
		w = self.deco_bitmap_w,
		h = self.deco_bitmap_h,
		visible = true,
		color = self._deco_bitmap_color,
		layer = 2
	})
	
	local a,b = tweak_data.hud_icons:get_icon_data(self._kills_bitmap_name)
	self._kills_bitmap = self._panel:bitmap({
		name = "kills_bitmap",
		texture = a,
		texture_rect = b,
		x = self.kills_bitmap_x,
		y = self.kills_bitmap_y,
		w = self.kills_bitmap_w,
		h = self.kills_bitmap_h,
		visible = true,
		color = self._kills_bitmap_color,
		layer = 2
	})
	
	self._kills_text = self._panel:text({
		name = "kills_text",
		font = self.kills_font_name,
		font_size = self.kills_font_size,
		text = "0",
		layer = 3,
		color = self._kills_font_color,
		x = self.kills_font_offset_x,
		y = self.kills_font_offset_y,
		monospace = self.kills_is_monospaced,
		kern = self.kills_kern,
		align = self.kills_halign,
		vertical = self.kills_valign
	})
	
	self._bg_rect = self._panel:rect({
		name = "bg_rect",
		color = self._bg_rect_color,
		visible = true,
		alpha = self._bg_rect_alpha,
		layer = 1
	})
	
	self:animate_ammotype_pulse()
end

function BlastRifleAmmoGUI:set_visible(visible)
	if visible then 
		self._ws:show()
	else
		self._ws:hide()
	end
end

function BlastRifleAmmoGUI:set_magazine_text(text)
	if alive(self._magazine_text) then 
		self._magazine_text:set_text(text)
	end
end

function BlastRifleAmmoGUI:set_ammo_reserve_text(text)
	if alive(self._reserve_text) then 
		self._reserve_text:set_text(text)
	end
end

function BlastRifleAmmoGUI:set_magazine_count(num,maximum)
	self:set_magazine_text(string.format("%i",math.clamp(num,0,self.max_counter_value_magazine)))
	local ratio = maximum and (num/maximum)
	if ratio and ratio <= self.LOW_AMMO_THRESHOLD then 
		self:animate_low_magazine_flash()
	else
		self:animate_low_magazine_flash_stop()
	end
end

function BlastRifleAmmoGUI:set_ammo_reserve_count(num)
	self:set_ammo_reserve_text(string.format("%i",math.clamp(num,0,self.max_counter_value_reserve)))
end

function BlastRifleAmmoGUI:set_kills_text(text)
	if alive(self._kills_text) then 
		self._kills_text:set_text(text)
	end
end

function BlastRifleAmmoGUI:set_kills_count(num)
	self:set_kills_text(string.format("%i",num))
end

function BlastRifleAmmoGUI:add_to_kills_counter(n)
	local num = n and tonumber(n)
	if num then 
		self:animate_killcounter_flash()
		self.killcounter_num = self.killcounter_num + num
		self:set_kills_count(self.killcounter_num)
	end
	
end

function BlastRifleAmmoGUI:set_range_counter(num)
	num = num and math.clamp(num,0,self.max_counter_value_rangefinder)
	self:set_range_text(num and string.format("%im",num) or "err")
end

function BlastRifleAmmoGUI:animate_low_magazine_flash()
	local flash_speed = self.LOW_AMMO_FLASH_SPEED
	local function anim_func(o)
		local t = 0
		while true do 
			local dt = coroutine.yield()
			local s = 1 + (math.sin(t * flash_speed) / 2)
			--[0.5, 1.5]
			o:set_color(Color(1,s,s))
			t = t + dt
		end
	end
	if alive(self._magazine_text) then 
		self._magazine_text:stop()
		self._magazine_text:animate(anim_func)
	end
	if alive(self._deco_bitmap) then 
		self._deco_bitmap:animate(anim_func)
	end
end

function BlastRifleAmmoGUI:animate_low_magazine_flash_stop()
	if alive(self._magazine_text) then 
		self._magazine_text:stop()
		self._magazine_text:set_color(self._magazine_font_color)
	end
	if alive(self._deco_bitmap) then 
		self._deco_bitmap:stop()
		self._deco_bitmap:set_color(self._deco_bitmap_color)
	end
end

function BlastRifleAmmoGUI:animate_killcounter_flash()
	local t = 0
	local duration = 2
	local killcounter_color = self._kills_bitmap_color
	local flash_color = self._kills_bitmap_color_low
	local function anim_func(o)
		while t <= duration do 
			local dt = coroutine.yield()
			local p = t / duration
			
			local dc = killcounter_color - flash_color
			local c = flash_color + (dc * p)
			
			o:set_color(c)
			 
			 t = t + dt
		 end
		 o:set_color(killcounter_color)
	end
	
	if alive(self._kills_text) then 
		self._kills_text:stop()
		self._kills_text:animate(anim_func)
	end
	
end

function BlastRifleAmmoGUI:refresh_syphon_spin_timer()
	self._syphon_spin_timer = self._SYPHON_ANIM_SPIN_TIME
end

function BlastRifleAmmoGUI:animate_ammotype_pulse() --rotation actually, not pulse
	local rot_speed = self._SYPHON_ANIM_ROT_SPEED
	
	local function anim_func(o)
		while true do 
			local dt = coroutine.yield()
			
			if self._syphon_spin_timer >= 0 then 
				local r = o:rotation() + (dt * rot_speed * self._syphon_spin_timer)
				
				o:set_rotation(r)
				
				self._syphon_spin_timer = self._syphon_spin_timer - dt
			end
		end
	end
	
	if alive(self._ammotype_bitmap) then 
		self._ammotype_bitmap:stop()
		self._ammotype_bitmap:animate(anim_func)
	end
	
end

function BlastRifleAmmoGUI:animate_ammotype_pulse_stop()
	if alive(self._ammotype_bitmap) then 
		self._ammotype_bitmap:stop()
	end
end

function BlastRifleAmmoGUI:set_range_text(text)
	if alive(self._rangefinder_text) then 
		self._rangefinder_text:set_text(text)
	end
end

function BlastRifleAmmoGUI:set_ammotype_icon(name)
	local rect = self.AMMO_ICONS_RECT[name] or self.ammotype_bitmap_rect or {}
	self._ammotype_bitmap:set_image(self.AMMO_ICONS_PATH .. name,unpack(rect))
end

function BlastRifleAmmoGUI:destroy()
	if alive(self._new_gui) and alive(self._ws) then
		self._new_gui:destroy_workspace(self._ws)

		self._ws = nil
		self._new_gui = nil
	end
end