//
//  SwiftUIView.swift
//  LAPTOPNVN
//
//  Created by Nhat on 04/11/2022.
//

import SwiftUI

struct ChatBot: View {
    @State private var messageText = ""
    @State var messages: [String] = ["Chào mừng bạn đến với Chatbot"]
    var body: some View {
        VStack {
            HStack {
                Text ("ChatBot")
                    .font (.largeTitle)
                    .bold()
                Image (systemName: "bubble.left.fill")
                    .font (. system (size: 26))
                    .foregroundColor (Color .blue)
            }
            ScrollView {
                ForEach (messages, id: \.self){
                    message in
                    if message.contains("[USER]"){
                        let newMess = message.replacingOccurrences(of: "[USER]", with: "")
                        HStack {
                            Spacer()
                            if #available(iOS 15.0, *) {
                                Text(newMess)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(.blue.opacity(0.8))
                                    .cornerRadius(20)
                                    .padding(.horizontal,16)
                                    .padding(.bottom,10)
                            } else {  }
                        }
                    }else {
                        HStack {
                            if #available(iOS 15.0, *) {
                                Text(message)
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(.gray.opacity(0.15))
                                    .cornerRadius(20)
                                    .padding(.horizontal,16)
                                    .padding(.bottom,10)
                                    .onSubmit {
//                                        if message.contains("cool") {
//                                            let vc = DetailHistoryViewController()
//                                            self.navigationController?.pushViewController(vc, animated: true)
//                                        }
                                    }
                            } else {  }
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
                .background(Color.gray.opacity(0.10))
                .cornerRadius(20)
            HStack {
                if #available(iOS 15.0, *) {
                    TextField("Type something", text: $messageText)
                        .padding ()
                        .background (Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onSubmit {
                            //Send Message
                            sendMessage(message: messageText)
                        }
                } else {
                    // Fallback on earlier versions
                }
                
                Button {
                    //Send Message
                    sendMessage(message: messageText)
                } label: {
                    Image (systemName: "paperplane.fill")
                }
                .font(.system(size: 26))
                .padding (.horizontal, 10)
                .padding()
            }
        }
        
    }
    
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                messages.append(getBotResponse (message: message))
            }
        }
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBot()
    }
}
