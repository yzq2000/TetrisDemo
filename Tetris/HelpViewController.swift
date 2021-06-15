//
//  HelpViewController.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/15.
//

import UIKit
import SnapKit

class HelpViewController: UIViewController {
    
    lazy var infoLabel: UILabel = {
        var label = UILabel()
        label.text = "俄罗斯方块（Tetris，俄文：Тетрис）是一款由俄罗斯人阿列克谢·帕基特诺夫于1984年6月发明的休闲游戏。该游戏曾经被多家公司代理过。" +
                    "经过多轮诉讼后，该游戏的代理权最终被任天堂获得。任天堂对于俄罗斯方块来说意义重大，因为将它与GB搭配在一起后，获得了巨大的成功。" +
                    "《俄罗斯方块》的基本规则是移动、旋转和摆放游戏自动输出的各种方块，使之排列成完整的一行或多行并且消除得分。（from 百度百科）"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        var label = UILabel()
        label.text = "created by Vibrant on 2021-6-15"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
    }
}
