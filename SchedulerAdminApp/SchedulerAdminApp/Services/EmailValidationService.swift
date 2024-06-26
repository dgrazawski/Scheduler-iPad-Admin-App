//
//  EmailValidationService.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 30/04/2024.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
