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
    int pieceArray[10][10];
    int spaceheight;
    NSMutableArray *whitePieces;
    NSMutableArray *blackPieces;
    CCSprite *white;
    CCSprite *black;
    CCSprite *checkPiece;
    int boardX;
    int boardY;
    int CurrentPlayer;
    int blackcount;
    int whitecount;
    CCLabelTTF *ScoreBlack;
    CCLabelTTF *ScoreWhite;
    int checkMoves;
    CCMenu *menu;
}
+(CCScene *) scene;

@end

