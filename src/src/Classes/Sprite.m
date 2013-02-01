//
//  Sprite.m
//  dodgeball
//
//  Created by Crystal Carbajal on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sprite.h"


@implementation Sprite

@synthesize fileName;

- (id)init {
	if(self = [super init]) {
		if([self.fileName length] > 0) {
			SPImage *img = [SPImage imageWithContentsOfFile:self.fileName];
			img.x = -img.width / 2;
			img.y = -img.height / 2;
			[self addChild:img];
		} //end if
	} //end if
	
	return self;
} //end method init

- (void)dealloc {
	[self.fileName release];
	[super dealloc];
} //end method dealloc

@end
