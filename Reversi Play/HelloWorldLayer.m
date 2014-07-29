//
//  HelloWorldLayer.m
//  Reversi Play
//
//  Created by Jake Si on 2013-01-01.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "MainActivity.h"
#import "MainActivityAI.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        size = [[CCDirector sharedDirector] winSize];
        
        p1 = [CCSprite spriteWithFile:@"playerSymbol.png"];
        p1.position = CGPointMake(7*size.width/10, 5*size.height/9);
        [self addChild:p1];
        
        p2 = [CCSprite spriteWithFile:@"playerSymbol.png"];
        p2.position = CGPointMake(7*size.width/10, 4*size.height/9);
        [self addChild:p2];
        
        p3 = [CCSprite spriteWithFile:@"playerSymbol.png"];
        p3.position = CGPointMake(8*size.width/10, 4*size.height/9);
        [self addChild:p3];
        
		CCMenuItemImage *playButton = [CCMenuItemImage itemFromNormalImage:@"playGameButton.png" selectedImage:@"playGameButtonPressed.png" target: self selector: @selector(doThis:)];
		CCMenu *menu = [CCMenu menuWithItems:playButton, nil];
        [menu setPosition: CGPointMake(2*size.width/5, 4*size.height/9)];
        [self addChild:menu];
        
        CCMenuItemImage *playButtonAI = [CCMenuItemImage itemFromNormalImage:@"playGameButton.png" selectedImage:@"playGameButtonPressed.png" target: self selector: @selector(doThisAI:)];
		CCMenu *menuAI = [CCMenu menuWithItems:playButtonAI, nil];
        [menuAI setPosition: CGPointMake(2*size.width/5, 5*size.height/9)];
        [self addChild:menuAI];
        
        
	}
	return self;
}
-(void)doThis:(id)sender{
    [[CCDirector sharedDirector]replaceScene:[MainActivity node]];
}
-(void)doThisAI:(id)sender{
    [[CCDirector sharedDirector]replaceScene:[MainActivityAI node]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end

