//
//  MatchCastCellViewModelFromComment.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 6/5/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation


class MatchCastCellViewModelFromComment: MatchCastCellViewModel {
    
    let comment: Comment
    
    var title: String
    var time: String
    
    // MARK: Init
    
    init(withComment comment: Comment) {
        self.comment = comment
        self.title = comment.text ?? ""
        self.time = comment.time ?? ""
    }
    
}
