//
//  QRCodeGeneratorService.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import Foundation
import CoreImage.CIFilterBuiltins
import SwiftUI


class QRCodeGeneratorService {
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    var generated: (any View)?
    
    init() {    }
    
    func generateQR(from scheduleCode: String) -> UIImage {
        filter.message = Data(scheduleCode.utf8)
        
        if let generatedCode = filter.outputImage {
            if let img = context.createCGImage(generatedCode, from: generatedCode.extent) {
                return UIImage(cgImage: img)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
}
