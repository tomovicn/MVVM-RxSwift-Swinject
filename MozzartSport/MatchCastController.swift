//
//  MatchCastController.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import UIKit

class MatchCastController: UIViewController {

    public var match: Match?
    var matchCast: MatchCast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMatchCast()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getMatchCast() {
        APIManager.shared.getMatchCast(matchId: String((match?.id)!), succes: { (matchcast) in
                self.matchCast = matchcast
            }) { (error) in
                
        }
    }
    
}
