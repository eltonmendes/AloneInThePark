//
//  BoxSpriteNode.h
//  AloneInThePark
//
//  Created by Elton Mendes on 19/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BoxSpriteNode : SKSpriteNode

@property (nonatomic)BOOL isDamaged;
@property (nonatomic,retain) SKEmitterNode *particle;

-(void)removeCollision;

@end
