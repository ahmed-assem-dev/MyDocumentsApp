//
//  pdfView.swift
//  ExploringFileManager
//
//  Created by Assem on 11/07/2023.
//

import SwiftUI
import PDFKit

let pdfUrl = Bundle.main.url(forResource: "part", withExtension: "pdf")!
struct pdfView: View {
    @Binding var pdfUrl: URL
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            PDFKitView(url: pdfUrl)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarItems(trailing: Button("Close") {
                                    self.isPresented = false
                                })
        }
    }
}
struct PDFKitView: UIViewRepresentable {
    let url: URL // new variable to get the URL of the document
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        // Creating a new PDFVIew and adding a document to it
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        // we will leave this empty as we don't need to update the PDF
    }
}

struct pdfView_Previews: PreviewProvider {
    static var previews: some View {
        pdfView(pdfUrl: .constant(pdfUrl), isPresented: .constant(false))
    }
}
