//
//  SimplePickerExampleViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 7/30/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class SimplePickerExampleViewController: UIViewController {
    private let pickerViewList = [UIPickerView(), UIPickerView(), UIPickerView()]
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindData()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = CellItem.pickerView.title
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        pickerViewList.forEach { view.addSubview($0) }
    }
    
    private func configureLayout() {
        pickerViewList[0].snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        pickerViewList[1].snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        pickerViewList[2].snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    private func configureUI() {
        
    }
    
    private func bindData() {
        Observable.just(["하나", "둘", "셋", "얍"])
            .bind(to: pickerViewList[0].rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        pickerViewList[0].rx.modelSelected(String.self)
            .subscribe(with: self) { owner, item in
                if let first = item.first {
                    owner.view.makeToast(first, duration: 1.5)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.just(["하나", "둘", "셋", "얍"])
            .bind(to: pickerViewList[1].rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                                          ])
            }
            .disposed(by: disposeBag)
        
        pickerViewList[1].rx.modelSelected(String.self)
            .subscribe(with: self) { owner, items in
                if let first = items.first {
                    var style = ToastStyle()
                    style.backgroundColor = .systemBlue
                    owner.view.makeToast(first, duration: 1.5, style: style)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.systemRed, UIColor.systemGreen, UIColor.systemBlue])
            .bind(to: pickerViewList[2].rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        pickerViewList[2].rx.modelSelected(UIColor.self)
            .subscribe(with: self, onNext: { owner, items in
                if let first = items.first {
                    var style = ToastStyle()
                    style.backgroundColor = first
                    owner.view.makeToast(String(describing: first.accessibilityName), duration: 1.5, style: style)
                }
            })
            .disposed(by: disposeBag)
    }
}
