//
//  Emitter.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/21/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class Emitter {
    
    var superView: UIView
    var emitter = CAEmitterLayer()
    
    init(superView: UIView) {
        self.superView = superView
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        self.superView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let point = sender.translation(in: self.superView)
            self.createLayer(point: point, parentView: self.superView)
        case .changed:
            let point = sender.location(in: self.superView)
            self.changePosition(point: point)
        default:
            self.emitter.removeFromSuperlayer();
        }
    }
    
    func createLayer(point: CGPoint, parentView: UIView) {
        let sizeLayer = CGSize(width: 50, height: 50)
        let rect = CGRect(x: point.x, y: point.y, width: sizeLayer.width, height: sizeLayer.height)
        emitter.frame = rect
        parentView.layer.addSublayer(emitter)
        emitter.emitterShape = kCAEmitterLayerPoints
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "ic_tinkoff")?.cgImage
        emitterCell.birthRate = 100
        emitterCell.lifetime = 1.5
        emitterCell.lifetimeRange = 1
        emitterCell.yAcceleration = 60.0
        emitterCell.xAcceleration = -10
        emitterCell.velocity = 150
        emitterCell.velocityRange = 200
        emitterCell.emissionLongitude = -.pi * 0.5
        emitterCell.emissionRange = .pi * 1
        emitterCell.redRange = 0.3
        emitterCell.greenRange = 0.3
        emitterCell.blueRange = 0.3
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8
        emitterCell.scaleSpeed = -0.15
        emitterCell.alphaRange = 0.7
        emitterCell.alphaSpeed = -0.15
        
        emitter.emitterCells = [emitterCell]
    }
    
    func changePosition(point: CGPoint) {
        emitter.emitterPosition = point
    }
}
