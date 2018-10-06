void() spawner;
void() spawner_use;
void() spawner_think;

entity() spawn_enforcer;
entity() spawn_knight;
entity() spawn_hknight;
entity() spawn_shambler;

//=============
//    SPAWN
//=============

void() spawner = 
{
    if(self.targetname)
    {
        self.use = spawner_use;
        sprint(self, "Using targetname");
    }
    else 
    {
        // SPAWN ADEQUATE ENEMY
        self.think = spawner_think;
        self.nextthink = time;
        sprint(self, "Using delay");
    }    
};

// Used for spawns over time
void() spawner_think =
{
    spawner_use();
    self.nextthink = time + self.delay;
};

// Check the selected flag and spawn the right monster
void() spawner_use = {
    local entity e;

    if(self.flags == 0)
        e = spawn_enforcer();
    if(self.flags == 1)
        e = spawn_knight();
    if(self.flags == 2)
        e =spawn_hknight();
    if(self.flags == 6)
        e = spawn_shambler();

    // set general config
    setorigin (e, self.origin);
    e.think = walkmonster_start;
    e.nextthink = time + 0.1;

    play_teleport();
    particle(self.origin, '0 0 1', 0, 20);
};

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

    e.think = walkmonster_start;
    e.nextthink = time + 0.1;

    return e;
}

//=====================
//  WAVE SPAWN
//=====================

void() wave_spawn_start;
void() wave_spawn_link;
void() wave_spawnpoint;

void() wave_spawn_loop;
void() wave_findlinks;
void() wave_spawn;

//==========*
// Entities |
//==========*

// Starting point for spawning the wave
void() wave_spawn_start =
{
    self.delay = 0;
    self.think = wave_spawn_loop;
    self.nextthink = time + 1;
};

// These wave spawn must be triggered
void() wave_spawn_link = 
{
    self.use = wave_spawn_loop;
};

void() wave_spawnpoint =
{
    self.use =  spawner_use;
}

//===========*
// Functions |
//===========*

void() wave_spawn =
{   
    local entity e;
    local entity t, stemp, otemp
    local float i;

    e = checkclient();
    centerprint(e, self.message);

    // search for entities using "killtarget"
    // to be used as spawn point
    t = world;
    i = 1;
    do
    {
        t = find (t, targetname, self.killtarget);
        if (t)
        {
            stemp = self;
            otemp = other;
            self = t;
            other = stemp;
            if (self.use != SUB_Null)
            {
                if (self.use)
                    self.use ();
            }
            self = stemp;
            other = otemp;
        }
        else {
            i = 0;
        }
    } while (i);

    // search for the linked wave spawn
    self.think = wave_findlinks;
    self.nextthink = time + 1;
};


// Keep checking for the end of the wave
void() wave_spawn_loop = 
{   
    if(total_monsters == killed_monsters)
    {
        self.think = wave_spawn;
        self.nextthink = time + 1 + self.delay;
    }
    else 
    {
        self.think = wave_spawn_loop;
        self.nextthink = time + 1;
    }
};

void() wave_findlinks =
{
    local entity t, stemp, otemp;
    if (self.target)
	{
		t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t)
			{
				return;
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use ();
			}
			self = stemp;
			other = otemp;
		} while ( 1 );
	}
}