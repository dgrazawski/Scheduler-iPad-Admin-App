//
//  StripToNumberService.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 03/02/2024.
//

import Foundation


class StripToNumberService: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
