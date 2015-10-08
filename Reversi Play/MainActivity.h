//
//  MainActivity.h
//  Reversi Play
//
//  Created by Jake Si on 2013-01-02.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainActivity : CCLayer {
    CGSize size;
    CCSprite *board;
    CCSprite *blackCounter;
    CCSprite *whiteCounter;
    NSInteger pieceArray[10][10];
    NSInteger spaceheight;
    NSMutableArray *whitePieces;
    NSMutableArray *blackPieces;
    CCSprite *white;
    CCSprite *black;
    CCSprite *checkPiece;
    NSInteger boardX;
    NSInteger boardY;
    NSInteger CurrentPlayer;
    NSInteger blackcount;
    NSInteger whitecount;
    CCLabelTTF *ScoreBlack;
    CCLabelTTF *ScoreWhite;
    NSInteger checkMoves;
    CCMenu *menu;
}
+(CCScene *) scene;

@end

