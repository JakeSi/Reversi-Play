//
//  HelloWorldLayer.h
//  Reversi Play
//
//  Created by Jake Si on 2013-01-01.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer 
{
    CGSize size;
    CCSprite *p1;
    CCSprite *p2;
    CCSprite *p3;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
