//
//  ContentView.swift
//  HelloML
//
//  Created by Gabriela Bezerra on 11/06/24.
//

import SwiftUI
import UIKit
import Vision
import NaturalLanguage

struct ContentView: View {

    let image: UIImage = UIImage(named: "mensagem")!

    @State var text: String = "Texto reconhecido aqui"

    @State var sentiment: String = "Resultado da análise de sentimento"

    var body: some View {
        Text("Reconhecimento de texto e análise de sentimento")
        List {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(text)
            Text(sentiment)
        }
        .onAppear {
            let imageData = image.jpegData(compressionQuality: 0.5)
            // código de ML aqui
            // VNRecognizeTextRequest https://developer.apple.com/documentation/vision/vnrecognizetextrequest
            
            // Criando uma solicitação de reconhecimento de texto
            let textRecognitionRequest = VNRecognizeTextRequest { request, error in
                // Verificando se há resultados de reconhecimento de texto
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    // Caso não haja resultados, imprime uma mensagem e sai da função
                    print("Nenhum resultado de texto reconhecido.")
                    return
                }
                
                // Processando as observações de texto
                let strings = observations.compactMap { observation in
                    // Extraindo a string de texto mais provável de cada observação
                    return observation.topCandidates(1).first?.string
                }
                
                // Atualizando a interface do usuário com o texto extraído
                DispatchQueue.main.async {
                    self.text = strings.joined(separator: "\n")
                }
            }

            // Configurando a solicitação de reconhecimento de texto
            textRecognitionRequest.recognitionLevel = .accurate // Define o nível de precisão
            textRecognitionRequest.recognitionLanguages = ["pt"] // Define os idiomas de reconhecimento
            textRecognitionRequest.usesLanguageCorrection = true // Ativa a correção ortográfica

            // Criando um manipulador de solicitação de imagem com os dados da imagem fornecida
            let requestHandler = VNImageRequestHandler(data: imageData!)
            // Executando a solicitação de reconhecimento de texto
            try? requestHandler.perform([textRecognitionRequest])

            // Sentiment Analysis https://developer.apple.com/documentation/naturallanguage/nltagscheme/3113856-sentimentscore        }
    }
}

#Preview {
    ContentView()
}
