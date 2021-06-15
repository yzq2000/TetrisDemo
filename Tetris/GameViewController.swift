//
//  GameViewController.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/15.
//

import UIKit

class GameViewController: UIViewController{
    let paddingRight: CGFloat = 100
    let paddingUp: CGFloat = 150
    let paddingDown: CGFloat = 250
    let textHeight:CGFloat = 30
    let btnWidth: CGFloat = 60
    let spacingWidth: CGFloat = 20 // == paddingLeft
    
    lazy var gameGridView: GameView = {
        let x = spacingWidth
        let y = paddingUp
        let width = UIScreen.main.bounds.width - spacingWidth // - paddingRight
        let height = UIScreen.main.bounds.height - paddingUp - paddingDown
        var gameGridView = GameView(frame: CGRect(x: x, y: y, width: width, height: height))
        return gameGridView
    }()
    
    lazy var leftBtn: UIButton = {
        let x = spacingWidth
        let y = paddingUp + gameGridView.bounds.height + spacingWidth
        var btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnWidth))
        btn.setImage(UIImage(named: "icon_left"), for: .normal)
        btn.addTarget(self, action: #selector(leftBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var rightBtn: UIButton = {
        let x = spacingWidth + gameGridView.bounds.width - btnWidth - spacingWidth
        let y = paddingUp + gameGridView.bounds.height + spacingWidth
        var btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnWidth))
        btn.setImage(UIImage(named: "icon_right"), for: .normal)
        btn.addTarget(self, action: #selector(rightBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var downBtn: UIButton = {
        let x = spacingWidth + gameGridView.bounds.width * 0.5 - btnWidth * 0.5
        let y = paddingUp + gameGridView.bounds.height + spacingWidth
        var btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnWidth))
        btn.setImage(UIImage(named: "icon_down"), for: .normal)
        btn.addTarget(self, action: #selector(downBtnClicked), for: .touchUpInside)
        return btn
    }()

    lazy var rotateBtn: UIButton = {
        let x = UIScreen.main.bounds.width - btnWidth - spacingWidth
        let y = paddingUp + gameGridView.bounds.height - spacingWidth - btnWidth
        var btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnWidth))
        btn.setImage(UIImage(named: "icon_rotate"), for: .normal)
        btn.addTarget(self, action: #selector(rotateBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var pauseBtn: UIButton = {
        let x = UIScreen.main.bounds.width - btnWidth - spacingWidth
        let y = paddingUp + gameGridView.bounds.height - spacingWidth - btnWidth - btnWidth - spacingWidth
        var btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnWidth))
        btn.setImage(UIImage(named: "icon_pause"), for: .normal)
        btn.addTarget(self, action: #selector(pauseBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var restartBtn: UIButton = {
        let x = UIScreen.main.bounds.width - btnWidth - spacingWidth
        let y = paddingUp - spacingWidth - btnWidth
        var btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnWidth))
        btn.setImage(UIImage(named: "icon_restart"), for: .normal)
        btn.addTarget(self, action: #selector(restartBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var backBtn: UIButton = {
        let x = spacingWidth
        let y = paddingUp - spacingWidth - btnWidth
        var btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnWidth))
        btn.setImage(UIImage(named: "icon_back"), for: .normal)
        
        btn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let x: CGFloat = UIScreen.main.bounds.width * 0.5 - 50
        let y: CGFloat = paddingUp - 65
        let width: CGFloat = 100
        let height: CGFloat = 30
        var label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.text = "Tetris"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36)
        return label
    }()
    
    lazy var scoreTextLabel: UILabel = {
        let x = UIScreen.main.bounds.width - btnWidth - spacingWidth
        let y = paddingUp + spacingWidth
        var label = UILabel(frame: CGRect(x: x, y: y, width: btnWidth, height: textHeight))
        label.text = "Score"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var scoreNumberLabel: UILabel = {
        let x = UIScreen.main.bounds.width - btnWidth - spacingWidth
        let y = paddingUp + spacingWidth + textHeight
        var label = UILabel(frame: CGRect(x: x, y: y, width: btnWidth, height: textHeight))
        label.text = "0000"
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    lazy var speedTextLabel: UILabel = {
        let x = UIScreen.main.bounds.width - btnWidth - spacingWidth
        let y = paddingUp + spacingWidth + textHeight + spacingWidth + textHeight
        var label = UILabel(frame: CGRect(x: x, y: y, width: btnWidth, height: textHeight))
        label.text = "Speed"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var speedNumberLabel: UILabel = {
        let x = UIScreen.main.bounds.width - btnWidth - spacingWidth
        let y = paddingUp + spacingWidth + textHeight + spacingWidth + textHeight + textHeight
        var label = UILabel(frame: CGRect(x: x, y: y, width: btnWidth, height: textHeight))
        label.text = "0"
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let x: CGFloat = 0
        let y: CGFloat = UIScreen.main.bounds.height - 100
        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = 30
        var label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.text = "created by Vibrant on 2021-6-15"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        gameGridView.delegate = self
        
        view.addSubview(gameGridView)
        view.addSubview(titleLabel)
        view.addSubview(backBtn)
        view.addSubview(restartBtn)
        view.addSubview(leftBtn)
        view.addSubview(rightBtn)
        view.addSubview(downBtn)
        view.addSubview(rotateBtn)
        view.addSubview(pauseBtn)
        view.addSubview(scoreTextLabel)
        view.addSubview(scoreNumberLabel)
        view.addSubview(speedTextLabel)
        view.addSubview(speedNumberLabel)
        view.addSubview(authorLabel)
        
        gameGridView.startGame()
    }
}
