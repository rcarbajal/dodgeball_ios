//
//  Player.m
//  dodgeball
//
//  Created by Crystal Carbajal on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define SCALE_FACTOR 2

#import "Player.h"


@implementation Player

@synthesize strength, speed, agility, accuracy;

- (id)init {
	if(self = [super init]) {
		self.strength = 0;
		self.speed = 0;
		self.agility = 0;
		self.accuracy = 0;
		
		self.scaleX = SCALE_FACTOR;
		self.scaleY = SCALE_FACTOR;
	} //end if
	return self;
} //end method init

@end
