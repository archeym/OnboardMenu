//
//  NetworkResource.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

// This tiny type does ONE thing: model the lifecycle of async data
// It doesnt fetch, decode, or render UI, it only represents state
struct NetworkResource<Value> {
    enum State {
        case idle//Nothing has started yet.
        case loading(previous: Value?)//A network request is in progress, previous carries any stale value you had before starting the new request
        case success(Value)//The last request finished successfully and you now have fresh data
        case error(APIError)//The request failed with an APIError (bad status, decoding failed, offline)
    }

    var state: State = .idle
    
    init(state: State = .idle) {
        self.state = state
    }
}

extension NetworkResource {
    // These helpers only *read* the state and shape it for UI consumption.
    var isIdle: Bool {
        if case .idle = state { return true }
        return false
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    var error: APIError? {
        if case let .error(e) = state { return e }
        return nil
    }

    var value: Value? {
        if case let .success(v) = state { return v }
        return nil
    }
}

extension NetworkResource {

    func idle<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        Group {
            if isIdle { content() }
            else { EmptyView() }
        }
    }

    func loading<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        Group {
            if isLoading { content() }
            else { EmptyView() }
        }
    }

    func idleLoading<Content: View>(@ViewBuilder _ content: @escaping () -> Content) -> some View {
        Group {
            if isIdle || isLoading { content() }
            else { EmptyView() }
        }
    }

    func value<Content: View>(@ViewBuilder content: @escaping (Value) -> Content) -> some View {
        Group {
            if let v = self.value { content(v) }
            else { EmptyView() }
        }
    }

    func error<Content: View>(@ViewBuilder content: @escaping (APIError) -> Content) -> some View {
        Group {
            if let e = self.error { content(e) }
            else { EmptyView() }
        }
    }

    @ViewBuilder
    func idle<IdleContent: View, LoadingContent: View, ValueContent: View, ErrorContent: View>(
        @ViewBuilder _ idle: @escaping () -> IdleContent,
        @ViewBuilder loading: @escaping () -> LoadingContent,
        @ViewBuilder value: @escaping (Value) -> ValueContent,
        @ViewBuilder error: @escaping (APIError) -> ErrorContent
    ) -> some View {
        switch state {
        case .idle: idle()
        case .loading: loading()
        case let .success(v): value(v)
        case let .error(e): error(e)
        }
    }

    @ViewBuilder
    func idle<IdleContent: View, LoadingContent: View, ElseContent: View>(
        @ViewBuilder _ idle: @escaping () -> IdleContent,
        @ViewBuilder loading: @escaping () -> LoadingContent,
        @ViewBuilder `else`: @escaping (Value?) -> ElseContent
    ) -> some View {
        switch state {
        case .idle: idle()
        case .loading: loading()
        default: `else`(value)
        }
    }

    @ViewBuilder
    func loading<LoadingContent: View, ValueContent: View, ErrorContent: View>(
        @ViewBuilder _ loading: @escaping () -> LoadingContent,
        @ViewBuilder value: @escaping (Value) -> ValueContent,
        @ViewBuilder error: @escaping (APIError) -> ErrorContent
    ) -> some View {
        switch state {
        case .idle: EmptyView()
        case .loading: loading()
        case let .success(v): value(v)
        case let .error(e): error(e)
        }
    }

    @ViewBuilder
    func loading<LoadingContent: View, ElseContent: View>(
        @ViewBuilder _ loading: @escaping () -> LoadingContent,
        @ViewBuilder `else`: @escaping (Value?) -> ElseContent
    ) -> some View {
        switch state {
        case .idle: EmptyView()
        case .loading: loading()
        default: `else`(value)
        }
    }

    @ViewBuilder
    func value<ValueContent: View, ErrorContent: View>(
        @ViewBuilder _ value: @escaping (Value) -> ValueContent,
        @ViewBuilder error: @escaping (APIError?) -> ErrorContent
    ) -> some View {
        switch state {
        case .idle, .loading:
            EmptyView()
        case let .success(v):
            value(v)
        case .error:
            self.error.map(error)
        }
    }
}
