//
//  PostViewModel.swift
//  CombinePratice
//
//  Created by Sarah dos Santos Silva on 21/11/23.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let postService = PostService()

    @Published var posts: [Post] = []

    func fetchPosts() {
        postService.fetchPosts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] posts in
                    self?.posts = posts
                  })
            .store(in: &cancellables)
    }

    func addPost(title: String, body: String) {
        postService.addPost(title: title, body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] post in
                    self?.posts.append(post)
                  })
            .store(in: &cancellables)
    }

    func updatePost(post: Post) {
        postService.updatePost(post: post)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] updatedPost in
                    if let index = self?.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                        self?.posts[index] = updatedPost
                    }
                  })
            .store(in: &cancellables)
    }

    func deletePost(post: Post) {
        postService.deletePost(post: post)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in
                    self?.posts.removeAll(where: { $0.id == post.id })
                  })
            .store(in: &cancellables)
    }
}
