//
//  ViewController.swift
//  Tetris
//
//  Created by yangzhuqin on 2021/6/15.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.text = "Tetris"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }


}

