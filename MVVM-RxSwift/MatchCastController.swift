//
//  MatchCastController.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import UIKit
import RxSwift

class MatchCastController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHomeTeam: UILabel!
    @IBOutlet weak var lblGuestTeam: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    
    public var apiManager: APIManager?
    private let disposeBag = DisposeBag()
    
    public var matchID: String?
    var matchCast: MatchCast?{
        didSet {
            setVisuals()
            if let comments = matchCast?.comments {
                for index in 0...(comments.count - 1) {
                    dataSource.append(comments[String(index)]!)
                }
                tableView.reloadData()
            }
        }
    }
    var dataSource = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVisuals()
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

    func setVisuals() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        lblHomeTeam.text = matchCast?.homeTeam?.name
        lblGuestTeam.text = matchCast?.guestTeam?.name
        var result = ""
        if let homeScore = matchCast?.score?.current?.homeTeam {
            result = String(homeScore) + " : "
        }
        if let guestScore = matchCast?.score?.current?.guestTeam {
            result = result + String(guestScore)
        }
        lblResult.text = result
    }
    
    func getMatchCast() {
        showProgressHUD()
        apiManager?.getMatchCast(matchId: matchID!).subscribe { event in
            switch event {
            case .success(let matchcast):
                self.hideProgressHUD()
                self.matchCast = matchcast
            case .error(let error):
                self.hideProgressHUD()
                self.showDialog("Error", message: error.localizedDescription, cancelButtonTitle: "Ok")
            }
        }.disposed(by: disposeBag)
        
    }
    
}

extension MatchCastController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentarCell")!
        cell.textLabel?.text = dataSource[indexPath.row].text
        cell.detailTextLabel?.text = dataSource[indexPath.row].time
        return cell
    }
}
