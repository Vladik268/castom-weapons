SMRDigitalGui = SMRDigitalGui or class()
function SMRDigitalGui:init(unit)
	self._unit = unit
	self._visible = true

	self._good_texture = "units/mods/weapons/wpn_fps_at_sidewinder_gui_textures/ammo_counter_good"
	self._warning_texture = "units/mods/weapons/wpn_fps_at_sidewinder_gui_textures/ammo_counter_warning"
	self._danger_texture = "units/mods/weapons/wpn_fps_at_sidewinder_gui_textures/ammo_counter_danger"

	self._new_gui = World:gui()

	self._left_ws = self._new_gui:create_object_workspace(512, 512, self._unit:get_object(Idstring("ammo_display_left")), Vector3(0, 0, 0))
	self._left_panel = self._left_ws:panel()

	self._right_ws = self._new_gui:create_object_workspace(512, 512, self._unit:get_object(Idstring("ammo_display_right")), Vector3(0, 0, 0))
	self._right_panel = self._right_ws:panel()

	self:setup()
	self:set_ammo_percentage(1)

	self._unit:set_extension_update_enabled(Idstring("digital_gui"), false)
end

function SMRDigitalGui:setup()
	self._left_panel:clear()
	self._left_ammo = self._left_panel:bitmap({
		layer = 1,
		width = 512,
		height = 512,
		valign = "top",
		halign = "left",
		texture = self._good_texture,
		render_template = "OverlayVertexColorTexturedRadial"
	})

	self._right_panel:clear()
	self._right_ammo = self._right_panel:bitmap({
		layer = 1,
		width = 512,
		height = 512,
		valign = "top",
		halign = "left",
		texture = self._good_texture,
		render_template = "OverlayVertexColorTexturedRadial"
	})
end

function SMRDigitalGui:set_ammo_percentage(percentage)
	local radial_percent = 0.79 + (percentage * 0.21)
	local radial_colour = Color(1, radial_percent, 1, 1)
	self._left_ammo:set_color(radial_colour)
	self._right_ammo:set_color(radial_colour)

	if percentage < 0.35 then
		self._left_ammo:set_image(self._danger_texture)
		self._right_ammo:set_image(self._danger_texture)
	elseif percentage < 0.5 then
		self._left_ammo:set_image(self._warning_texture)
		self._right_ammo:set_image(self._warning_texture)
	else
		self._left_ammo:set_image(self._good_texture)
		self._right_ammo:set_image(self._good_texture)
	end
end

function SMRDigitalGui:set_visible(visible)
	self._visible = visible

	if visible then
		self._left_ws:show()
		self._right_ws:show()
	else
		self._left_ws:hide()
		self._right_ws:hide()
	end
end

function SMRDigitalGui:destroy()
	if alive(self._new_gui) and alive(self._left_ws) and alive(self._right_ws) then
		self._new_gui:destroy_workspace(self._left_ws)
		self._new_gui:destroy_workspace(self._right_ws)

		self._left_ws = nil
		self._right_ws = nil
		self._new_gui = nil
	end
end