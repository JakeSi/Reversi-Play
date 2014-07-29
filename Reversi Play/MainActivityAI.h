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
    float _slipTime;
    //set valueArray for AI
    
}
+(CCScene *) scene;


@end
