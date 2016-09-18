//
//  PGHealthKitManager.swift
//  PandaFit
//
//  Created by Felix Sonntag on 16/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import UIKit
import HealthKit

class PGHealthKitManager: NSObject {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    var authorized = false
    
    func authorizeHealthKit(completion: ((_ success:Bool, _ error:NSError?) -> Void)!) {
        // 1. Set the types you want to read from HK Store

        
        let healthKitTypesToRead:Set<HKQuantityType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!]
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "de.sonntag.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if (completion != nil) {
                completion(false, error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        
        healthKitStore.requestAuthorization(toShare: Set(), read: healthKitTypesToRead) { (success, error) in
            if (completion != nil) {
                self.authorized = success
                completion!(success, error as NSError?)
            }
        }
        
    }
    
    func retrieve(quantityTypeIdentifier: HKQuantityTypeIdentifier, completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        if self.authorized == true {
            let key = "\(quantityTypeIdentifier)"
            
            var startDate: Date? = nil
            
            if let lastDate = UserDefaults.standard.value(forKey: key) as? Date {
                
                startDate = lastDate
                
            } else {
                let calendar = Calendar.current
                startDate = calendar.date(byAdding: .day, value: -365, to: Date())
            }
            
            //   Define the Step Quantity Type
            let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
            
            //   Get the start of the day
            let now = Date()
            //        TODO  should be set to now and not to nil in production
//            UserDefaults.standard.set(nil, forKey: key)
            
            
            //  Set the Predicates & Interval
            print("Getting steps between \(startDate!) and \(now)")
            let predicate = HKQuery.predicateForSamples(withStart: startDate!, end: now, options: .strictStartDate)
            let interval: NSDateComponents = NSDateComponents()
            interval.day = 365
            
            //  Perform the Query
            let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate!, intervalComponents:interval as DateComponents)
            
            query.initialResultsHandler = { query, results, error in
                
                if error != nil {
                    
                    print("Couldn't retrieve steps")
                    print(error)
                    return
                }
                
                if let myResults = results {
                    myResults.enumerateStatistics(from: startDate!, to: now) {
                        statistics, stop in
                        
                        if let quantity = statistics.sumQuantity() {
                            UserDefaults.standard.set(now, forKey: key)
                            
                            let quantity = quantity.doubleValue(for: HKUnit.count())
                            
                            print("Quantity = \(quantity)")
                            completion(quantity)
                        } else {
                            print("Couldn't get quantity")
                        }
                        
                    }
                } else {
//                    no results
                    print("No results for getting steps")
                }
            }
            
            healthKitStore.execute(query)
        
        
        } else {
            print("HealthKit not authorized")
        }
        
        
    }

}
