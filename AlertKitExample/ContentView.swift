//
//  ContentView.swift
//  AlertKitExample
//
//  Created by Alex Nagy on 29.12.2020.
//

import SwiftUI
import AlertKit

class ContentViewModel: ObservableObject {
    
    func fetchData(completion: @escaping (Result<Bool, Error>) -> ()) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 4) {
            DispatchQueue.main.async {
                //                completion(.success(true))
                completion(.success(false))
                //                completion(.failure(NSError(domain: "Could not fetch data", code: 404, userInfo: nil)))
            }
        }
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @StateObject var alertManager = AlertManager()
    
    var body: some View {
//        Button("Show alert") {
//            viewModel.isPresented = true
//        }
//        .alert(isPresented: $viewModel.isPresented, content: {
//            Alert(title: Text("Alert"))
//        })
        Button("Tap me") {
//            alertManager.show(dismiss: .custom(title: "AlertKit alert", message: "Hello there", dismissButton: .default(Text("Ok"))))
//            alertManager.show(primarySecondary: .error(message: "Something went wrong", primaryButton: .destructive(Text("Ok")), secondaryButton: .cancel()))
            let buttons = [
                Alert.Button.default(Text("Retry"), action: {
                    fetchData()
                }),
                Alert.Button.destructive(Text("Abort")),
                Alert.Button.cancel(Text("Back"))
            ]
            alertManager.showActionSheet(.custom(title: "Alert Kit action sheet", message: "More than 2 buttons here", buttons: buttons))
        }
        .uses(alertManager)
        .onAppear(perform: {
            fetchData()
        })
    }
    
    func fetchData() {
        viewModel.fetchData { (result) in
            switch result {
            case .success(let finished):
                if finished {
                    alertManager.show(dismiss: .success(message: "Finished"))
                } else {
                    alertManager.show(primarySecondary: .custom(title: "Warning", message: "Something went wrong", primaryButton: Alert.Button.default(Text("Retry"), action: {
                        fetchData()
                    }), secondaryButton: .cancel()))
                }
            case .failure(let err):
                alertManager.show(dismiss: .error(message: err.localizedDescription))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
