/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`AppleMusicManager` manages creating making the Apple Music API calls for the `MediaSearchTableViewController`.
*/

import Foundation
import StoreKit
import UIKit

class AppleMusicManager {
    
    // MARK: Types

    /// The completion handler that is called when an Apple Music Catalog Search API call completes.
    typealias CatalogSearchCompletionHandler = (_ mediaItems: [[MediaItem]], _ error: Error?) -> Void
    
    /// The completion handler that is called when an Apple Music Get User Storefront API call completes.
    typealias GetUserStorefrontCompletionHandler = (_ storefront: String?, _ error: Error?) -> Void
    
    /// The completion handler that is called when an Apple Music Get Recently Played API call completes.
    typealias GetRecentlyPlayedCompletionHandler = (_ mediaItems: [MediaItem], _ error: Error?) -> Void
    
    // MARK: Properties
    
    /// The instance of `URLSession` that is going to be used for making network calls.
    lazy var urlSession: URLSession = {
        // Configure the `URLSession` instance that is going to be used for making network calls.
        let urlSessionConfiguration = URLSessionConfiguration.default
        
        return URLSession(configuration: urlSessionConfiguration)
    }()
    
    /// The storefront id that is used when making Apple Music API calls.
    var storefrontID: String?
    
    func fetchDeveloperToken() -> String {
        
        // MARK: ADAPT: YOU MUST IMPLEMENT THIS METHOD
        let developerAuthenticationToken: String = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Iks0TDM1V1I1SjUifQ.eyJpc3MiOiIyM0ZDNVcyODVFIiwiaWF0IjoxNTIyMjMwMjk1LCJleHAiOjE1NDU5ODA4OTJ9.O6nbr22Ig_9ZX8cz04SY7pal9MaDXQN0noprAiRzeeJ44VeTeZMP37o1mlS5dmw3eQfPZCK7h5g9AlHG__gUew"
        return developerAuthenticationToken
    }
    
//    func getJWT(){
//
//        let header = JWTHeader()
//        header.typ = "JWT"
//        header.alg = "ES256"
//        header.kid = "K4L35WR5J5"
//
//        var claims = JWTClaim()
//        IssuerClaim.value = "23FC5W285E"
//        IssuedAtClaim.value = Date()
//        var components = DateComponents()
//        components.setValue(7, for: .month)
//        let date: Date = Date()sign
//        let expirationDate = Calendar.current.date(byAdding: components, to: date)
//        ExpirationClaim.Value = expirationDate
//
//        var payload = JWTPayload()
//
//
//
//    }
    
    // MARK: General Apple Music API Methods
    
    func performAppleMusicCatalogSearch(with term: String, countryCode: String, completion: @escaping CatalogSearchCompletionHandler) {
        
         let developerToken = fetchDeveloperToken()

        let urlRequest = AppleMusicRequestFactory.createSearchRequest(with: term, countryCode: countryCode, developerToken: developerToken)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion([], error)
                return
            }
            
            do {
                let mediaItems = try self.processMediaItemSections(from: data!)
                completion(mediaItems, nil)
                
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func performAppleMusicStorefrontsLookup(regionCode: String, completion: @escaping GetUserStorefrontCompletionHandler) {
        let developerToken = fetchDeveloperToken()
        let urlRequest = AppleMusicRequestFactory.createStorefrontsRequest(regionCode: regionCode, developerToken: developerToken)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            do {
                let identifier = try self?.processStorefront(from: data!)
                
                completion(identifier, nil)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // MARK: Personalized Apple Music API Methods
    
    func performAppleMusicGetRecentlyPlayed(userToken: String, completion: @escaping GetRecentlyPlayedCompletionHandler) {
        let developerToken = fetchDeveloperToken()
        let urlRequest = AppleMusicRequestFactory.createRecentlyPlayedRequest(developerToken: developerToken, userToken: userToken)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion([], error)
                
                return
            }
            
            do {
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                    let results = jsonDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] else {
                        throw SerializationError.missing(ResponseRootJSONKeys.data)
                }
                
                let mediaItems = try self.processMediaItems(from: results)
                
                completion(mediaItems, nil)
                
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func performAppleMusicGetUserStorefront(userToken: String, completion: @escaping GetUserStorefrontCompletionHandler) {
        let developerToken = fetchDeveloperToken()
        let urlRequest = AppleMusicRequestFactory.createGetUserStorefrontRequest(developerToken: developerToken, userToken: userToken)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                let error = NSError(domain: "AppleMusicManagerErrorDomain", code: -9000, userInfo: [NSUnderlyingErrorKey: error!])
                
                completion(nil, error)
                
                return
            }
            
            do {
                
                let identifier = try self?.processStorefront(from: data!)
                
                completion(identifier, nil)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func processMediaItemSections(from json: Data) throws -> [[MediaItem]] {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any],
            let results = jsonDictionary[ResponseRootJSONKeys.results] as? [String: [String: Any]] else {
                throw SerializationError.missing(ResponseRootJSONKeys.results)
        }
        
        var mediaItems = [[MediaItem]]()
        
        if let songsDictionary = results[ResourceTypeJSONKeys.songs] {
            
            if let dataArray = songsDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] {
                let songMediaItems = try processMediaItems(from: dataArray)
                mediaItems.append(songMediaItems)
            }
        }
        
        if let albumsDictionary = results[ResourceTypeJSONKeys.albums] {
            
            if let dataArray = albumsDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] {
                let albumMediaItems = try processMediaItems(from: dataArray)
                mediaItems.append(albumMediaItems)
            }
        }
        
        return mediaItems
    }
    
    func processMediaItems(from json: [[String: Any]]) throws -> [MediaItem] {
        let songMediaItems = try json.map { try MediaItem(json: $0) }
        return songMediaItems
    }
    
    func processStorefront(from json: Data) throws -> String {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any],
            let data = jsonDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] else {
                throw SerializationError.missing(ResponseRootJSONKeys.data)
        }
        
        guard let identifier = data.first?[ResourceJSONKeys.identifier] as? String else {
            throw SerializationError.missing(ResourceJSONKeys.identifier)
        }
        
        return identifier
    }
}
