//
//  TypeRow.swift
//  TET
//
//  Created by Raymond Li on 10/27/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class TypeRow: UIView  {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var plusButton: PlusButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TypeRow", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        typeLabel.adjustsFontSizeToFitWidth = true
        amountLabel.adjustsFontSizeToFitWidth = true
        //plusButton.tintColor = .black
    }
    
}

class PlusButton: UIButton {
    var type = ""
}
