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
        if gameGridView.currentTimer?.isValid == true {
            gameGridView.stopTimer()
            gameGridView.isPausing = true
            leftBtn.isEnabled = false
            downBtn.isEnabled = false
            rightBtn.isEnabled = false
            rotateBtn.isEnabled = false
        } else {
            gameGridView.startTimer()
            gameGridView.isPausing = false
            leftBtn.isEnabled = true
            downBtn.isEnabled = true
            rightBtn.isEnabled = true
            rotateBtn.isEnabled = true
        }
    }
    
    @objc func backBtnClicked() {
        gameGridView.stopTimer()
        let alert = UIAlertController(title: "Exit", message: "R U sure to Exit? Game progress will not be saved.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            if self.gameGridView.isPausing == false {
                self.gameGridView.startTimer()
            }
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func restartBtnClicked() {
        gameGridView.stopTimer()
        let alert = UIAlertController(title: "Restart", message: "Would U like to restart a game?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.gameGridView.startGame()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            if self.gameGridView.isPausing == false {
                self.gameGridView.startTimer()
            }
        }
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
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.gameGridView.startGame()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}
