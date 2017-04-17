//
//  MatchCastController.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import UIKit

class MatchCastController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHomeTeam: UILabel!
    @IBOutlet weak var lblGuestTeam: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    
    public var apiManager: APIManager?
    
    public var match: Match?
    var matchCast: MatchCast?{
        didSet {
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
        
        lblHomeTeam.text = match?.homeTeam?.name
        lblGuestTeam.text = match?.guestTeam?.name
        var result = ""
        if let homeScore = match?.score?.current?.homeTeam {
            result = String(homeScore) + " : "
        }
        if let guestScore = match?.score?.current?.guestTeam {
            result = result + String(guestScore)
        }
        lblResult.text = result
    }
    
    func getMatchCast() {
        showProgressHUD()
        apiManager?.getMatchCast(matchId: String((match?.id)!), succes: { (matchcast) in
                self.hideProgressHUD()
                self.matchCast = matchcast
            }) { (error) in
                self.hideProgressHUD()
                self.showDialog("Error", message: error, cancelButtonTitle: "Ok")
        }
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
