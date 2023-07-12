//
//  ContentView.swift
//  ExploringFileManager
//
//  Created by Assem on 11/07/2023.
//

import SwiftUI
import ImageViewer


struct ContentView: View {
    let manager = FileManager.default
    @State var showImageViewer: Bool = false
    @State var image = Image("cat")
    @State var showPdfViewer: Bool = false
    @State var pdfUrl = Bundle.main.url(forResource: "part", withExtension: "pdf")!
    var body: some View {
        let files = getFiles()
        
        
        
        let layout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
        
        LazyVGrid(columns: layout){
            ForEach(files, id: \.self) { file in
                if (file[file.startIndex] != "."){
                    let isImage = (getExtension(fileName: file) == "png" || getExtension(fileName: file) == "jpeg" || getExtension(fileName: file) == "jpg")
                    let isPdf = getExtension(fileName: file) == "pdf"
                    Button{
                        if(isImage){
                            openImage(file: file)
                        }else if(isPdf){
                            showPdfViewer = true
                            pdfUrl = getPdfUrl(pdfName: file)
                            
                        }else{
                            print("File Not Supported")
                        }
                        
                    }label: {
                        VStack(spacing: 2){
                            let isFolder = (getExtension(fileName: file) == "folder")
                            
                            Text(getExtension(fileName:file))
                            Image(systemName: isFolder ? "folder" : "doc")
                            Text(getFileName(fileName:file))
                                .font(.caption)
                            
                        }
                        .frame(width: 50,height: 50)
                        .padding(5)
                        .background(Color("gray"))
                        .foregroundColor(.black)
                        .cornerRadius(5)
                    }
                    .sheet(isPresented: $showPdfViewer) {
                        pdfView(pdfUrl: $pdfUrl, isPresented: $showPdfViewer)
                    }
                    
                    
                }
            }
            Button("Show PDF") {
                    showPdfViewer = true
                        }
                        .sheet(isPresented: $showPdfViewer) {
                            pdfView(pdfUrl: $pdfUrl, isPresented: $showPdfViewer)
                        }
            
            .padding()
            
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(ImageViewer(image: $image, viewerShown: self.$showImageViewer))
        //        Image(uiImage: (UIImage(data: url) ?? UIImage(systemName: "person"))!)
        
        
        
    }
    func getFiles() -> [String]{
        let manager = FileManager.default
        
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return []
            
        }
        
        let newFilePath = url.appendingPathComponent("MyApp")
        let existingFiles = (try? manager.contentsOfDirectory(atPath: newFilePath.path())) ?? []
        
        return existingFiles
    }
    func getImgData(imgName:String) -> Data{
        let manager = FileManager.default
        
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return Data()
            
        }
        
        let newFilePath = url.appendingPathComponent("MyApp")
        let imageUrl = newFilePath.appendingPathComponent(imgName)
        do {
            let theData = try Data(contentsOf: imageUrl)
            return theData
            
        }
        
        catch{
            return Data()
        }
        
    }
    func getPdfUrl(pdfName:String) -> URL{
        let manager = FileManager.default
        
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return URL(fileURLWithPath: "")
            
        }
        
        let newFilePath = url.appendingPathComponent("MyApp")
        let pdfUrl = newFilePath.appendingPathComponent(pdfName)
        
        return pdfUrl
    }
    
    
    func getExtension(fileName: String) -> String{
        if let fileExtension = fileName.split(separator: ".").last {
            switch fileExtension.lowercased() {
            case "png":
                return("png")
            case "jpg", "jpeg":
                return("jpeg")
            case "pdf":
                return("pdf")
            case "gif":
                return("gif")
            default:
                return("folder")
            }
        } else {
            return("File name has no extension")
        }
    }
    func getFileName(fileName: String) -> String{
        if let name = fileName.split(separator: ".").first{
            return String(name)
        }else{
            return "unknown"
        }
    }
    func openImage(file:String){
        
        let imgData = getImgData(imgName: file)
        let newImage = Image(uiImage:  (UIImage(data: imgData) ?? UIImage(systemName: "person"))!)
        showImageViewer = true
        image = newImage
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

