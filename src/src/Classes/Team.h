//
//  Team.h
//  dodgeball
//
//  Created by Crystal Carbajal on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"


@interface Team : NSObject {

NSMutableArray *players;

}

@property (retain) NSMutableArray *players;

- (void)addPlayer:(Player *)player;

@end
