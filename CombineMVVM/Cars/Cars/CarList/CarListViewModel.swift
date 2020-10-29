
//
//  CarListModel.swift
//  Cars
//
//  Created by Ravi Vora on 29/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import Combine

enum CarListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

final class CarListViewModel {
    @Published var fetchCars: String = ""
    @Published private(set) var carsViewModels: [CarCellViewModel] = []
    @Published private(set) var state: CarListViewModelState = .loading
    
    private let carsService: CarListServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(carsService: CarListServiceProtocol = CarsService()) {
        self.carsService = carsService
        
        $fetchCars
            .sink { [weak self] in self?.fetchCars(with: $0) }
            .store(in: &bindings)
    }
    
    func fetchCars(with searchTerm: String?) {
        state = .loading
        
        let fetchCarCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error): self?.state = .error(error)
            case .finished: self?.state = .finishedLoading
            }
        }
        
        let fetchCarValueHandler: ([Car]) -> Void = { [weak self] cars in
            self?.carsViewModels = cars.map { CarCellViewModel(car: $0) }
        }
        
        carsService
            .get()
            .sink(receiveCompletion: fetchCarCompletionHandler, receiveValue: fetchCarValueHandler)
            .store(in: &bindings)
    }
}
