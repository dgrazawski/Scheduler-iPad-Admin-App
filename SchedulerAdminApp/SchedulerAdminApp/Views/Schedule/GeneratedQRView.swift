//
//  GeneratedQRView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 17/02/2024.
//

import SwiftUI

struct generatedQR: View {
    var qrGenerator: QRCodeGeneratorService = QRCodeGeneratorService()
    let stringToGenerateCode: String
    let multiplier: Int
    var body: some View {
        Image(uiImage: qrGenerator.generateQR(from: stringToGenerateCode))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: CGFloat(multiplier) * 100, height: CGFloat(multiplier) * 100)
    }
}

struct GeneratedQRView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.displayScale) var scale
    @State private var multiplier: Int = 2
    var scheduleName: String
    var scheduleYear: Int
    var stringToGenerateCode: String
    
    
    var qrGenerator: QRCodeGeneratorService = QRCodeGeneratorService()
    var saver: SaveImageToDeviceService = SaveImageToDeviceService()
    
    var body: some View {
        NavigationStack {
            VStack{
                Image(uiImage: qrGenerator.generateQR(from: stringToGenerateCode))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: CGFloat(multiplier) * 100, height: CGFloat(multiplier) * 100)
                    .onAppear{
                        qrGenerator.generated = Image(uiImage: qrGenerator.generateQR(from: stringToGenerateCode))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: CGFloat(multiplier) * 100, height: CGFloat(multiplier) * 100)
                    }
                HStack {
                    Text("Size multiplier: ")
                    Picker("Multiplier", selection: $multiplier) {
                        ForEach(1...4, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                

                Button("Save QR", systemImage: "square.and.arrow.down") {
                    let codeToSave = Image(uiImage: qrGenerator.generateQR(from: stringToGenerateCode))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: CGFloat(multiplier) * 100, height: CGFloat(multiplier) * 100)
                        print("\(multiplier)")
                    let screenshot = codeToSave.screenShot()
                    saver.save(screenshot)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("QR Code for: \(scheduleName) - \(scheduleYear)")
        }
    }
    
 /*   @MainActor func render() {
            let renderer = ImageRenderer(content: RenderView(text: text))

            // make sure and use the correct display scale for this device
            renderer.scale = scale

            if let uiImage = renderer.uiImage {
                renderedImage = Image(uiImage: uiImage)
            }
        } */
}

#Preview {


        GeneratedQRView(scheduleName: "Informatyka", scheduleYear: 4, stringToGenerateCode: "77e417cf-d6a4-4358-994a-885841361ad4")
    
}
