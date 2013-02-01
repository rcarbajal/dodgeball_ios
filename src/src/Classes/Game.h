//
//  Game.h
//  AppScaffold
//
//  Created by Daniel Sperl on 14.01.10.
//  Copyright 2010 Incognitek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"
#import "Team.h"
#import "GoodGuy.h"
#import "BadGuy.h"

@interface Game : SPStage
{
	SPSprite *stage;
	
	SPPoint *endTouchPoint;
	
	Ball *ball;
	SPSprite *throwAreaSprite;
	
	Team *goodGuys;
	Team *badGuys;
	
	Player *player;
	
	int curPlayerSpot;
	NSArray *randomPoints;
}

- (void)onTouch:(SPEvent *)event;
- (void)ballThrown:(SPEvent *)event;
- (SPPoint*)findBallTweenToPointWith:(SPPoint *)start and:(SPPoint *)end;
- (BOOL)doesBallCollide:(Ball *)b withPlayer:(Player *)p;
- (void)onEnterFrame:(SPEnterFrameEvent *)event;

@end
