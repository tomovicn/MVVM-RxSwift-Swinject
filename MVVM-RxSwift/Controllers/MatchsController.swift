//
//  MatchsController.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift

enum PickerType {
    case date, timeFrom, timeUntil
}

class MatchsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnTimeFrom: UIButton!
    @IBOutlet weak var btnTimeUntil: UIButton!
    @IBOutlet weak var btnReload: UIButton!
    
    var viewModel: MatchsViewModel!
    
    private let disposeBag = DisposeBag()
    var pickerType: PickerType?
    
    private var dateFormatter = DateFormatter()
    private var timeFormatter = DateFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        timeFormatter.dateFormat = "HH:mm"
        setVisuals()
        configureBindings()
        viewModel.startFetch(refreshDriver: btnReload.rx.tap.asDriver())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showMatchCast {
            let vc = segue.destination as! MatchCastController
            vc.matchID = viewModel.matchIDFor(section: (sender as! IndexPath).section)
        }
    }
    
    func setVisuals() {
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = 250
        
        segmentedControl.setTitle("Sve", forSegmentAt: 0)
        segmentedControl.setTitle("Izabrane", forSegmentAt: 1)
        segmentedControl.setTitle("U toku", forSegmentAt: 2)
        segmentedControl.setTitle("Zavrsene", forSegmentAt: 3)
        segmentedControl.setTitle("Naredne", forSegmentAt: 4)
    }
    
    func configureBindings() {
        
        viewModel.isLoading.asDriver().drive(onNext: { isLoading in
                if isLoading {
                    self.showProgressHUD()
                } else {
                    self.hideProgressHUD()
                }
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.errorMessage.asDriver().drive(onNext: {[weak self] error in
                if let errorMessage = error {
                    self?.showDialog("Error", message: errorMessage, cancelButtonTitle: "Ok")
                }
            }).disposed(by: disposeBag)
        
        viewModel.date.asDriver().map { self.dateFormatter.string(from: $0) }.drive(self.btnDate.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel.timeFrom.asDriver().map { "Od " + self.timeFormatter.string(from: $0) }.drive(self.btnTimeFrom.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel.timeUntil.asDriver().map { "Do " + self.timeFormatter.string(from: $0) }.drive(self.btnTimeUntil.rx.title(for: .normal)).disposed(by: disposeBag)
        
    }

    //Segment change action
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        btnReload.isHidden = sender.selectedSegmentIndex != 0
        viewModel.filterType = FilterType(rawValue: sender.selectedSegmentIndex)!
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
            pickerType = sender.tag == 0 ? .timeFrom : .timeUntil
            SimpleDatePicker.presentTime(in: self, with: self)
        }
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
        viewModel.date.value = date
        pickerType = nil
    }
    
    func simpleDatePickerDidDismiss(withTime date: Date!) {
        if pickerType == .timeFrom {
            viewModel.timeFrom.value = date
        } else {
            viewModel.timeUntil.value = date
        }
        pickerType = nil
    }
    
    func simpleDatePickerDidDismiss() {
        pickerType = nil
    }
    
    func simpleDatePickerValueChanged(_ date: Date!) {
        
    }
    
}
