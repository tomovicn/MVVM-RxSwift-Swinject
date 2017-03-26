//
//  MatchsController.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import UIKit
import AlamofireImage

enum PickerType {
    case date, timeFrom, timeUntil
}

class MatchsController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var btnDate: UIButton!
    @IBOutlet var btnTimeFrom: UIButton!
    @IBOutlet var btnTimeUntil: UIButton!
    @IBOutlet weak var btnReload: UIButton!
    
    var allMatches = [Match]() {
        didSet {
            dataSource = allMatches
        }
    }
    var dataSource = [Match]() {
        didSet {
            tableView.reloadData()
        }
    }
    var favouriteMatchs = [Match](){
        didSet {
            if segmentedControl.selectedSegmentIndex == 1 {
                dataSource = favouriteMatchs
            }
        }
    }
    var pickerType: PickerType?
    var date = Date()
    var timeFromComponents = (0, 0)
    var timeUntilComponents = (23, 59)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get Favourites from Database
        favouriteMatchs = DBHelper().getFavouriteMatchs()
        //handle saving to Database when app goes to background
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: NSNotification.Name.init(rawValue: Constants.Notifications.saveData), object: nil)
        setVisuals()
        getScores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showMatchCast {
            let vc = segue.destination as! MatchCastController
            vc.match = dataSource[(sender as! IndexPath).section]
        }
    }
    
    func saveData() {
        DBHelper().saveFavourites(matchs: favouriteMatchs)
    }
    
    
    func setVisuals() {
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = 250
        
        segmentedControl.setTitle("Sve", forSegmentAt: 0)
        segmentedControl.setTitle("Izabrane", forSegmentAt: 1)
        segmentedControl.setTitle("U toku", forSegmentAt: 2)
        segmentedControl.setTitle("Zavrsene", forSegmentAt: 3)
        segmentedControl.setTitle("Naredne", forSegmentAt: 4)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        btnDate.setTitle(formatter.string(from: Date()), for: .normal)
        
    }
    
    //Fetch Data
    func getScores() {
        showProgressHUD()
        
        APIManager.shared.getScores(fromTime: timeFromInterval(), untilTime: timeUntilInterval(), succes: { (matchs) in
            self.hideProgressHUD()
            self.allMatches = matchs
        }) { (error) in
            self.hideProgressHUD()
            self.showDialog("Error", message: error, cancelButtonTitle: "Ok")
        }
    }
    
    func getLivescores() {
        showProgressHUD()
        APIManager.shared.getLivescores(succes: { (matchs) in
            self.hideProgressHUD()
            self.dataSource = matchs
        }) { (error) in
            self.hideProgressHUD()
            self.showDialog("Error", message: error, cancelButtonTitle: "Ok")
        }
    }

    //Segment change action
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        btnReload.isHidden = true
        switch sender.selectedSegmentIndex {
        case 0:
            dataSource = allMatches
            btnReload.isHidden = false
        case 1:
            dataSource = favouriteMatchs
        case 2:
            getLivescores()
        case 3:
            dataSource = allMatches.filter({ (match) -> Bool in
                return match.statusCode == 100
            })
        case 4:
            dataSource = allMatches.filter({ (match) -> Bool in
                return match.statusCode == 0
            })
        default:
            break
        }
    }
    
    //Actions
    @IBAction func dateAction(_ sender: AnyObject) {
        if pickerType == nil {
            pickerType = .date
            SimpleDatePicker.present(in: self, with: self, dateMin: nil, andDateMax: nil)
        }
    }
    
    @IBAction func timeAction(_ sender: UIButton) {
        if pickerType == nil {
            if sender.tag == 0 {
                pickerType = .timeFrom
            } else {
                pickerType = .timeUntil
            }
            SimpleDatePicker.presentTime(in: self, with: self)
        }
    }
    
    @IBAction func refreshData(_ sender: AnyObject) {
        getScores()
    }
    
    //Data/Time management
    func timeFromInterval() -> TimeInterval {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = gregorian.components([.year, .month, .day, .hour, .minute], from: date)
        
        components.hour = timeFromComponents.0
        components.minute = timeFromComponents.1
        
        return gregorian.date(from: components)!.timeIntervalSince1970
    }
    
    func timeUntilInterval() -> TimeInterval {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = gregorian.components([.year, .month, .day, .hour, .minute], from: date)
        
        components.hour = timeUntilComponents.0
        components.minute = timeUntilComponents.1
        
        return gregorian.date(from: components)!.timeIntervalSince1970
    }
    
}

