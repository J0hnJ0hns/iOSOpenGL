//
// GLGeometryBridge.m
// GLGeometryLib
//
// Created by Sergei Iakovlev on 17.11.2024
// Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GLDraw.hpp"
#import "GLGeometryBridge.h"


@interface IBTGeometry ()

@property (nonatomic, nonnull) Geometry *geometry;

@end


@implementation IBTGeometry: NSObject

- (instancetype)init:(float *)points count:(int)count {
    if (self = [super init]) {
        _geometry = new Geometry(points, count);
    }
    
    return self;
}

- (void)apply:(float)rotation {
    _geometry->applyRotation(rotation);
}

- (void)draw {
    drawGeometry(_geometry);
}

-(void)dealloc {
    delete _geometry;
}

@end
