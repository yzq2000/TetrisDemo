//
//  GameViewControllerExt.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/16.
//

import UIKit

extension GameViewController {
    @objc func leftBtnClicked() {
        gameGridView.moveLeft()
    }
    
    @objc func leftBtnLongPressed() {
        
    }
    
    @objc func rightBtnClicked() {
        gameGridView.moveRight()
    }
    
    @objc func rightBtnLongPressed() {
        
    }
    
    @objc func downBtnClicked() {
        gameGridView.moveDown()
    }
    
    @objc func downBtnLongPressed() {
        
    }
    
    @objc func rotateBtnClicked() {
        gameGridView.rotate()
    }
    
    @objc func pauseBtnClicked() {
        gameGridView.startGame()
    }
    
    @objc func backBtnClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func restartBtnClicked() {
        let alert = UIAlertController(title: "Restart", message: "Would U like to restart a game?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension GameViewController: GameDelegate {
    func updateScore(score: Int) {
        scoreNumberLabel.text = "\(score)"
    }
    
    func updateSpeed(speed: Int) {
        speedNumberLabel.text = "\(speed)"
    }
    
    func updateGameState() {
        let alert = UIAlertController(title: "Game Over", message: "Would U like to restart a game?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}
