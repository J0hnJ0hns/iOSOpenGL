//
// GLView.swift
// GLAppExample
//
// Created by Sergei Iakovlev on 17.11.2024
// Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
import GLKit
import GLGeometryLib

class GLView: GLKView {
    
    private var glContext: EAGLContext?
    private var framebuffer: GLuint = 0
    private var renderbuffer: GLuint = 0
    
    private var geometry: IBTGeometry?
    
    public var rotation: GLfloat = 0 {
        didSet {
            geometry?.apply(rotation)
        }
    }
    
    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        setupContext()
        setupBuffers()
        setupGeometry()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContext()
        setupBuffers()
        setupGeometry()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContext()
        setupBuffers()
        setupGeometry()
    }
    
    func setupGeometry() {
        var points: [Float] = [
            0, 0.5,
            -0.8, 0.4,
            -0.5, -0.5,
            0.5, -0.5,
            0.5, 0.5,
            0.7, 0.7
        ]
        
        geometry = IBTGeometry(&points, count: Int32(points.count))
    }
    
    private func setupContext() {
        glContext = EAGLContext(api: .openGLES2)
        guard let context = glContext else {
            fatalError("Failed to create OpenGL ES context")
        }
        
        EAGLContext.setCurrent(context)
        
        let eaglLayer = layer as! CAEAGLLayer

        eaglLayer.isOpaque = false
        eaglLayer.backgroundColor = UIColor.clear.cgColor
        eaglLayer.drawableProperties = [
                kEAGLDrawablePropertyRetainedBacking: false,
                kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
            ]
    }
    
    private func setupBuffers() {
        glGenFramebuffers(1, &framebuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebuffer)
        
        glGenRenderbuffers(1, &renderbuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), renderbuffer)
        
        guard let context = glContext else { return }
        context.renderbufferStorage(Int(GL_RENDERBUFFER), from: layer as! CAEAGLLayer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), renderbuffer)
        
        let frameSize = boundsWithScaleFactor
        glViewport(0, 0, GLint(frameSize.width), GLint(frameSize.height))
        
        let error = glGetError()
        if error != GL_NO_ERROR {
            print("OpenGL Error: \(error)")
        }
    }
    
    private func reshapeFrameBuffer() {
        // Get the framebuffer size, accounting for the content scale factor
        let frameSize = boundsWithScaleFactor
        
        // Update the renderbuffer storage to the new size
        if let context = glContext {
            context.renderbufferStorage(Int(GL_RENDERBUFFER), from: layer as! CAEAGLLayer)
        }
        
        // Set the viewport based on the framebuffer size
        glViewport(0, 0, GLint(frameSize.width), GLint(frameSize.height))
        
        let error = glGetError()
        if error != GL_NO_ERROR {
            print("OpenGL Error: \(error)")
        }
    }
    
    private func drawGL() {
        // Set the background color (RGBA format)
        glClearColor(0, 0, 0, 0)
        
        // Clear the color buffer with the selected background color
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        // Draw
        geometry?.draw()
        
        let error = glGetError()
        if error != GL_NO_ERROR {
            print("OpenGL Error: \(error)")
        }
        
        // Present the render buffer to display the result
        glContext?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reshapeFrameBuffer()
        drawGL()
    }
    
    deinit {
        if framebuffer != 0 {
            glDeleteFramebuffers(1, &framebuffer)
        }
        if renderbuffer != 0 {
            glDeleteRenderbuffers(1, &renderbuffer)
        }
    }

}


extension GLView {
    
    var boundsWithScaleFactor: CGSize {
        let scaleFactor = self.contentScaleFactor
        return .init(width: self.bounds.width * scaleFactor, height: self.bounds.width * scaleFactor)
    }
    
}