extension MatchsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MatchCell
        configure(cell: cell, match: dataSource[indexPath.section])
        cell.delegate = self
        
        return cell
    }
    
    func configure(cell: MatchCell, match: Match) {
        cell.imgView.af_setImage(withURL: URL(string: Constants.API.Endpoints.image + String(match.categoryId))!)
        
        cell.lblTime.text = match.matchTime
        cell.lblHomeTeam.text = match.homeTeam?.name
        cell.lblGuestTeam.text = match.guestTeam?.name
        if let homeYellowCards = match.cardsGroup?.homeTeam?.yellow.count {
            cell.lblHomeYellowCards.text = String(homeYellowCards)
        }
        if let guestYellowCards = match.cardsGroup?.guestTeam?.yellow.count {
            cell.lblGuestYellowCards.text = String(guestYellowCards)
        }
        if let homeRedCards = match.cardsGroup?.homeTeam?.red.count {
            cell.lblHomeRedCards.text = String(homeRedCards)
        }
        if let guestRedCards = match.cardsGroup?.guestTeam?.red.count {
            cell.lblGuestRedCards.text = String(guestRedCards)
        }
        if let homeScoreFirstHalf = match.score?.halfTime?.homeTeam {
            cell.lblHomeScoreFirstHalf.text = String(homeScoreFirstHalf)
        }
        if let guestScoreFirstHalf = match.score?.halfTime?.guestTeam {
            cell.lblGuestScoreFirstHalf.text = String(guestScoreFirstHalf)
        }
        if let homeScore = match.score?.current?.homeTeam {
            cell.lblHomeScore.text = String(homeScore)
        }
        if let guestScore = match.score?.current?.guestTeam {
            cell.lblGuestScore.text = String(guestScore)
        }
        
        let homeShooters = match.goals?.homeTeam.map { String($0.time) + "' " + $0.player! }.joined(separator: ", ")
        cell.lblHomeShooters.text = homeShooters
        let guestShooters = match.goals?.guestTeam.map { String($0.time) + "' " + $0.player! }.joined(separator: ", ")
        cell.lblGuestShooters.text = guestShooters
        
        if favouriteMatchs.contains(match) {
            cell.btnFavourite.setImage(UIImage.init(named: "favoritesSelected"), for: .normal)
        } else {
            cell.btnFavourite.setImage(UIImage.init(named: "favoritesUnselected"), for: .normal)
        }
    }
    
}

extension MatchsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.showMatchCast, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

extension MatchsController: CellDelegate {
    func didPressedFavorite(cell: MatchCell) {
        let indexPath = tableView.indexPath(for: cell)
        let match = dataSource[(indexPath?.section)!]
        if favouriteMatchs.contains(match) {
            favouriteMatchs.remove(at: favouriteMatchs.index(of: match)!)
            cell.btnFavourite.setImage(UIImage.init(named: "favoritesUnselected"), for: .normal)
        } else {
            favouriteMatchs.append(match)
            cell.btnFavourite.setImage(UIImage.init(named: "favoritesSelected"), for: .normal)
        }
    }
}

extension MatchsController : SimpleDatePickerDelegate {
    
    func simpleDatePickerDidDismiss(with date: Date!) {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        btnDate.setTitle(formatter.string(from: date), for: UIControlState.normal)
        pickerType = nil
    }
    
    func simpleDatePickerDidDismiss(withTime date: Date!) {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = gregorian.components([.hour, .minute], from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date)
        if pickerType == .timeFrom {
            timeFromComponents = (components.hour!, components.minute!)
            btnTimeFrom.setTitle("Od " + time, for: UIControlState.normal)
        } else {
            timeUntilComponents = (components.hour!, components.minute!)
            btnTimeUntil.setTitle("Do " + time, for: UIControlState.normal)
        }
        pickerType = nil
    }
    
    func simpleDatePickerDidDismiss() {
        pickerType = nil
    }
    
    func simpleDatePickerValueChanged(_ date: Date!) {
        
    }
    
}
