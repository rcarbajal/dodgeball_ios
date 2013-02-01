//
//  Game.m
//  AppScaffold
//
//  Created by Daniel Sperl on 14.01.10.
//  Copyright 2010 Incognitek. All rights reserved.
//

#define SCREEN_WIDTH 1024
#define SCREEN_HEIGHT 768

#import "Game.h"

@implementation Game

- (id)initWithWidth:(float)width height:(float)height
{
    if (self = [super initWithWidth:width height:height]) {
		stage = [[SPSprite alloc] init]; //create landscape "stage" to which all objects will be added
		stage.rotation = SP_D2R(90); //rotate clockwise 90 degrees
		stage.x = 768; //move right 768px
		[self addChild:stage]; //add landscape stage to overall view
		[stage release];
		
		curPlayerSpot = 0;
		randomPoints = [[NSArray arrayWithObjects: 
			[SPPoint pointWithX:600 y:100],
			[SPPoint pointWithX:900 y:200],
			[SPPoint pointWithX:550 y:350],
			[SPPoint pointWithX:600 y:700],
			[SPPoint pointWithX:700 y:500], nil] retain];
		
		//add background
		SPImage *bgImg = [SPImage imageWithContentsOfFile:@"tutorialbackground.png"];
		[stage addChild:bgImg];
		
		//create throw area image
		SPImage *throwAreaImg = [SPImage imageWithContentsOfFile:@"throw_box.png"];
		throwAreaImg.y = -throwAreaImg.height / 2;
		throwAreaSprite = [[SPSprite sprite] retain];
		[throwAreaSprite addChild:throwAreaImg];
		
		//add ball image to stage
		ball = [[[Ball alloc] init] retain];
		ball.x = 200;
		ball.y = 200;
		[stage addChild:ball];
		
		//add touch event listener for ball
		[ball addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
		
		//add player to stage
		player = [[[BadGuy alloc] init] retain];
		player.x = ((SPPoint*)[randomPoints objectAtIndex:curPlayerSpot]).x;
		player.y = ((SPPoint*)[randomPoints objectAtIndex:curPlayerSpot]).y;
		[stage addChild:player];
		curPlayerSpot += 1;
		
		//create good guys
		goodGuys = [[[Team alloc] init] retain];
		GoodGuy *gg;
		for(int i = 0; i < 6; ++i) {
			gg = [[GoodGuy alloc] init];
			gg.x = (arc4random() % 400) + 50;
			gg.y = (arc4random() % 600) + 50;
			[goodGuys addPlayer:gg];
			gg = nil;
			[gg release];
		} //end for
		
		//add good guys to stage
		for(int i = 0; i < [goodGuys.players count]; ++i)
			[stage addChild:[goodGuys.players objectAtIndex:i]];
		
		//create bad guys
		badGuys = [[[Team alloc] init] retain];
		BadGuy *bg;
		for(int i = 0; i < 6; ++i) {
			bg = [[BadGuy alloc] init];
			bg.x = (arc4random() % 400) + 600;
			bg.y = (arc4random() % 600) + 50;
			[badGuys addPlayer:bg];
			bg = nil;
			[bg release];
		} //end for
		
		//add bad guys to stage
		for(int i = 0; i < [badGuys.players count]; ++i)
			[stage addChild:[badGuys.players objectAtIndex:i]];
		
		endTouchPoint = nil;
		
		[stage addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    } //end if
    return self;
} //end method initWithWidth

- (void)onTouch:(SPTouchEvent*)event {
	NSArray *moveTouches = [[event touchesWithTarget:stage andPhase:SPTouchPhaseMoved] allObjects];
	if(moveTouches.count == 1) {
		//here is where we write the direction arrow drawing code		
		endTouchPoint = [[moveTouches objectAtIndex:0] locationInSpace:stage];
		
		if(throwAreaSprite.parent == nil) {
			throwAreaSprite.x = ball.x;
			throwAreaSprite.y = ball.y;
			[stage addChild:throwAreaSprite];
		} //end if
		
		//rotate throw area image towards finger
		throwAreaSprite.rotation = atan2(endTouchPoint.y - throwAreaSprite.y, endTouchPoint.x - throwAreaSprite.x);
	} //end if
		
	NSArray *endTouches = [[event touchesWithTarget:stage andPhase:SPTouchPhaseEnded] allObjects];
	if(endTouches.count == 1) {
		//here is where we write the direction arrow drawing code		
		endTouchPoint = [[endTouches objectAtIndex:0] locationInSpace:stage];
		
		//remove throw area image
		[stage removeChild:throwAreaSprite];
		
		//throw the ball
		SPTween *throwBall = [SPTween tweenWithTarget:ball time:1 transition:SP_TRANSITION_LINEAR];
		SPPoint *ballEnd = [self findBallTweenToPointWith:[SPPoint pointWithX:ball.x y:ball.y] and:endTouchPoint];
		[throwBall animateProperty:@"x" targetValue:ballEnd.x];
		[throwBall animateProperty:@"y" targetValue:ballEnd.y];
		[ball.juggler addObject:throwBall];
		[throwBall addEventListener:@selector(ballThrown:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
	} //end if
} //end method onTouch

- (void)onEnterFrame:(SPEnterFrameEvent*)event {
	if([self doesBallCollide:ball withPlayer:player]) {
		//stop the ball tween and reset the position
		[ball.juggler removeAllObjects];
		ball.x = 200;
		ball.y = 200;
	
		//move the player to a new spot
		player.x = ((SPPoint*)[randomPoints objectAtIndex:curPlayerSpot]).x;
		player.y = ((SPPoint*)[randomPoints objectAtIndex:curPlayerSpot]).y;
		
		//increment the random spot index
		if(curPlayerSpot < 4)
			curPlayerSpot += 1;
		else curPlayerSpot = 0;
	} //end if
	else {
		[ball advanceTime:event.passedTime];
	} //end else
} //end method onEnterFrame

- (void)ballThrown:(SPEvent*)event {
	//SPTween *animation = (SPTween*)[event target]; //get the SPTween object that raised the event
	//[self.juggler removeObject:animation]; //remove the tween from the juggler
	
	//move the ball back to start
	ball.x = 200;
	ball.y = 200;
} //end method ballThrown

- (SPPoint*)findBallTweenToPointWith:(SPPoint*)start and:(SPPoint*)end {
	float x = 0, y = 0;

	//find slope between two points
	float m = (start.y - end.y) / (start.x - end.x);
	
	if(m >= 0) { //if slope is positive, we're either pointed at quadrant I or III
		if(end.x >= start.x && end.y >= start.y) { //quadrant I
			//first try to find y when x = SCREEN_WIDTH
			y = start.y + (m * (SCREEN_WIDTH - start.x));
			if(y <= SCREEN_HEIGHT)
				return [SPPoint pointWithX:SCREEN_WIDTH y:y];
			else {
				//otherwise, find x when y = SCREEN_HEIGHT
				x = ((SCREEN_HEIGHT - start.y) / m) + start.x;
				return [SPPoint pointWithX:x y:SCREEN_HEIGHT];
			} //end else
		} //end if
		else { //quadrant III
			//first try to find y when x = 0
			y = start.y + (m * -start.x);
			if(y >= 0)
				return [SPPoint pointWithX:0 y:y];
			else {
				//otherwise, find x when y = 0
				x = (-start.y / m) + start.x;
				return [SPPoint pointWithX:x y:0];
			} //end else
		} //end else
	} //end if
	else { //slope is negative so we're pointed at either quadrant II or IV
		if(end.x > start.x && end.y < start.y) { //quadrant II
			//first try to find y when x = SCREEN_WIDTH
			y = start.y + (m * (SCREEN_WIDTH - start.x));
			if(y >= 0)
				return [SPPoint pointWithX:SCREEN_WIDTH y:y];
			else {
				//otherwise, find x when y = 0
				x = (-start.y / m) + start.x;
				return [SPPoint pointWithX:x y:0];
			} //end else
		} //end if
		else { //quadrant IV
			//first try to find y when x = 0
			y = start.y + (m * -start.x);
			if(y <= SCREEN_HEIGHT)
				return [SPPoint pointWithX:0 y:y];
			else {
				//otherwise, find x when y = SCREEN_HEIGHT
				x = ((SCREEN_HEIGHT - start.y) / m) + start.x;
				return [SPPoint pointWithX:x y:SCREEN_HEIGHT];
			} //end else
		} //end else
	} //end else
		
	return [SPPoint pointWithX:0 y:0];
} //end method findBallTweenToPoint

- (BOOL)doesBallCollide:(Ball*)b withPlayer:(Player*)p {
	float testX = b.x;
	float testY = b.y;
	float r = b.width / 2;
	SPRectangle *playerBounds = p.bounds;
	
	if(testX < playerBounds.x) testX = playerBounds.x;
	else if(testX > playerBounds.x + p.width) testX = playerBounds.x + p.width;
	
	if(testY < playerBounds.y) testY = playerBounds.y;
	else if(testY > playerBounds.y + p.height) testY = playerBounds.y + p.height;
	
	return ((b.x - testX) * (b.x - testX) + (b.y - testY) * (b.y - testY)) < r * r;
} //end method doesBallCollide

- (void)dealloc {
	[ball release];
	[player release];
	[goodGuys release];
	[badGuys release];
	[throwAreaSprite release];
	[randomPoints release];
	[super dealloc];
} //end method dealloc
@end
