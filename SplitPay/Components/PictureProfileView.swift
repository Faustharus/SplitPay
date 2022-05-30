//
//  PictureProfileView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 30/05/2022.
//

import SwiftUI

struct PictureProfileView: View {
    
    typealias ActionHandler = () -> Void
    
    @Binding var inputPicture: UIImage?
    @Binding var picture: Image?
    let handler: ActionHandler
    
    init(inputPicture: Binding<UIImage?>, picture: Binding<Image?>, handler: @escaping PictureProfileView.ActionHandler) {
        self._inputPicture = inputPicture
        self._picture = picture
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            ZStack {
                Rectangle()
                    .fill(.secondary)
                    .opacity(0.5)
                
                VStack(spacing: 20) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.headline.weight(.bold))
                        .font(.system(size: 50, weight: .bold, design: .serif))
                    Text("Insert your profile \n picture here")
                        .font(.headline.weight(.bold))
                        .multilineTextAlignment(.center)
                }
                
                picture?
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .padding(.all, 10)
            
        })
        .buttonStyle(.plain)
    }
}

struct PictureProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PictureProfileView(inputPicture: .constant(UIImage(contentsOfFile: "")), picture: .constant(Image(""))) { }
            .previewLayout(.sizeThatFits)
    }
}
