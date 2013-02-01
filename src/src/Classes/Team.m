//
//  Team.m
//  dodgeball
//
//  Created by Crystal Carbajal on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define MAX_TEAM_MEMBER_COUNT 6

#import "Team.h"


@implementation Team

@synthesize players;

- (id)init {
	if(self = [super init]) {
		self.players = [NSMutableArray arrayWithCapacity:MAX_TEAM_MEMBER_COUNT];
	} //end if
	
	return self;
} //end method init

- (void)addPlayer:(Player*) player {
	int i = 0;
	while(TRUE) {
		if(i < MAX_TEAM_MEMBER_COUNT && [self.players count] == i) {
			[self.players addObject:player];
			break;
		} //end if
		++i;
	} //end while
} //end method addPlayer

- (void) dealloc {
	[super dealloc];
} //end method dealloc

@end
