

# BUPT移动互联网技术及应用大作业报告
| 姓名   | 班级       | 学号       |
| ------ | ---------- | ---------- |
| Vibrant |  |  |

## 相关技术
- UIKitk框架提供一系列的Class(类)来建立和管理iPhone OS应用程序的用户界面( UI )接口、应用程序对象、事件控制、绘图模型、窗口、视图和用于控制触摸屏等的接口。
- SnapKit：一个经典的Swift版的第三方库，专门用于项目的自动布局，目前在github上的stars就高达9340颗星，这是一个不小的数字，亦足以证明它存在的非凡意义和作用。在iOS开发（swift）中，它是用于项目最优秀的自动布局的必选库之一。
## 系统功能需求
实现一个iOS版本的俄罗斯方块。通过移动、旋转和摆放游戏自动输出的各种方块，使之排列成完整的一行或多行并且消除得分。
## 系统设计与实现
### 总体设计
系统入口为StartViewController（开始界面）。可导航到HelpViewController（帮助界面）和GameViewController（游戏界面）。帮助界面展示说明信息。游戏界面进行俄罗斯方块游戏。
### 系统组成
- StartViewController：开始界面
- HelpViewController：帮助界面
- GameViewController：游戏界面
- GameView：游戏界面的子图
### 模块设计
#### StartViewController
展示开始界面（由1个label和2个button组成），点击Play按钮进入StartViewController，点击Help按钮进入HelpViewController。
#### HelpViewController
展示说明信息和作者信息，由2个label组成，使用SnapKit自动布局。
#### GameViewController
游戏界面，由4个label，7个button和1个gameView组成。
- 4个label用于记录分数和速度。
- 3个方向button，用于左下右移动，有点击和长按手势。点击移动1格，长按加速移动。
- 1个旋转button，用于改变块的形状。
- 3个功能button，分别有暂停，重开和退出功能。
- gameView是游戏画面。
#### GameView
游戏画面。
- 采用GameDelegate协议实现view与controller的连接。
- 定义TetrisBlock结构体表示单位块。
- 用blockArray: [[TetrisBlock]]记录7种块的形状。
- 用UIGraphicsGetCurrentContext绘制网格和块。
### 关键代码

#### 单位块的定义
```swift
struct TetrisBlock {
    var x: Int
    var y: Int
    var color: CGColor
    var debug: String {
        return"Block x = \(x), y = \(y)"
    }
}
```

#### 块的形状定义
```swift
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
```

#### 绘制网格
```swift
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
```

#### 判断当前块是否可移动
```swift
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
```

### 移动当前块
```swift
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
```

#### 获取初始块
```swift
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
```

#### 检查满行及消去
```swift
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
```

#### 长按手势及事件
```swift
// 长按⬅️
btn.addTarget(self, action: #selector(startTimerLeft), for: .touchDown)
btn.addTarget(self, action: #selector(stopTimer), for: .touchCancel)
btn.addTarget(self, action: #selector(stopTimer), for: .touchUpOutside)
btn.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)

@objc func startTimerLeft() {
    timer = Timer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(leftBtnClicked), userInfo: nil, repeats: true)
    RunLoop.current.add(timer!, forMode: .common)
}

@objc func stopTimer() {
    timer?.invalidate()
}

@objc func leftBtnClicked() {
    gameGridView.moveLeft()
}
```

#### 旋转块
```swift
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
```

#### 采用SnapKit布局HelpView
```swift
view.addSubview(infoLabel)
infoLabel.snp.makeConstraints { make in
    make.centerX.equalToSuperview()
    make.centerY.equalToSuperview().offset(-50)
    make.width.equalToSuperview().multipliedBy(0.9)
}

view.addSubview(authorLabel)
authorLabel.snp.makeConstraints { make in
    make.centerX.equalToSuperview()
    make.top.equalTo(infoLabel.snp.bottom).offset(50)
}
```
## 系统可能的扩展
- 可增加登录注册功能，保存游戏档案，提高用户粘性。
- 可增加全网排名功能，加强游戏竞技性。
- 可增加难度选择功能，提供更好的游戏体验。
## 总结体会
通过实现这个俄罗斯方块demo，熟悉了protocol在swift中的使用，熟悉使用UIGraphicsGetCurrentContext实现iOS的Quart2D绘图，对iOS开发有了更深的理解。受益匪浅。
