//
//  Ball.h
//  dodgeball
//
//  Created by Crystal Carbajal on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"


@interface Ball : Sprite {
	SPJuggler *juggler;
}

@property (retain) SPJuggler* juggler;

- (void)advanceTime:(double)seconds;

@end
