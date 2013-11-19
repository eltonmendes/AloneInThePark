//
//  BoxSpriteNode.m
//  AloneInThePark
//
//  Created by Elton Mendes on 19/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "BoxSpriteNode.h"

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
@end
