//
//  StartViewController.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/15.
//

import UIKit

class StartViewController: UIViewController {
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Tetris"
        label.textColor = .yellow
        label.font = UIFont.systemFont(ofSize: 64)
        return label
    }()
    
    lazy var playButton: UIButton = {
        var btn = UIButton(frame: .zero)
        btn.setTitle("Play", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        btn.setTitleColor(.blue, for: .normal)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(playBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var helpButton: UIButton = {
        var btn = UIButton(frame: .zero)
        btn.setTitle("Help", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        btn.setTitleColor(.green, for: .normal)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(helpBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var bgImageView: UIImageView = {
        var imgView = UIImageView(image: UIImage(named: "Tetris"))
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        
        view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.size.equalTo(CGSize(width: 150, height: 50))
        }
        
        view.addSubview(helpButton)
        helpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(playButton.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 150, height: 50))
        }
    }
    
    @objc func playBtnClicked() {
        let vc = GameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func helpBtnClicked() {
        let vc = HelpViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
