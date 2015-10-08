//
//  MainActivityAI.m
//  Reversi Play
//
//  Created by Jake Si on 1/25/2014.
//
//

#import "MainActivityAI.h"

#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "CCTouchDispatcher.h"

static const NSInteger valueArray[8][8] = {99,3,16,14,14,16,3,99,
    3,0,6,7,7,6,0,3,
    16,6,15,12,12,15,6,16,
    14,7,12,5,5,12,7,14,
    14,7,12,5,5,12,7,14,
    16,6,15,12,12,15,6,16,
    3,0,6,7,7,6,0,3,
    99,3,16,14,14,16,3,99};

static float THINK_TIME=5000.0f;

@implementation MainActivityAI

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainActivityAI *layer = [MainActivityAI node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        size = [[CCDirector sharedDirector] winSize];
        
        //draw board
        board = [CCSprite spriteWithFile:@"board.png"];
        board.position = ccp(size.width/2,size.height-board.contentSize.height/2);
        [self addChild:board];
        
        
        
        //draw counters
        blackCounter = [CCSprite spriteWithFile:@"blackpiece.png"];
        blackCounter.position = ccp(size.width/6,size.height/4);
        [self addChild:blackCounter];
        
        whiteCounter = [CCSprite spriteWithFile:@"whitepiece.png"];
        whiteCounter.position = ccp(size.width - size.width/3,size.height/4);
        [self addChild:whiteCounter];
        
        //Draw Scores
        ScoreBlack = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",blackcount] fontName:@"ChalkDuster" fontSize:24];
        [self addChild: ScoreBlack];
        ScoreWhite = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",whitecount]  fontName:@"ChalkDuster" fontSize:24];
        [self addChild: ScoreWhite];
        [ScoreBlack setPosition: CGPointMake(size.width/6 + size.width/6, size.height/4)];
        [ScoreWhite setPosition: CGPointMake(size.width - size.width/3 + size.width/6 ,size.height/4)];
        [ScoreBlack setOpacity:85];
        [ScoreWhite setOpacity:85];
        
        //setting up the board
        whitePieces = [[NSMutableArray alloc] init];
        blackPieces = [[NSMutableArray alloc] init];
        for (NSInteger a=0; a<10; a++) {
            for (NSInteger b=0; b<10; b++) {
                pieceArray[a][b] = 0;
                
            }
        }
        pieceArray[5][5] = 1;
        pieceArray[4][4] = 1;
        pieceArray[5][4] = -1;
        pieceArray[4][5] = -1;
        CurrentPlayer = 1;
        [self drawPieces];
        [[[CCDirector sharedDirector] touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

-(void) drawPieces{
    for (NSInteger i = 1; i<=blackcount; i++){
        [self removeChildByTag:i cleanup:YES];
    }
    for (NSInteger i = 1; i<=whitecount; i++){
        [self removeChildByTag:i cleanup:YES];
    }
    for (NSInteger i = 1; i<=checkMoves; i++) {
        [self removeChildByTag:i cleanup:YES];
    }
    checkMoves = 0;
    blackcount = 0;
    whitecount = 0;
    for (NSInteger a = 1; a<=8; a++) {
        for (NSInteger b=1; b<=8; b++) {
            Boolean check =[self checkFlip:a ToColumn:b ToCurrentPlayer:CurrentPlayer];
            if (pieceArray[a][b] == 1 ) {
                blackcount++;
                black = [CCSprite spriteWithFile:@"blackpiece.png"];
                black.position = ccp(a*40-20,size.height-b*40+20);
                [self addChild: black z:0 tag:blackcount];
                [blackPieces addObject:black];
                
            }
            else if (pieceArray[a][b] == -1 ) {
                whitecount++;
                white = [CCSprite spriteWithFile:@"whitepiece1.png"];
                white.position = ccp(a*40-20,size.height-b*40+20);
                [self addChild: white z:0 tag:whitecount];
                [whitePieces addObject:white];
            }
            else if(pieceArray[a][b] == 0 && check == true){
                checkMoves++;
                if (CurrentPlayer == 1) {
                    checkPiece = [CCSprite spriteWithFile:@"blackdot.png"];
                }else{
                    checkPiece = [CCSprite spriteWithFile:@"dot.png"];
                }
                checkPiece.position = ccp(a*40-20,size.height-b*40+20);
                [self addChild: checkPiece z:0 tag:checkMoves];
                [whitePieces addObject:checkPiece];
                
            }
            
        };
    }
    if (checkMoves == 0) {
        CurrentPlayer = CurrentPlayer*-1;
        for (NSInteger a = 1; a<=8; a++) {
            for (NSInteger b=1; b<=8; b++) {
                Boolean check =[self checkFlip:a ToColumn:b ToCurrentPlayer:CurrentPlayer];
                if(pieceArray[a][b] == 0 && check == true){
                    checkMoves++;
                    if (CurrentPlayer == 1) {
                        checkPiece = [CCSprite spriteWithFile:@"blackdot.png"];
                    }else{
                        checkPiece = [CCSprite spriteWithFile:@"dot.png"];
                    }
                    checkPiece.position = ccp(a*40-20,size.height-b*40+20);
                    [self addChild: checkPiece z:0 tag:checkMoves];
                    [whitePieces addObject:checkPiece];
                    
                }
            }
        }
    }
    
    [ScoreBlack setString: [NSString stringWithFormat:@"%d",blackcount]];
    [ScoreWhite setString: [NSString stringWithFormat:@"%d",whitecount]];
    
    if ( blackcount + whitecount == 64 || ([self NumberOfMoves:1]== 0 && [self NumberOfMoves:-1]==0)){
        CCMenuItemImage *playButton = [CCMenuItemImage itemFromNormalImage:@"playGameButton.png" selectedImage:@"playGameButtonPressed.png" target: self selector: @selector(doThis:)];
        [playButton setPosition: CGPointMake(0, -2*size.height/5)];
        menu = [CCMenu menuWithItems:playButton, nil];
        [self addChild:menu];
        
        if (blackcount > whitecount){
            [ScoreBlack setString: [NSString stringWithFormat:@"%s","WIN"]];
            [ScoreWhite setString: [NSString stringWithFormat:@"%s","LOSE"]];
        }else{
            [ScoreWhite setString: [NSString stringWithFormat:@"%s","WIN"]];
            [ScoreBlack setString: [NSString stringWithFormat:@"%s","LOSE"]];
        }
    }
    
    
    
    
    
}
-(void)doThis:(id)sender{
    [[CCDirector sharedDirector]replaceScene:[HelloWorldLayer node]];
}

-(void) flipPiece:(NSInteger)iRow ToColumn:(NSInteger)iColumn ToCurrentPlayer:(NSInteger)CurrentPlayer{
    NSInteger RowChange = 0;
    NSInteger ColumnChange = 0;
    NSInteger FlipColor = 0;
    NSInteger DrawColor = 0;
    
    //Player1(black) = 1 Player2(white) = -1
    if (CurrentPlayer == 1){
        FlipColor = -1;
        DrawColor = 1;
    }else{
        FlipColor = 1;
        DrawColor = -1;
    }
    
    for (NSInteger direction = 1;direction<=8;direction++){
        switch (direction){
            case (1) :
                RowChange = 1;
                ColumnChange = 0;
                break;
            case(2) :
                RowChange = 0;
                ColumnChange = 1;
                break;
            case (3) :
                RowChange = -1;
                ColumnChange = 0;
                break;
            case (4) :
                RowChange = 0;
                ColumnChange = -1;
                break;
            case (5) :
                RowChange = 1;
                ColumnChange = 1;
                break;
            case (6) :
                RowChange = -1;
                ColumnChange = 1;
                break;
            case (7) :
                RowChange = 1;
                ColumnChange = -1;
                break;
            case (8) :
                RowChange = -1;
                ColumnChange = -1;
                break;
        }
        //check the next piece
        //check the next piece
        if(pieceArray[iRow+RowChange][iColumn+ColumnChange] == FlipColor){
            NSInteger count = 1;
            while(true){
                if (pieceArray[iRow + count * RowChange][ iColumn + count * ColumnChange] != DrawColor){
                    count = count + 1;
                }
                if (pieceArray[iRow + count * RowChange][iColumn + count * ColumnChange] != FlipColor){
                    break;
                }
            }
            //check if next square is white
            
            if (pieceArray [iRow + count * RowChange][iColumn + count * ColumnChange] == 0){
                count = 0;
            }
            
            //drawing the pieces and setting the color
            for (NSInteger i = 1;i<=count;i++){
                pieceArray [iRow + RowChange * i][iColumn + ColumnChange * i] = DrawColor;
            }
        }
        
    }
    
    
}

-(Boolean) checkFlip:(NSInteger)iRow ToColumn:(NSInteger)iColumn ToCurrentPlayer:(NSInteger)CurrentPlayer{
    NSInteger RowChange = 0;
    NSInteger ColumnChange = 0;
    NSInteger FlipColor = 0;
    NSInteger DrawColor = 0;
    
    Boolean legalMove = false;
    //Player1(black) = 1 Player2(white) = -1
    if (CurrentPlayer == 1){
        FlipColor = -1;
        DrawColor = 1;
    }else{
        FlipColor = 1;
        DrawColor = -1;
    }
    //the for loop checks each direction
    for (NSInteger direction = 1;direction<=8;direction++){
        switch (direction){
            case (1) :
                RowChange = 1;
                ColumnChange = 0;
                break;
            case(2) :
                RowChange = 0;
                ColumnChange = 1;
                break;
            case (3) :
                RowChange = -1;
                ColumnChange = 0;
                break;
            case (4) :
                RowChange = 0;
                ColumnChange = -1;
                break;
            case (5) :
                RowChange = 1;
                ColumnChange = 1;
                break;
            case (6) :
                RowChange = -1;
                ColumnChange = 1;
                break;
            case (7) :
                RowChange = 1;
                ColumnChange = -1;
                break;
            case (8) :
                RowChange = -1;
                ColumnChange = -1;
                break;
        }
        //check the next piece
        if(pieceArray[iRow+RowChange][iColumn+ColumnChange] == FlipColor){
            NSInteger count = 1;
            while(true){
                if (pieceArray[iRow + count * RowChange][iColumn + count * ColumnChange] != DrawColor){
                    count = count + 1;
                }
                if (pieceArray[iRow + count * RowChange][iColumn + count * ColumnChange] != FlipColor){
                    break;
                }
            }
            //check if next square is white
            
            if (pieceArray [iRow + count * RowChange][iColumn + count * ColumnChange] == 0){
                count = 0;
            }
            //drawing the pieces and setting the color
            if (count > 0){
                legalMove = true;
                break;
            }
            
        }
    }
    return legalMove;
}


-(NSInteger) checkAI:(NSInteger)iRow ToColumn:(NSInteger)iColumn {
    NSInteger RowChange = 0;
    NSInteger ColumnChange = 0;
    NSInteger FlipColor = 0;
    NSInteger DrawColor = 0;
    NSInteger piecesTaken = 0;
    
    //Player1(black) = 1 Player2(white) = -1
    if (CurrentPlayer == 1){
        FlipColor = -1;
        DrawColor = 1;
    }else{
        FlipColor = 1;
        DrawColor = -1;
    }
    //the for loop checks each direction
    for (NSInteger direction = 1;direction<=8;direction++){
        switch (direction){
            case (1) :
                RowChange = 1;
                ColumnChange = 0;
                break;
            case(2) :
                RowChange = 0;
                ColumnChange = 1;
                break;
            case (3) :
                RowChange = -1;
                ColumnChange = 0;
                break;
            case (4) :
                RowChange = 0;
                ColumnChange = -1;
                break;
            case (5) :
                RowChange = 1;
                ColumnChange = 1;
                break;
            case (6) :
                RowChange = -1;
                ColumnChange = 1;
                break;
            case (7) :
                RowChange = 1;
                ColumnChange = -1;
                break;
            case (8) :
                RowChange = -1;
                ColumnChange = -1;
                break;
        }
        //check the next piece
        if(pieceArray[iRow+RowChange][iColumn+ColumnChange] == FlipColor){
            NSInteger count = 1;
            while(true){
                if (pieceArray[iRow + count * RowChange][iColumn + count * ColumnChange] != DrawColor){
                    count = count + 1;
                }
                if (pieceArray[iRow + count * RowChange][iColumn + count * ColumnChange] != FlipColor){
                    break;
                }
            }
            //check if next square is white
            
            if (pieceArray [iRow + count * RowChange][iColumn + count * ColumnChange] == 0){
                count = 0;
            }
            //drawing the pieces and setting the color
            if (count > 0){
                piecesTaken += count;
            }
            
        }
    }
    return piecesTaken;
}
-(Boolean)isLegalMove:(NSInteger)boardX ToBoardY:(NSInteger)boardY ToCurrentPlayer:(NSInteger)CurrentPlayer{
    Boolean legalMove = false;
    
    if (pieceArray[boardX][boardY] == 0){
        legalMove = [self checkFlip:boardX ToColumn:boardY ToCurrentPlayer:CurrentPlayer];
    }
    return legalMove;
}

-(NSInteger)NumberOfMoves:(NSInteger)CurrentPlayer{
    NSInteger total = 0;
    //look for possible moves
    for (NSInteger i = 1; i<=8; i++) {
        for (NSInteger j= 1; j<=8; j++) {
            if (pieceArray[i][j] == 0){
                Boolean check = [self checkFlip:i ToColumn:j ToCurrentPlayer:CurrentPlayer];
                if (check == true) {
                    total+=1;
                }
            }
        }
    }
    return total;
}

-(void) pauseForThink:(ccTime) dt{
    _slipTime+=dt;
    if(_slipTime>THINK_TIME) {
        [self unschedule:@selector(pauseForThink:)];
    }
}

/* =========================================================
 TOUCH FUNCTIONS
 ===========================================================*/
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //PLAYER TURN
    CGPoint location = [touch locationInView: [touch view]];
    
    for (NSInteger i=1; i<=8; i++) {
        if (location.x >= (i-1)*40 && location.x <= (i)*40) {
            boardX = i;
        }
        if (location.y >= (i-1)*40 && location.y <= (i)*40){
            boardY = i;
        }
    }
    NSInteger moves = [self NumberOfMoves:CurrentPlayer];
    
    //checks if move is legal
    if ([self isLegalMove:boardX ToBoardY:boardY ToCurrentPlayer:CurrentPlayer] && moves > 0){
        pieceArray[boardX][boardY] = CurrentPlayer;
        [self flipPiece:boardX ToColumn:boardY ToCurrentPlayer:CurrentPlayer];
        //changing turns
        CurrentPlayer = CurrentPlayer*-1;
        [self drawPieces];
    }else if(checkMoves == 0) {
        CurrentPlayer = CurrentPlayer*-1;
        [self drawPieces];
        
    }
    
    if (CurrentPlayer == -1) {
        
        _slipTime=0.f;
        [self schedule:@selector(pauseForThink:)];
        //AI TURN
        NSInteger bestX,bestY, bestMove = -10;
        for (NSInteger i = 1; i<=8; i++) {
            for (NSInteger j= 1; j<=8; j++) {
                if (pieceArray[i][j] == 0){
                    NSInteger piecesTaken = [self checkAI:i ToColumn:j];
                    if (piecesTaken > 0) {
                        piecesTaken += valueArray[i-1][j-1];
                    }
                    if (piecesTaken > bestMove) {
                        bestMove = piecesTaken;
                        bestX = i;
                        bestY = j;
                    }
                }
            }
        }
        if (bestMove > -10) {
            pieceArray[bestX][bestY] = CurrentPlayer;
            [self flipPiece:bestX ToColumn:bestY ToCurrentPlayer:CurrentPlayer];
            //changing turns
            CurrentPlayer = CurrentPlayer*-1;
            
            [self drawPieces];
        }else if(bestMove == -10) {
            CurrentPlayer = CurrentPlayer*-1;
            [self drawPieces];
        }
        
    }
   
    
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

@end
