entity() spawn_enforcer;
entity() spawn_knight;
entity() spawn_hknight;
entity() spawn_demon;
entity() spawn_ogre;
entity() spawn_wizard;
entity() spawn_shambler;

entity() spawn_enforcer = 
{
    local	entity e;

    e = spawn ();
	e.owner = self;

    e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/enforcer.mdl");

    //setorigin (e, self.origin);
	setsize (e, '-16 -16 -24', '16 16 40');

	e.health = 80;
    e.angles = self.angles;

	e.th_stand = enf_stand1;
	e.th_walk = enf_walk1;
	e.th_run = enf_run1;
	e.th_pain = enf_pain;
	e.th_die = enf_die;
	e.th_missile = enf_atk1;
    e.think = walkmonster_start;
    e.nextthink = time + 0.1;

    return e;
};

entity() spawn_knight =
{
    local	entity e;

    e = spawn ();
	e.owner = self;

    e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/knight.mdl");

    //setorigin (e, self.origin);
	setsize (e, '-16 -16 -24', '16 16 40');
	e.health = 75;

	e.th_stand = knight_stand1;
	e.th_walk = knight_walk1;
	e.th_run = knight_run1;
	e.th_melee = knight_atk1;
	e.th_pain = knight_pain;
	e.th_die = knight_die;

    return e;
};

entity() spawn_hknight =
{
    local entity e;

    e = spawn ();
	e.owner = self;

    e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/hknight.mdl");

    //setorigin (e, self.origin);
	setsize (e, '-16 -16 -24', '16 16 40');
	e.health = 250;

	e.th_stand = hknight_stand1;
	e.th_walk = hknight_walk1;
	e.th_run = hknight_run1;
	e.th_melee = hknight_melee;
	e.th_missile = hknight_magicc1;
	e.th_pain = hknight_pain;
	e.th_die = hknight_die;
	
    e.think = walkmonster_start;
    e.nextthink = time + 0.1;

    return e;
}

entity() spawn_demon =
{
	local entity e;

	e = spawn();
	e.owner = self;

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/demon.mdl");

	setsize (e, VEC_HULL2_MIN, VEC_HULL2_MAX);
	e.health = 300;

	e.th_stand = demon1_stand1;
	e.th_walk = demon1_walk1;
	e.th_run = demon1_run1;
	e.th_die = demon_die;
	e.th_melee = Demon_MeleeAttack;		// one of two attacks
	e.th_missile = demon1_jump1;			// jump attack
	e.th_pain = demon1_pain;

	return e;
}

entity() spawn_ogre =
{
	local entity e;

	e = spawn();
	e.owner = self;
	
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/ogre.mdl");

	setsize (e, VEC_HULL2_MIN, VEC_HULL2_MAX);
	e.health = 200;

	e.th_stand = ogre_stand1;
	e.th_walk = ogre_walk1;
	e.th_run = ogre_run1;
	e.th_die = ogre_die;
	e.th_melee = ogre_melee;
	e.th_missile = ogre_nail1;
	e.th_pain = ogre_pain;

	return e;
}

entity() spawn_wizard =
{
	local entity e;
	
	e = spawn();
	e.owner = self;

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/wizard.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');
	e.health = 80;

	e.th_stand = wiz_stand1;
	e.th_walk = wiz_walk1;
	e.th_run = wiz_run1;
	e.th_missile = Wiz_Missile;
	e.th_pain = Wiz_Pain;
	e.th_die = wiz_die;

	return e;
}

entity() spawn_shambler
{
    local entity e;

    e = spawn ();
	e.owner = self;

    e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;
	setmodel (e, "progs/shambler.mdl");

    //setorigin (e, self.origin);
	setsize (e, VEC_HULL2_MIN, VEC_HULL2_MAX);
	e.health = 600;

	e.th_stand = sham_stand1;
	e.th_walk = sham_walk1;
	e.th_run = sham_run1;
	e.th_die = sham_die;
	e.th_melee = sham_melee;
	e.th_missile = sham_magic1;
	e.th_pain = sham_pain;

    //e.think = walkmonster_start;
    //e.nextthink = time + 0.1;

    return e;
}
