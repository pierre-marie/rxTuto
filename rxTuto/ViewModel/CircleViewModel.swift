//
//  BindingsViewModel.swift
//  rxTuto
//
//  Created by pierre-marie de jaureguiberry on 6/4/18.
//  Copyright © 2018 pm. All rights reserved.
//

import ChameleonFramework
import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {
    
    var centerVariable = Variable<CGPoint?>(.zero)
    var backgroundColorObservable: Observable<UIColor>!
    
    init() {
        setup()
    }
    
    func setup() {
        
        // When we get new center, emit new UIColor
        backgroundColorObservable = centerVariable.asObservable()
            .map({ center in
                guard let center = center else { return UIColor.flatten(.black)() }
                
                let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
            })
    }
}
