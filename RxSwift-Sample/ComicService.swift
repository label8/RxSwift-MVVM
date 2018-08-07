//
//  ComicService.swift
//  RxSwift-Sample
//
//  Created by 蜂谷庸正 on 2018/08/07.
//  Copyright © 2018年 Tsunemasa Hachiya. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

class ComicService {
    
    let latestURL = "https://xkcd.com/info.0.json"
    
    let comicURL: (Int) -> String = {
        "https://xkcd.com/\($0)/info.0.json"
    }
    
    func getLatestComic() -> Observable<Comic?> {
        return RxAlamofire.requestJSON(.get, latestURL)
            .map {_, json in self.comicFromJson(json: json)}
    }
    
    func getComic(num: Int) -> Observable<Comic?> {
        return RxAlamofire.requestJSON(.get, comicURL(num))
            .map {_, json in self.comicFromJson(json: json)}
    }
    
    func comicFromJson(json: Any) -> Comic? {
        if let dict = json as? [String: Any] {
            return Comic(dict)
        }
        return nil
    }
}
