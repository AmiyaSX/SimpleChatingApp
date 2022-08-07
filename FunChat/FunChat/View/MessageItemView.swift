//
//  MessageItemView.swift
//  FunChat
//
//  Created by iOS 打包机 on 2022/8/6.
//

import SwiftUI

struct MessageItemView: View {
    var crtMsg: Message
    var body: some View {
        
        if(crtMsg.isCurrentUser) {
            HStack(alignment: .top, spacing: 15) {
                Spacer()
                Text(crtMsg.content)
                    .padding(10)
                    .foregroundColor( Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                Image("account_male")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }.padding()
            } else {
                HStack(alignment: .top, spacing: 15) {
                    Image("account_female")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                    Text(crtMsg.content)
                        .padding(10)
                        .foregroundColor(Color.black)
                        .background( Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                        .cornerRadius(10)
                    Spacer()
                }.padding()
            }
            
    }
}
