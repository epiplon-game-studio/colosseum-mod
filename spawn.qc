void() spawner;
void() spawner_use;
void() spawner_think;



void() spawn_enforcer;
void() spawn_knight;

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
    if(self.flags == 0)
        spawn_enforcer();
    if(self.flags == 1)
        spawn_knight();

    if(self.flags < 2)
    {
        play_teleport();
        particle(self.origin, '0 0 1', 0, 20);
    }
};

void() spawn_enforcer = 
{
    local	entity enemy;

    enemy = spawn ();
	enemy.owner = self;

    enemy.solid = SOLID_SLIDEBOX;
	enemy.movetype = MOVETYPE_STEP;

	setmodel (enemy, "progs/enforcer.mdl");

    setorigin (enemy, self.origin);
	setsize (enemy, '-16 -16 -24', '16 16 40');

	enemy.health = 80;
    enemy.angles = self.angles;

	enemy.th_stand = enf_stand1;
	enemy.th_walk = enf_walk1;
	enemy.th_run = enf_run1;
	enemy.th_pain = enf_pain;
	enemy.th_die = enf_die;
	enemy.th_missile = enf_atk1;
    enemy.think = walkmonster_start;
    enemy.nextthink = time + 0.1;
    
};

void() spawn_knight =
{
    local	entity enemy;

    enemy = spawn ();
	enemy.owner = self;

    enemy.solid = SOLID_SLIDEBOX;
	enemy.movetype = MOVETYPE_STEP;

	setmodel (enemy, "progs/knight.mdl");

    setorigin (enemy, self.origin);
	setsize (enemy, '-16 -16 -24', '16 16 40');
	enemy.health = 75;

	enemy.th_stand = knight_stand1;
	enemy.th_walk = knight_walk1;
	enemy.th_run = knight_run1;
	enemy.th_melee = knight_atk1;
	enemy.th_pain = knight_pain;
	enemy.th_die = knight_die;
    enemy.think = walkmonster_start;
    enemy.nextthink = time + 0.1;
};

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