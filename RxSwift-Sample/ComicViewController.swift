//
//  ComicViewController.swift
//  RxSwift-Sample
//
//  Created by 蜂谷庸正 on 2018/07/30.
//  Copyright © 2018年 Tsunemasa Hachiya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ComicViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let comicViewModel: ComicViewModel = ComicViewModel()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // From ViewModel
        
        comicViewModel.title.asDriver().drive(titleLable.rx.text).disposed(by: disposeBag)
        comicViewModel.imageUrl.asDriver().drive(onNext: { [weak self](url) in
            self?.comicImageView.kf.setImage(with: url)
        }).disposed(by: disposeBag)
        
        comicViewModel.date.asDriver().drive(captionLabel.rx.text).disposed(by: disposeBag)
        
        comicViewModel.isNextEnabled.drive(nextButton.rx.isEnabled).disposed(by: disposeBag)
        comicViewModel.isPreviousEnabled.drive(previousButton.rx.isEnabled).disposed(by: disposeBag)
        
        
        // To View Model
        
        previousButton.rx.tap.asDriver().drive(onNext: {
            self.comicViewModel.getPreviousComic()
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.asDriver().drive(onNext: {
            self.comicViewModel.getNextComic()
        }).disposed(by: disposeBag)
        
        comicViewModel.getLatestComic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

