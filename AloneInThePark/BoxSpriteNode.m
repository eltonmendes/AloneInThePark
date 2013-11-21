//
//  BoxSpriteNode.m
//  AloneInThePark
//
//  Created by Elton Mendes on 19/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "BoxSpriteNode.h"
static const uint32_t uncategory         =  0x1 << 0;

@implementation BoxSpriteNode



-(id)initWithImageNamed:(NSString *)name{
    self = [super initWithImageNamed:name];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
    self.physicsBody.dynamic = YES;
    [self.physicsBody setAffectedByGravity:YES];
    self.physicsBody.mass = 1;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    
    return self;
}

-(void)removeCollision{
    self.physicsBody.categoryBitMask = uncategory;
    self.physicsBody.collisionBitMask = uncategory;
    self.physicsBody.contactTestBitMask = uncategory;
}
@end
