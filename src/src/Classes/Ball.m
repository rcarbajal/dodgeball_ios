//
//  Ball.m
//  dodgeball
//
//  Created by Crystal Carbajal on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"


@implementation Ball

@synthesize juggler;

- (id)init {
	self.fileName = @"soccer_ball.png";
	if(self = [super init])
		juggler = [[SPJuggler alloc] init];
	return self;
} //end method init

- (void)advanceTime:(double)seconds {
	[juggler advanceTime:seconds];
} //end method advanceTime

- (void)dealloc {
	[juggler release];
	[super dealloc];
} //end method dealloc

@end
