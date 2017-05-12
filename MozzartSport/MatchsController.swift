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
    
    public var apiManager: APIManager?
    
    var viewModel: MatchsViewModel = MatchsViewModelFromMatchs(withMatchs: [])
    var pickerType: PickerType?
    var date = Date()
    var timeFromComponents = (0, 0)
    var timeUntilComponents = (23, 59)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            //let vc = segue.destination as! MatchCastController
            //vc.match = dataSource[(sender as! IndexPath).section]
        }
    }
    
    func saveData() {
        viewModel.saveFavorites()
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
        
        apiManager?.getScores(fromTime: timeFromInterval(), untilTime: timeUntilInterval(), succes: { (matchs) in
            self.hideProgressHUD()
            self.viewModel = MatchsViewModelFromMatchs(withMatchs: matchs)
            self.tableView.reloadData()
        }) { (error) in
            self.hideProgressHUD()
            self.showDialog("Error", message: error, cancelButtonTitle: "Ok")
        }
    }
    
    func getLivescores() {
        showProgressHUD()
        apiManager?.getLivescores(succes: { (matchs) in
            self.hideProgressHUD()
            self.viewModel.liveMatchs = matchs
            self.tableView.reloadData()
        }) { (error) in
            self.hideProgressHUD()
            self.showDialog("Error", message: error, cancelButtonTitle: "Ok")
        }
    }

    //Segment change action
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        btnReload.isHidden = sender.selectedSegmentIndex != 0
        viewModel.filterType = FilterType(rawValue: sender.selectedSegmentIndex)!
        if sender.selectedSegmentIndex == 2 {
            getLivescores()
        }
        tableView.reloadData()
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
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MatchCell
        cell.viewCellModel = viewModel.viewModelFor(section: indexPath.section, row: indexPath.row)
        cell.delegate = self
        
        return cell
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
        var cellViewModel = cell.viewCellModel
        if cellViewModel.isFavorite {
            viewModel.removeFromFavorites(viewCellModel: cellViewModel)
            cell.btnFavourite.setImage(UIImage.init(named: "favoritesUnselected"), for: .normal)
        } else {
            viewModel.addToFavorites(viewCellModel: cellViewModel)
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
