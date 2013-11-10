//
//  HelloWorldLayer.m
//  Coco2DSimpleGame
//
//  Created by Franco Arolfo on 9/9/13.
//  Copyright Franco Arolfo 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// Audio from cocos
#import "SimpleAudioEngine.h"

#import "GameOverLayer.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

CCLabelTTF * lifesLabel;
CCLabelTTF * scoreLabel;
CCLabelTTF * cheatModeLabel;
CCLabelTTF * levelLabel;
CCLabelTTF * comboLabel;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) sceneFromLevel: (int) level
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [[HelloWorldLayer alloc] initWithLevel: level];
    
    layer.touchEnabled= YES;
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) setBackgroundByLevel
{
    CGSize size = [[CCDirector sharedDirector] winSize];

    CCSprite * background = [CCSprite spriteWithFile:@"level1.jpg"];
    background.position = ccp(size.width/2, size.height/2);
    
    [self addChild:background z: -100];
}

- (void) setScore:(int)score
{
    _score = score;
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %d", _score]];
}

-(void) updateLifesTo: (int) lifes
{
    _lifes = lifes;
    [lifesLabel setString:[NSString stringWithFormat:@"Lifes: %d", _lifes]];
}

-(void) updateComboTo: (int) combo
{
    _combo = combo;
    [comboLabel setString:[NSString stringWithFormat:@"Combo: +%d", _combo]];}

- (id) initWithLevel: (int) level
{
    if ((self = [super init])) {
         _lifes = 5;
        self.score = 0;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        lifesLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Lifes: %d", _lifes] fontName:@"Arial" fontSize:10];
        lifesLabel.color = ccc3(0,0,0);
        lifesLabel.position = ccp(winSize.width - 90, winSize.height - lifesLabel.contentSize.height/2 - 3);
        [self addChild:lifesLabel];
        
        CCSprite *player = [CCSprite spriteWithFile:@"player.png"];
        player.position = ccp(player.contentSize.width/2, winSize.height/2);
        [self addChild:player];
        
        _cheatMode = true;
        
        cheatModeLabel = [CCLabelTTF labelWithString:@"Cheat: ON" fontName:@"Arial" fontSize:10];
        cheatModeLabel.color = ccc3(0,0,0);
        cheatModeLabel.position = ccp(40, winSize.height - cheatModeLabel.contentSize.height/2 - 3);
        [self addChild:cheatModeLabel];
        
        _level = level;
        
        levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %d", _level] fontName:@"Arial" fontSize:10];
        levelLabel.color = ccc3(0,0,0);
        levelLabel.position = ccp(140, winSize.height - levelLabel.contentSize.height/2 - 3);
        [self addChild:levelLabel];
        
        _combo = 1;
        
        comboLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Combo: +%d", _combo] fontName:@"Arial" fontSize:10];
        comboLabel.color = ccc3(0,0,0);
        comboLabel.position = ccp(240, winSize.height - comboLabel.contentSize.height/2 - 3);
        [self addChild:comboLabel];
        
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d", self.score] fontName:@"Arial" fontSize:10];
        scoreLabel.color = ccc3(0,0,0);
        scoreLabel.position = ccp(winSize.width - 30, winSize.height - scoreLabel.contentSize.height/2 - 3);
        [self addChild:scoreLabel];
        
        [self schedule:@selector(gameLogic:) interval:1.0];
        [self schedule:@selector(update:)];
        
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        _lifeNodes = [[NSMutableArray alloc] init];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        
        [self setBackgroundByLevel];
    }
    
    return self;
}

-(void)gameLogic:(ccTime)dt {
    [self addMonster];
    if ( arc4random() % 100 > 95  ) {
        [self addLife];
    }
}

- (void) addLife
{
    CCSprite * newLife = [CCSprite spriteWithFile:@"heart-icon.png"];
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = newLife.contentSize.height / 2;
    int maxY = winSize.height - newLife.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    newLife.position = ccp(winSize.width + newLife.contentSize.width/2, actualY);
    
    CCRotateBy * rotate = [CCRotateBy actionWithDuration:4.0 angle:360];
    [newLife runAction:[CCRepeatForever actionWithAction:rotate]];
    
    [self addChild:newLife];//here
    
    // Determine speed of the monster
    int minDuration = 5.0;
    int maxDuration = 6.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration; //TODO this is not working !
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:6.0
                                                position:ccp(-newLife.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        
        [_lifeNodes removeObject:node];
    }];
    [newLife runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    [_lifeNodes addObject: newLife];
    newLife.tag = 1;
    
    return;
}

