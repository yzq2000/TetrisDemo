//
//  GameViewExt.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/16.
//

import UIKit

extension GameView {
    func couldMove(dirX: Int, dirY: Int) -> Bool {
        for block in currentBlock {
            // 超出左右边界
            if block.x + dirX >= columnCount || block.x + dirX < 0 {
                return false
            }
            // 超出上下边界
            if block.y + dirY >= rowCount || block.y + dirY < 0 {
                return false
            }
            // 旁边的block不为空
            if colorStatus[block.y + dirY][block.x + dirX] != NOBLOCK {
                return false
            }
        }
        return true
    }
    
    func moveOneStep(dirX: Int, dirY: Int) {
        drawAllBlocks()
        
        for block in currentBlock {
            CTX?.setFillColor(UIColor.white.cgColor)
            CTX?.fill(CGRect(x: CGFloat(block.x * blockWidth) + strokeWidth, y: CGFloat(block.y * blockWidth) + strokeWidth, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2))
        }
        
        for i in 0..<currentBlock.count {
            currentBlock[i].x += dirX
            currentBlock[i].y += dirY
        }
        
        for block in currentBlock {
            CTX?.setFillColor(block.color)
            CTX?.fill(CGRect(x: CGFloat(block.x * blockWidth) + strokeWidth, y: CGFloat(block.y * blockWidth) + strokeWidth, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2))
        }
    }
    
    func drawAllBlocks() {
        for row in 0..<rowCount {
            for col in 0..<columnCount {
                CTX?.setFillColor(colorStatus[row][col])
                CTX?.fill((CGRect(x: CGFloat(col * blockWidth) + strokeWidth, y: CGFloat(row * blockWidth) + strokeWidth, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2)))
            }
        }
    }
}
