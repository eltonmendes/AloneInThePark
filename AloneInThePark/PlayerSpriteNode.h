//
//  PlayerSpriteNode.h
//  AloneInThePark
//
//  Created by Elton Mendes on 19/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerSpriteNode : SKSpriteNode
@property (nonatomic,retain) SKAction *spriteWalkAnimation;
@property (nonatomic,retain) SKAction *spriteJumpAnimation;

- (void)removePlayerAnimation;

@end
