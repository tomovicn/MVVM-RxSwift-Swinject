//
//  MatchCell.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func didPressedFavorite(cell: MatchCell)
}

class MatchCell: UITableViewCell, Reusable {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblHomeTeam: UILabel!
    @IBOutlet var lblGuestTeam: UILabel!
    @IBOutlet var lblHomeYellowCards: UILabel!
    @IBOutlet var lblGuestYellowCards: UILabel!
    @IBOutlet var lblHomeRedCards: UILabel!
    @IBOutlet var lblGuestRedCards: UILabel!
    @IBOutlet var lblHomeScoreFirstHalf: UILabel!
    @IBOutlet var lblGuestScoreFirstHalf: UILabel!
    @IBOutlet var lblHomeScore: UILabel!
    @IBOutlet var lblGuestScore: UILabel!
    @IBOutlet var lblHomeShooters: UILabel!
    @IBOutlet var lblGuestShooters: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    var delegate: CellDelegate?
    var viewCellModel: MatchCellViewModel = MatchCellViewModelFromMatch(withMatch: Match()) {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        lblTime.text = ""
        lblHomeTeam.text = ""
        lblGuestTeam.text = ""
        lblHomeYellowCards.text = "-"
        lblGuestYellowCards.text = "-"
        lblHomeRedCards.text = "-"
        lblGuestRedCards.text = "-"
        lblHomeScoreFirstHalf.text = "-"
        lblGuestScoreFirstHalf.text = "-"
        lblHomeScore.text = "-"
        lblGuestScore.text = "-"
        lblHomeShooters.text = ""
        lblGuestShooters.text = ""
    }
    
    func configureCell() {
        lblTime.text = viewCellModel.matchTime
        lblHomeTeam.text = viewCellModel.homeTeam
        lblGuestTeam.text = viewCellModel.guestTeam
        lblHomeYellowCards.text = viewCellModel.homeYellowCards
        lblGuestYellowCards.text = viewCellModel.guestYellowCards
        lblHomeRedCards.text = viewCellModel.homeRedCards
        lblGuestRedCards.text = viewCellModel.guestRedCards
        lblHomeScoreFirstHalf.text = viewCellModel.homeScoreFirstHalf
        lblGuestScoreFirstHalf.text = viewCellModel.guestScoreFirstHalf
        lblHomeScore.text = viewCellModel.homeScore
        lblGuestScore.text = viewCellModel.guestScore
        lblHomeShooters.text = viewCellModel.homeShooters
        lblGuestShooters.text = viewCellModel.guestShooters
        if viewCellModel.isFavorite {
            btnFavourite.setImage(UIImage.init(named: "favoritesSelected"), for: .normal)
        } else {
            btnFavourite.setImage(UIImage.init(named: "favoritesUnselected"), for: .normal)
        }
    }
    
    @IBAction func favoriteAction(_ sender: AnyObject) {
        delegate?.didPressedFavorite(cell: self)
    }
}
