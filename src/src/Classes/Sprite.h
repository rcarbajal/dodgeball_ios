//
//  Sprite.h
//  dodgeball
//
//  Created by Crystal Carbajal on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Sprite : SPSprite {
	NSString *fileName;
}

@property (copy) NSString* fileName;
@end
