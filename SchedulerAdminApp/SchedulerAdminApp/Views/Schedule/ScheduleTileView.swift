//
//  ScheduleTileView.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 07/01/2024.
//

import SwiftUI

struct AddScheduleTileView: View {
    var body: some View {
        VStack{
            Circle()
                .fill(.green)
                .frame(width: 100)
                .overlay {
                    Image(systemName: "plus").imageScale(.large).bold()
                    
                    .font(.title)
                        .foregroundColor(.white)
                }
            Text("ADD NEW ").bold().font(.title2)

        }
        .frame(width: 150, height: 200)
        .background()
        .cornerRadius(10)
        .shadow(color:.gray, radius: 10, x: 5, y: 5)
        
    }
}

struct ScheduleTileView: View {
     var title: String
     var year: String
    
    var body: some View {
        VStack{
            Circle()
                .fill(.mint)
                .frame(width: 100)
                .overlay {
                    Image(systemName: "calendar").imageScale(.large).bold()
                    
                    .font(.title)
                        .foregroundColor(.white)
                }
            Text(title).textCase(.uppercase)
            Text("YEAR \(year)").textCase(.uppercase)
        }
        .frame(width: 150, height: 200)
        .background()
        .cornerRadius(10)
        .shadow(color:.gray, radius: 10, x: 5, y: 5)
        
    }
}

struct ScheduleTileView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            AddScheduleTileView()
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            ScheduleTileView(title: "Informatyka", year: "II")
        }
        
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
