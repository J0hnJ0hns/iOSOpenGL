//
// GLGeometry.cpp
// GLGeometryLib
//
// Created by Sergei Iakovlev on 19.11.2024
// Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

#include "GLGeometry.hpp"
#include <iostream>
#include <stdexcept>
#include "GLDraw.hpp"


Geometry::Geometry(GLfloat * coordinates, GLint size) {
    //Triangulate
    try {
        triangulate(coordinates, size, triangles, trianglesCount);
    } catch (const std::invalid_argument& e) {
        std::cerr << "Geometry init failed. Invalid Argument Error: " << e.what() << std::endl;
    }
    
    //Init default rotation matrix
    for (int i = 0; i < 16; ++i) {
        if (i % 5 == 0) {
            rotationMatrix[i] = 1.0f;
        } else {
            rotationMatrix[i] = 0.0f;
        }
    }
}

Geometry::~Geometry() {
    delete [] triangles;
}

void Geometry::applyRotation(GLfloat degrees) {
    // Angle in radians
    float radians = -degrees * (M_PI / 180.0f); // Convert degrees to radians

    // Calculate the rotation matrix
    rotationMatrix[0] = cos(radians);
    rotationMatrix[1] = sin(radians);

    rotationMatrix[4] = -sin(radians);
    rotationMatrix[5] = cos(radians);
}

void Geometry::triangulate(GLfloat *vertice, GLint size, GLfloat*& triangles, GLint& trianglesSize) {
    if ((size % 2) != 0) {
        throw std::invalid_argument("The number of elements must be even");
    }
    
    if (size < 6) {
        throw std::invalid_argument("The number of elements must be greater or equal 6");
    }
    
    //if Triangle
    if (size == 6) {
        triangles = new GLfloat[6];
        
        for (int i = 0; i < size; i++) {
            triangles[i] = vertice[i];
        }
        trianglesSize = size;
        
        return;
    }

    //else
    int pointsCount = size / 2;
    int increasedSize = (pointsCount - 2) * 6;
    triangles = new GLfloat[increasedSize];
    
    int index = 0;
    for (int i = 1; i < pointsCount - 1; ++i) {
        triangles[index++] = vertice[0];
        triangles[index++] = vertice[1];
        
        triangles[index++] = vertice[i * 2];
        triangles[index++] = vertice[i * 2 + 1];
        
        triangles[index++] = vertice[(i + 1) * 2 ];
        triangles[index++] = vertice[(i + 1) * 2 + 1];
    }
    
    trianglesSize = increasedSize;
    
    return;
}

