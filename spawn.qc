void() spawner;
void() spawner_use;
void() spawner_think;

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
    if(self.flags == 3)
        e = spawn_demon();
    if(self.flags == 4)
        e = spawn_ogre();
    if(self.flags == 5)
        e = spawn_wizard();
    if(self.flags == 6)
        e = spawn_shambler();

    if(self.flags < 0 || self.flags > 6)
        error("Invalid spawn monster flag");

    // set general config
    setorigin (e, self.origin);
    e.think = walkmonster_start;
    e.nextthink = time + 0.1;

    play_teleport();
    particle(self.origin, '0 0 1', 0, 20);
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