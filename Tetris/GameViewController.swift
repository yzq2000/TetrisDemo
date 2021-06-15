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
    let paddingDown: CGFloat = 150
    let textHeight:CGFloat = 30
    let btnWidth: CGFloat = 60
    let spacingWidth: CGFloat = 20 // == paddingLeft
    
    lazy var gameGridView: GameView = {
        let x = spacingWidth
        let y = paddingRight
        let width = UIScreen.main.bounds.width - spacingWidth - paddingRight
        let height = UIScreen.main.bounds.height - paddingUp - paddingDown
        var gameGridView = GameView(frame: CGRect(x: x, y: y, width: width, height: height))
        gameGridView.backgroundColor = .red
        return gameGridView
    }()
    
    lazy var leftBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "icon_left"), for: .normal)
        return btn
    }()
    
    lazy var rightBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "icon_right"), for: .normal)
        return btn
    }()
    
    lazy var downBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "icon_down"), for: .normal)
        return btn
    }()

    lazy var rotateBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "icon_rotate"), for: .normal)
        return btn
    }()
    
    lazy var pauseBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "icon_pause"), for: .normal)
        return btn
    }()
    
    lazy var restartBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "icon_restart"), for: .normal)
        return btn
    }()
    
    lazy var backBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "icon_back"), for: .normal)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Tetris"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36)
        return label
    }()
    
    lazy var scoreTextLabel: UILabel = {
        var label = UILabel()
        label.text = "Score"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var scoreNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "0000"
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    lazy var speedTextLabel: UILabel = {
        var label = UILabel()
        label.text = "Speed"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var speedNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        gameGridView.delegate = self
        
        view.addSubview(gameGridView)
        gameGridView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(spacingWidth)
            make.right.equalToSuperview().offset(-paddingRight)
            make.top.equalToSuperview().offset(paddingUp)
            make.bottom.equalToSuperview().offset(-paddingDown)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(gameGridView.snp.top).offset(-spacingWidth * 2)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(spacingWidth)
            make.bottom.equalTo(gameGridView.snp.top).offset(-spacingWidth)
            make.width.height.equalTo(btnWidth)
        }
        
        view.addSubview(restartBtn)
        restartBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-spacingWidth)
            make.bottom.equalTo(gameGridView.snp.top).offset(-spacingWidth)
            make.width.height.equalTo(btnWidth)
        }
        
        view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(spacingWidth)
            make.top.equalTo(gameGridView.snp.bottom).offset(spacingWidth)
            make.width.height.equalTo(btnWidth)
        }
        
        view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-spacingWidth)
            make.top.equalTo(gameGridView.snp.bottom).offset(spacingWidth)
            make.width.height.equalTo(btnWidth)
        }
        
        view.addSubview(downBtn)
        downBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gameGridView.snp.bottom).offset(spacingWidth)
            make.width.height.equalTo(btnWidth)
        }
        
        view.addSubview(rotateBtn)
        rotateBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-spacingWidth)
            make.bottom.equalTo(gameGridView.snp.bottom).offset(-spacingWidth)
            make.width.height.equalTo(btnWidth)
        }
        
        view.addSubview(pauseBtn)
        pauseBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-spacingWidth)
            make.bottom.equalTo(rotateBtn.snp.top).offset(-spacingWidth)
            make.width.height.equalTo(btnWidth)
        }
        
        view.addSubview(scoreTextLabel)
        scoreTextLabel.snp.makeConstraints { make in
            make.top.equalTo(gameGridView.snp.top).offset(spacingWidth)
            make.left.equalTo(gameGridView.snp.right).offset(spacingWidth)
            make.right.equalToSuperview().offset(-spacingWidth)
            make.height.equalTo(textHeight)
        }
        
        view.addSubview(scoreNumberLabel)
        scoreNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreTextLabel.snp.bottom)
            make.left.equalTo(gameGridView.snp.right).offset(spacingWidth)
            make.right.equalToSuperview().offset(-spacingWidth)
            make.height.equalTo(textHeight)
        }
        
        view.addSubview(speedTextLabel)
        speedTextLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreNumberLabel.snp.bottom).offset(spacingWidth)
            make.left.equalTo(gameGridView.snp.right).offset(spacingWidth)
            make.right.equalToSuperview().offset(-spacingWidth)
            make.height.equalTo(textHeight)
        }
        
        view.addSubview(speedNumberLabel)
        speedNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(speedTextLabel.snp.bottom)
            make.left.equalTo(gameGridView.snp.right).offset(spacingWidth)
            make.right.equalToSuperview().offset(-spacingWidth)
            make.height.equalTo(textHeight)
        }
        
    }
}

extension GameViewController: GameDelegate {
    func updateScore(score: Int) {
        
    }
    
    func updateSpeed(speed: Int) {
        
    }
    
    func updateGameState() {
        
    }
}
