import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @AppStorage("name") private var name: String = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress: String = "you@yoursite.com"
    
    let ciContext = CIContext()
    let qrCodeFilter = CIFilter.qrCodeGenerator()
    
    @State private var qrCodeUIImage: UIImage = UIImage()
    
    //MARK: Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 20.0) {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.name)
                    .keyboardType(.default)
                TextField("Email Address", text: $emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Image(
                    uiImage: qrCodeUIImage
                ).interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320.0, height: 320.0)
                    .contextMenu {
                        let image = Image(uiImage: qrCodeUIImage)
                        ShareLink(
                            item: image,
                            preview: SharePreview("My QR Code", image: image)
                        )
                    }
                Spacer()
            }.padding()
                .navigationTitle("Me")
                .onAppear(perform: updateQrCodeUIImage)
                .onChange(of: name, updateQrCodeUIImage)
                .onChange(of: emailAddress, updateQrCodeUIImage)
        }
    }
    
    private func updateQrCodeUIImage() {
        qrCodeUIImage = generateQrCodeUIImage(from: "\(name)\n\(emailAddress)")
    }
    
    private func generateQrCodeUIImage(from string: String) -> UIImage {
        qrCodeFilter.message = Data(string.utf8)
        if let outputCIImage = qrCodeFilter.outputImage {
            if let cgImage = ciContext.createCGImage(outputCIImage, from: outputCIImage.extent) {
                let uiImage = UIImage(cgImage: cgImage)
                return uiImage
            }
        }
        let uiImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        return uiImage
    }
}

#Preview {
    MeView()
}
