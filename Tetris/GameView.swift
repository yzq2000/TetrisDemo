//
//  GameView.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/15.
//

import UIKit
import Foundation

protocol GameDelegate: AnyObject {
    func updateScore(score: Int)
    func updateSpeed(speed: Int)
    func updateGameState()
}

struct TetrisBlock {
    var x: Int
    var y: Int
    var color: CGColor
    var debug: String {
        return"Block x = \(x), y = \(y)"
    }
}

let columnCount = 15
let rowCount = 24
let blockArray: [[TetrisBlock]] = [
    [   // Z
        TetrisBlock(x: columnCount / 2 - 1, y: 0, color: UIColor.red.cgColor),
        TetrisBlock(x: columnCount / 2, y: 0, color: UIColor.red.cgColor),
        TetrisBlock(x: columnCount / 2, y: 1, color: UIColor.red.cgColor),
        TetrisBlock(x: columnCount / 2 + 1, y: 1, color: UIColor.red.cgColor)
        
    ],
    [   // 反Z
        TetrisBlock(x: columnCount / 2 + 1, y: 0, color: UIColor.yellow.cgColor),
        TetrisBlock(x: columnCount / 2, y: 0, color: UIColor.yellow.cgColor),
        TetrisBlock(x: columnCount / 2, y: 1, color: UIColor.yellow.cgColor),
        TetrisBlock(x: columnCount / 2 - 1, y: 1, color: UIColor.yellow.cgColor)
    ],
    [   // 田
        TetrisBlock(x: columnCount / 2 - 1, y: 0, color: UIColor.green.cgColor),
        TetrisBlock(x: columnCount / 2, y: 0, color: UIColor.green.cgColor),
        TetrisBlock(x: columnCount / 2 - 1, y: 1, color: UIColor.green.cgColor),
        TetrisBlock(x: columnCount / 2, y: 1, color: UIColor.green.cgColor)
        
    ],
    [   // L
        TetrisBlock(x: columnCount / 2 - 1, y: 0, color: UIColor.blue.cgColor),
        TetrisBlock(x: columnCount / 2 - 1, y: 1, color: UIColor.blue.cgColor),
        TetrisBlock(x: columnCount / 2 - 1, y: 2, color: UIColor.blue.cgColor),
        TetrisBlock(x: columnCount / 2, y: 2, color: UIColor.blue.cgColor)
    ],
    [   // J
        TetrisBlock(x: columnCount / 2, y: 0, color: UIColor.orange.cgColor),
        TetrisBlock(x: columnCount / 2, y: 1, color: UIColor.orange.cgColor),
        TetrisBlock(x: columnCount / 2, y: 2, color: UIColor.orange.cgColor),
        TetrisBlock(x: columnCount / 2 - 1, y: 2, color: UIColor.orange.cgColor)
        
    ],
    [   // 一
        TetrisBlock(x: columnCount / 2, y: 0, color: UIColor.purple.cgColor),
        TetrisBlock(x: columnCount / 2, y: 1, color: UIColor.purple.cgColor),
        TetrisBlock(x: columnCount / 2, y: 2, color: UIColor.purple.cgColor),
        TetrisBlock(x: columnCount / 2, y: 3, color: UIColor.purple.cgColor)
    ],
    [   // 十缺个角
        TetrisBlock(x: columnCount / 2, y: 0, color: UIColor.systemPink.cgColor),
        TetrisBlock(x: columnCount / 2 - 1, y: 1, color: UIColor.systemPink.cgColor),
        TetrisBlock(x: columnCount / 2, y: 1, color: UIColor.systemPink.cgColor),
        TetrisBlock(x: columnCount / 2 + 1, y: 1, color: UIColor.systemPink.cgColor)
    ]
]

class GameView: UIView{
    let NOBLOCK = UIColor.white.cgColor
    let blockWidth: Int
    
    let strokeWidth: CGFloat = 1
    var CTX = UIGraphicsGetCurrentContext()
    
    let baseSpeed = 1.0
    var currentSpeed: Int = 0
    
    var currentScore: Int = 0
    
    var nextBlockID: Int = Int(arc4random()) % blockArray.count
    
    var currentBlock = [TetrisBlock]()
    
    var colorStatus = [[CGColor]]()
    
    var image: UIImage?
    
    var currentTimer: Timer?
    
    var isPausing: Bool = false
    
    weak var delegate: GameDelegate? = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        self.blockWidth = Int(frame.width - 100) / columnCount
        super.init(frame: frame)
        
        UIGraphicsBeginImageContext(self.bounds.size)
        
        CTX = UIGraphicsGetCurrentContext()
        
        CTX?.setFillColor(UIColor.white.cgColor)
        CTX?.fill(self.bounds)
        
