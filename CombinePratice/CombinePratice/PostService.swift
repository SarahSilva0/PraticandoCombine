//
//  PostService.swift
//  CombinePratice
//
//  Created by Sarah dos Santos Silva on 21/11/23.
//

import Foundation
import Combine

class PostService {
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!

    func fetchPosts() -> AnyPublisher<[Post], Error> {
        URLSession.shared.dataTaskPublisher(for: baseURL)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func addPost(title: String, body: String) -> AnyPublisher<Post, Error> {
        var newPost = Post(id: 0, title: title, body: body)
        let url = baseURL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(newPost)
            request.httpBody = jsonData
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Post.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func updatePost(post: Post) -> AnyPublisher<Post, Error> {
        let url = baseURL.appendingPathComponent("\(post.id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(post)
            request.httpBody = jsonData
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Post.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func deletePost(post: Post) -> AnyPublisher<Void, Error> {
        let url = baseURL.appendingPathComponent("\(post.id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { _, _ in return }
            .eraseToAnyPublisher()
    }
}
