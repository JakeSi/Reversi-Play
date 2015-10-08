//
//  MainActivityAI.h
//  Reversi Play
//
//  Created by Jake Si on 1/25/2014.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainActivityAI : CCLayer {
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
    float _slipTime;
    //set valueArray for AI
    
}
+(CCScene *) scene;


@end
