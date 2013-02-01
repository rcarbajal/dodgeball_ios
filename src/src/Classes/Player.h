//
//  Player.h
//  dodgeball
//
//  Created by Crystal Carbajal on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Sprite.h"


@interface Player : Sprite {
	int strength, agility, speed, accuracy;
}

@property (assign) int strength;
@property (assign) int agility;
@property (assign) int speed;
@property (assign) int accuracy;

@end
