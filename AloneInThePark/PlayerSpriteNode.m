//
//  PlayerSpriteNode.m
//  AloneInThePark
//
//  Created by Elton Mendes on 19/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "PlayerSpriteNode.h"

@implementation PlayerSpriteNode


-(id)initWithTexture:(SKTexture *)texture{
    self = [super initWithTexture:texture];
    self.position = CGPointMake(80,220);
    [self setScale:0.4];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(35, 45)];
    self.physicsBody.dynamic = YES;
    self.physicsBody.mass = 1000;
    
    return self;
}
- (SKAction*)spriteWalkAnimation{
    NSMutableArray *texturesArray = [[NSMutableArray alloc]init];
    
    for(int i =1;i<6;i++){
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"player%i.png",i]];
        [texturesArray addObject:texture];
    }
    return [SKAction animateWithTextures:texturesArray timePerFrame:0.1 resize:NO restore:YES];
}

- (SKAction*)spriteJumpAnimation{
    NSMutableArray *texturesArray = [[NSMutableArray alloc]init];
    
    for(int i =1;i<6;i++){
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"jump_0%i.png",i]];
        [texturesArray addObject:texture];
    }
    return [SKAction animateWithTextures:texturesArray timePerFrame:0.1 resize:NO restore:YES];
}

@end
