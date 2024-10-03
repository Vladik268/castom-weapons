SMRWeaponBase = SMRWeaponBase or class(NewRaycastWeaponBase)

-- More Weapon Stats Support
if Faker then
	ProjectileWeaponBase = ProjectileWeaponBase or class(NewRaycastWeaponBase)

	Faker.classes.SMRWeaponBase = SMRWeaponBase
	Faker:redo_class('SMRWeaponBase', 'ProjectileWeaponBase')
end