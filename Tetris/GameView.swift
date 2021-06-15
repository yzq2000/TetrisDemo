//
//  GameView.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/15.
//

import UIKit

protocol GameDelegate {
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

class GameView: UIView{
    let columnCount = 15
    let rowCount = 22
    let NOBLOCK = UIColor.white.cgColor
    let blockWidth: Int
    
    let strokeWidth: CGFloat = 1
    var CTX = UIGraphicsGetCurrentContext()
    
    let baseSpeed = 1.0
    var currentSpeed: Int = 0
    
    var currentScore: Int = 0
    
    var currentBlock = [TetrisBlock]()
    var blockArray = [[TetrisBlock]]()
    
    var colorStatus = [[CGColor]]()
    
    var image: UIImage?
    
    var currentTimer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        self.blockWidth = Int(frame.width) / columnCount
        self.blockArray = [
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
                TetrisBlock(x: columnCount / 2, y: 2, color: UIColor.orange.cgColor),
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
        
        super.init()
        
        
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
        CTX?.setStrokeColor(UIColor.darkGray.cgColor)
        CTX?.setLineWidth(strokeWidth)
        CTX?.strokePath()
    }
    
    override func draw(_ rect: CGRect) {
        UIGraphicsGetCurrentContext()
        image?.draw(at: CGPoint.zero)
    }
    
    func initBlock() {
        let rand = Int(arc4random()) % blockArray.count
        currentBlock = blockArray[rand]
    }
    
    func initColorStatus() {
        for row in 0..<rowCount {
            for col in 0..<columnCount {
                CTX?.setFillColor(NOBLOCK)
                CTX?.fill((CGRect(x: CGFloat(col * blockWidth) + strokeWidth, y: CGFloat(row * blockWidth) + strokeWidth, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2)))
            }
        }
    }
    
    func startGame() {
        currentSpeed = 1
        updateSpeed(speed: currentSpeed)
        
        currentScore = 0
        updateScore(score: currentScore)
        
        initColorStatus()
        
        initBlock()
        
        currentTimer = Timer.scheduledTimer(timeInterval: TimeInterval(baseSpeed / Double(currentSpeed)), target: self, selector: #selector(moveDown), userInfo: nil, repeats: true)
    }
    
    @objc func moveDown() {
        if couldMove(dirX: 0, dirY: 1) {
            moveOneStep(dirX: 0, dirY: 1)
        } else {
            for block in currentBlock {
                // block已经到最上面，游戏结束
                if block.y == 1 {
                    currentTimer?.invalidate()
                    updateGameState()
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
                updateScore(score: currentScore)
                
                if currentScore >= currentSpeed * currentSpeed * 100 {
                    currentSpeed += 1
                    updateSpeed(speed: currentSpeed)
                    currentTimer?.invalidate()
                    currentTimer = Timer.scheduledTimer(timeInterval: TimeInterval(baseSpeed / Double(currentSpeed)), target: self, selector: #selector(moveDown), userInfo: nil, repeats: true)
                }
                
                for newRow in (1...row).reversed() {
                    for col in 0..<columnCount {
                        colorStatus[newRow][col] = colorStatus[newRow - 1][col]
                    }
                }
            }
        }
    }
    
    func drawBlock() {
        for row in 0..<rowCount {
            for col in 0..<columnCount {
                CTX?.setFillColor(colorStatus[row][col])
                CTX?.fill((CGRect(x: CGFloat(col * blockWidth) + strokeWidth, y: CGFloat(row * blockWidth) + strokeWidth, width: CGFloat(blockWidth) - strokeWidth * 2, height: CGFloat(blockWidth) - strokeWidth * 2)))
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
    
    func couldMove(dirX: Int, dirY: Int) -> Bool {
        for block in currentBlock {
            // 超出左右边界
            if block.x + dirX >= columnCount || block.x + dirX < 0 {
                return false
            }
            // 超出下边界
            if block.y + dirY >= rowCount {
                return false
            }
            // 旁边的block不为空
            if colorStatus[block.y][block.x + dirX] != NOBLOCK {
                return false
            }
        }
        return true
    }
    
    func moveOneStep(dirX: Int, dirY: Int) {
        drawBlock()
        
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
            drawBlock()
            
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

extension GameView: GameDelegate {
    func updateScore(score: Int) {
        <#code#>
    }
    
    func updateSpeed(speed: Int) {
        <#code#>
    }
    
    func updateGameState() {
        <#code#>
    }
}
