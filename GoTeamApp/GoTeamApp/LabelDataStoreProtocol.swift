//
//  LabelDataStoreProtocol.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//


import Foundation

protocol LabelDataStoreServiceProtocol {

    func add(label : Labels);
    func delete(label : Labels);
    func allLabels(success:@escaping ([Labels]) -> (), error: @escaping ((Error) -> ()));
}