        createGrid()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func createGrid() {
        CTX?.beginPath()
        for row in 0...rowCount {
            CTX?.move(to: CGPoint(x: 0, y: row * blockWidth))
            CTX?.addLine(to: CGPoint(x: columnCount * blockWidth, y: row * blockWidth))
        }
        for col in 0...columnCount {
            CTX?.move(to: CGPoint(x: col * blockWidth, y: 0))
            CTX?.addLine(to: CGPoint(x: col * blockWidth, y: rowCount * blockWidth))
        }
        CTX?.closePath()
        CTX?.setStrokeColor(UIColor.lightGray.cgColor)
        CTX?.setLineWidth(strokeWidth)
        CTX?.strokePath()
    }
    
    override func draw(_ rect: CGRect) {
        UIGraphicsGetCurrentContext()
        image?.draw(at: CGPoint.zero)
    }
    
    func initBlock() {
        currentBlock = blockArray[nextBlockID]
        nextBlockID = Int(arc4random()) % blockArray.count
        
        let nextBlock = blockArray[nextBlockID]
        
        CTX?.setFillColor(UIColor.white.cgColor)
        CTX?.fill(CGRect(x: 270, y: 180, width: 70, height: 70))
        for block in nextBlock {
            CTX?.setFillColor(block.color)
            CTX?.fill(CGRect(x: CGFloat(block.x * blockWidth) + strokeWidth + 180, y: CGFloat(block.y * blockWidth) + strokeWidth + 180, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2))
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        setNeedsDisplay()
    }
    
    func initColorStatus() {
        let tempRow = Array.init(repeating: NOBLOCK, count: columnCount)
        colorStatus = Array.init(repeating: tempRow, count: rowCount)
    }
    
    func startGame() {
        currentSpeed = 1
        delegate?.updateSpeed(speed: currentSpeed)
        
        currentScore = 0
        delegate?.updateScore(score: currentScore)
        
        initColorStatus()
        
        initBlock()
        
        startTimer()
    }
    
    @objc func moveDown() {
        if couldMove(dirX: 0, dirY: 1) {
            moveOneStep(dirX: 0, dirY: 1)
        } else {
            for block in currentBlock {
                // block已经到最上面，游戏结束
                if block.y == 1 {
                    currentTimer?.invalidate()
                    delegate?.updateGameState()
                }
                // 标记每个方块当前位置
                colorStatus[block.y][block.x] = block.color
            }
            checkLineFull()
            initBlock()
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        setNeedsDisplay()
    }
    
    func checkLineFull() {
        for row in 0..<rowCount {
            var full = true
            for col in 0..<columnCount {
                if colorStatus[row][col] == NOBLOCK {
                    full = false
                    break
                }
            }
            if full {
                currentScore += 100
                delegate?.updateScore(score: currentScore)
                
                // 速度与分数正相关
                if currentScore >= currentSpeed * currentSpeed * 100 {
                    currentSpeed += 1
                    delegate?.updateSpeed(speed: currentSpeed)
                    stopTimer()
                    startTimer()
                }
                
                // 消去满行
                for newRow in (1...row).reversed() {
                    for col in 0..<columnCount {
                        colorStatus[newRow][col] = colorStatus[newRow - 1][col]
                    }
                }
            }
        }
    }
    
    func moveLeft() {
        if couldMove(dirX: -1, dirY: 0) {
            moveOneStep(dirX: -1, dirY: 0)
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        setNeedsDisplay()
    }
    
    func moveRight() {
        if couldMove(dirX: 1, dirY: 0) {
            moveOneStep(dirX: 1, dirY: 0)
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        setNeedsDisplay()
    }
    
    func rotate() {
        var couldRotate = true
        for i in 0..<currentBlock.count {
            let preX = currentBlock[i].x
            let preY = currentBlock[i].y
            // 以curreBlock[2]为中心旋转
            if i != 2 {
                let postX = currentBlock[2].x + preY - currentBlock[2].y
                let postY = currentBlock[2].y + currentBlock[2].x - preX
                
                if postX < 0 || postX >= columnCount || postY < 0 || postY >= rowCount || colorStatus[postY][postX] != NOBLOCK {
                    couldRotate = false
                    break
                }
            }
        }
        if couldRotate {
            drawAllBlocks()
            
            for block in currentBlock {
                CTX?.setFillColor(UIColor.white.cgColor)
                CTX?.fill(CGRect(x: CGFloat(block.x * blockWidth) + strokeWidth, y: CGFloat(block.y * blockWidth) + strokeWidth, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2))
            }
            
            for i in 0..<currentBlock.count {
                let preX = currentBlock[i].x
                let preY = currentBlock[i].y
                // 以curreBlock[2]为中心旋转
                if i != 2 {
                    currentBlock[i].x = currentBlock[2].x + preY - currentBlock[2].y
                    currentBlock[i].y = currentBlock[2].y + currentBlock[2].x - preX
                }
            }
            
            for block in currentBlock {
                CTX?.setFillColor(block.color)
                CTX?.fill(CGRect(x: CGFloat(block.x * blockWidth) + strokeWidth, y: CGFloat(block.y * blockWidth) + strokeWidth, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2))
            }
            
            image = UIGraphicsGetImageFromCurrentImageContext()
            setNeedsDisplay()
        }
    }
}
