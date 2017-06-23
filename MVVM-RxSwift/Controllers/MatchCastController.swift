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
    
    private var btnRefresh: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
    var viewModel: MatchCastViewModel!
    private let disposeBag = DisposeBag()
    
    public var matchID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVisuals()
        configureBindings()
        viewModel.getData(refreshDriver: btnRefresh.rx.tap.asDriver(), matchID: matchID!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setRightBarButton(btnRefresh, animated: true)
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
        
        viewModel.errorMessage.asDriver().drive(onNext: { error in
            if let errorMessage = error {
                self.showDialog("Error", message: errorMessage, cancelButtonTitle: "Ok")
            }
        }).disposed(by: disposeBag)
        viewModel.homeTeam.asDriver().drive(self.lblHomeTeam.rx.text).disposed(by: disposeBag)
        viewModel.guestTeam.asDriver().drive(self.lblGuestTeam.rx.text).disposed(by: disposeBag)
        viewModel.result.asDriver().drive(self.lblResult.rx.text).disposed(by: disposeBag)
    }
    
}

extension MatchCastController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentarCell")!
        let viewCellModel = viewModel.viewModelFor(section: indexPath.section, row: indexPath.row)
        cell.textLabel?.text = viewCellModel.title
        cell.detailTextLabel?.text = viewCellModel.time
        return cell
    }
}
