//
//  PriceTextFieldCell.swift
//  KarrotWrite
//
//  Created by gaeng on 2022/06/30.
//

import UIKit
import RxCocoa
import RxSwift

class PriceTextFieldCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let priceInputField: UITextField = {
       let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.font = .systemFont(ofSize: 17)
        return textField
    }()
    
    let freeshareButton: UIButton = {
        let button = UIButton()
        button.setTitle("무료 나눔", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.tintColor = .systemOrange
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PriceTextFieldCellViewModel) {
        viewModel.showFreeShareButton
            .map { !$0 }
            .emit(to: freeshareButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.resetPrice
            .map { _ in "" }
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        priceInputField.rx.text
            .bind(to: viewModel.priceValue)
            .disposed(by: disposeBag)
        
        freeshareButton.rx.tap
            .bind(to: viewModel.freeShareButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        [priceInputField, freeshareButton].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        freeshareButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
    }
}
