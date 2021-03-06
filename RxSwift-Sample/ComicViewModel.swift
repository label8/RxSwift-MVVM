//
//  ComicViewModel.swift
//  RxSwift-Sample
//
//  Created by 蜂谷庸正 on 2018/08/07.
//  Copyright © 2018年 Tsunemasa Hachiya. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

class ComicViewModel {
    var title: Variable<String>
    var date: Variable<String>
    var imageUrl: Variable<URL?>
    
    var latestComicNum: Variable<Int?>
    var currentComic: Variable<Comic?>
    
    var isNextEnabled: Driver<Bool>
    var isPreviousEnabled: Driver<Bool>
    
    private var formatter = DateFormatter()
    private var service = ComicService()
    
    var disposeBag = DisposeBag()
    
    init() {
        title = Variable<String>("")
        date = Variable<String>("")
        imageUrl = Variable<URL?>(nil)
        latestComicNum = Variable<Int?>(nil)
        currentComic = Variable<Comic?>(nil)
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        isNextEnabled = Driver.combineLatest(self.latestComicNum.asDriver(), self.currentComic.asDriver(), resultSelector: { (latestNum, current) -> Bool in
            guard let latestNum = latestNum, let currentNum = current?.num else { return false}
            return latestNum != currentNum
        }).distinctUntilChanged()
        
        isPreviousEnabled = currentComic.asDriver().map({ (comic) -> Bool in
            guard let num = comic?.num else { return false }
            return num > 1
        }).distinctUntilChanged()
    }
    
    func getLatestComic() {
        service.getLatestComic().subscribe(onNext: { (comic) in
            guard let comic = comic else { return }
            self.latestComicNum.value = comic.num
            self.updateViewModel(comic: comic)
        }).disposed(by: disposeBag)
    }
    
    func getPreviousComic() {
        guard let current = currentComic.value?.num, current > 0 else { return }
        service.getComic(num: current - 1).subscribe(onNext: { (comic) in
            guard let comic = comic else { return }
            self.updateViewModel(comic: comic)
        }).disposed(by: disposeBag)
    }
    
    func getNextComic() {
        guard let current = currentComic.value?.num,
            let latest = latestComicNum.value,
            current < latest else { return }
        
        service.getComic(num: current + 1).subscribe(onNext: { (comic) in
            guard let comic = comic else { return }
            self.updateViewModel(comic: comic)
        }).disposed(by: disposeBag)
    }
    
    private func updateViewModel(comic: Comic) {
        self.currentComic.value = comic
        self.title.value = comic.title ?? ""
        
        if let urlString = comic.img, let url = URL(string: urlString) {
            self.imageUrl.value = url
        }
        
        if let date = comic.date {
            self.date.value = formatter.string(from: date)
        } else {
            self.date.value = ""
        }
    }
    
}
