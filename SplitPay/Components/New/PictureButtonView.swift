//
//  PictureButtonView.swift
//  SplitPay
//
//  Created by Damien Chailloleau on 15/06/2023.
//

import SwiftUI

struct PictureButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    @Binding var inputPicture: UIImage?
    @Binding var picture: Image?
    @Binding var tapPicture: Bool
    let handler: ActionHandler
    
    init(inputPicture: Binding<UIImage?>, picture: Binding<Image?>, tapPicture: Binding<Bool>, handler: @escaping PictureProfileView.ActionHandler) {
        self._inputPicture = inputPicture
        self._picture = picture
        self._tapPicture = tapPicture
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            ZStack {
                Circle()
                    .fill(.white.shadow(tapPicture ? .inner(color: .black, radius: 5, x: 2, y: 2) : .drop(color: .black, radius: 5, x: 1, y: 1)))
                    .frame(width: 100, height: 65)
                VStack {
                    if (picture != nil) {
                        picture?
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .clipShape(Circle())
                            .frame(width: 100, height: 65)
                    } else {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 25)
                            .font(.system(size: 20, weight: .medium, design: .default))
                    }
                }
            }
        })
        .buttonStyle(.plain)
        
    }
}

struct PictureButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PictureButtonView(inputPicture: .constant(UIImage(contentsOfFile: "")), picture: .constant(Image("")), tapPicture: .constant(false)) { }
    }
}
