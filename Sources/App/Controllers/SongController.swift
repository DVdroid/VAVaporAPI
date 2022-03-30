//
//  SongController.swift
//  
//
//  Created by VA on 29/03/22.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let song = routes.grouped("songs")
        song.get(use: index)
        song.post(use: create)
        song.put(use: update)
        song.group(":songID") { song in
            song.delete(use: delete)
        }
    }
    
    // GET Request: /songs route
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST Request: /songs route
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
    
    //PUT Request: /song
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        
        return Song.find(song.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = song.title
                return $0.update(on: req.db)
                    .transform(to: .ok)
            }
    }
    
    //DELETE Request: /song/id
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