- (CCSprite *) createSimpleMonster {
    CCSprite * monster = [CCSprite spriteWithFile:@"monster.png"];
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    
    CCRotateBy * rotateLeft = [CCRotateBy actionWithDuration:0.5 angle:7.5];
    CCRotateBy * rotateRight = [CCRotateBy actionWithDuration:0.5 angle:-15];
    CCSequence * pulseSequence = [CCSequence actionOne:rotateLeft two:rotateRight];
    [monster runAction:[CCRepeatForever actionWithAction:pulseSequence]];
    
    [self addChild:monster];//here
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        
        if ( ! _cheatMode ){
            _lifes--;
            _combo = 1;
        }
        
        [self updateComboTo: _combo];
        [self updateLifesTo:_lifes];
        
        if ( _lifes == 0 ) {
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO inLevel:_level];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        
        // CCCallBlockN in addMonster
        [_monsters removeObject:node];
        
        // CCCallBlockN in ccTouchesEnded
        [_projectiles removeObject:node];
    }];
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    monster.tag = 1;

    return monster;
}

- (CCSprite *) createMediumMonster {
    
    CCSprite * monster;
    CCAction * walkAction;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animMediumMonster.plist"];

    CCSpriteBatchNode * spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"animMediumMonster.png"];
    
    [self addChild:spriteSheet];
  
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for (int i=1; i<=3; i++) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"monsterMediumSprite%d.png",i]]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    monster = [CCSprite spriteWithSpriteFrameName:@"monsterMediumSprite1.png"];

    walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim]];
    
    // Determine where to spawn the monster along the Y axis
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    
    [monster runAction:walkAction];
    [spriteSheet addChild:monster];
        
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        
        if ( ! _cheatMode ) {
            _lifes--;
            _combo = 1;
        }
        
        [self updateComboTo: _combo];
        [self updateLifesTo: _lifes];
        
        if ( _lifes == 0 ) {
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO inLevel:_level];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        
        // CCCallBlockN in addMonster
        [_monsters removeObject:node];
        
        // CCCallBlockN in ccTouchesEnded
        [_projectiles removeObject:node];
    }];
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    monster.tag = 1;
    
    return monster;
}

- (void) addMonster {
    CCSprite * monster;
    int rand = arc4random() % 100;
    if ( rand < 90 ) {
        monster = [self createSimpleMonster];
    } else {
        monster = [self createMediumMonster];
    }
   
    [_monsters addObject:monster];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    _monsters = nil;
    _lifeNodes = nil;
    _projectiles = nil;
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

- (Boolean) isCheatModeLocation: (CGPoint) location
{
    //TODO: FIX BUG HERE -> 
    return location.x <= [cheatModeLabel position].x * 2 && location.y <= [cheatModeLabel position].y;
}

- (void) toggleCheatMode
{
    if ( _cheatMode ){
        _cheatMode = false;
    } else {
        _cheatMode = true;
    }
    [cheatModeLabel setString:(_cheatMode ? @"Cheat: ON" : @"Cheat: OFF")];
    return;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];

    if ( [self isCheatModeLocation: location] ) {
        [self toggleCheatMode];
        return;
    }
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite * projectile = [CCSprite spriteWithFile:@"projectile.png"];
    projectile.position = ccp(20, winSize.height/2);
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, projectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [node removeFromParentAndCleanup:YES];
         // CCCallBlockN in addMonster
         [_monsters removeObject:node];
         
         // CCCallBlockN in ccTouchesEnded
         [_projectiles removeObject:node];
     }],
      nil]];
    
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
}

- (NSMutableArray *) analizeMonstersToDeleteWithProjectile: (CCSprite *) projectile
{
    NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
    
    for (CCSprite *monster in _monsters) {
        if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
            [monstersToDelete addObject:monster];
        }
    }
    
    for (CCSprite *monster in monstersToDelete) {
        self.score = self.score + _combo;
        _combo++;
        [self updateComboTo: _combo];
        [_monsters removeObject:monster];
        [self removeChild:monster cleanup:YES];
        _monstersDestroyed++;
        if (_score > 100) {
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES inLevel:_level];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
    }
    
    return monstersToDelete;
}

- (NSMutableArray *) analizeLifesToDeleteWithProjectile: (CCSprite *) projectile
{
    NSMutableArray * lifesToDelete = [[NSMutableArray alloc] init];
    
    for (CCSprite * life in _lifeNodes) {
        if (CGRectIntersectsRect(projectile.boundingBox, life.boundingBox)) {
            [lifesToDelete addObject:life];
        }
    }
    
    for (CCSprite * life in lifesToDelete) {
        [self updateLifesTo: ++_lifes];
        [_lifeNodes removeObject:life];
        [self removeChild:life cleanup:YES];
    }
    
    return lifesToDelete;
}

- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        NSMutableArray * monstersToDelete = [self analizeMonstersToDeleteWithProjectile: projectile];
        NSMutableArray * lifesToDelete = [self analizeLifesToDeleteWithProjectile: projectile];
        
        if (monstersToDelete.count > 0 || lifesToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
}
@end
