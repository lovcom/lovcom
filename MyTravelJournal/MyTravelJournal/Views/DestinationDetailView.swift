/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CloudKit
import SwiftUI

struct DestinationDetailView: View {
  @ObservedObject var destination: Destination
  @State private var share: CKShare?
  @State private var showShareSheet = false
  @State private var showEditSheet = false
  private let stack = CoreDataStack.shared

  var body: some View {
    // swiftlint:disable trailing_closure
    List {
      Section {
        VStack(alignment: .leading, spacing: 4) {
          if let imageData = destination.image, let image = UIImage(data: imageData) {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
          }
          Text(destination.caption)
            .font(.headline)
          Text(destination.details)
            .font(.subheadline)
          Text(destination.createdAt.formatted(date: .abbreviated, time: .shortened))
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.bottom, 8)
        }
      }

      Section {
        if let share = share {
          ForEach(share.participants, id: \.self) { participant in
            VStack(alignment: .leading) {
              Text(participant.userIdentity.nameComponents?.formatted(.name(style: .long)) ?? "")
                .font(.headline)
              Text("Acceptance Status: \(string(for: participant.acceptanceStatus))")
                .font(.subheadline)
              Text("Role: \(string(for: participant.role))")
                .font(.subheadline)
              Text("Permissions: \(string(for: participant.permission))")
                .font(.subheadline)
            }
            .padding(.bottom, 8)
          }
        }
      } header: {
        Text("Participants")
      }
    }
    .sheet(isPresented: $showShareSheet, content: {
      if let share = share {
        CloudSharingView(share: share, container: stack.ckContainer, destination: destination)
      }
    })
    .sheet(isPresented: $showEditSheet, content: {
      EditDestinationView(destination: destination)
    })
    .onAppear(perform: {
      self.share = stack.getShare(destination)
    })
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showEditSheet.toggle()
        } label: {
          Text("Edit")
        }
        .disabled(!stack.canEdit(object: destination))
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          if !stack.isShared(object: destination) {
            Task {
              await createShare(destination)
            }
          }
          showShareSheet = true
        } label: {
          Image(systemName: "square.and.arrow.up")
        }
      }
    }
  }
}

// MARK: Returns CKShare participant permission, methods and properties to share
extension DestinationDetailView {
  private func createShare(_ destination: Destination) async {
    do {
      let (_, share, _) = try await stack.persistentContainer.share([destination], to: nil)
      share[CKShare.SystemFieldKey.title] = destination.caption
      self.share = share
    } catch {
      print("Failed to create share")
    }
  }

  private func string(for permission: CKShare.ParticipantPermission) -> String {
    switch permission {
    case .unknown:
      return "Unknown"
    case .none:
      return "None"
    case .readOnly:
      return "Read-Only"
    case .readWrite:
      return "Read-Write"
    @unknown default:
      fatalError("A new value added to CKShare.Participant.Permission")
    }
  }

  private func string(for role: CKShare.ParticipantRole) -> String {
    switch role {
    case .owner:
      return "Owner"
    case .privateUser:
      return "Private User"
    case .publicUser:
      return "Public User"
    case .unknown:
      return "Unknown"
    @unknown default:
      fatalError("A new value added to CKShare.Participant.Role")
    }
  }

  private func string(for acceptanceStatus: CKShare.ParticipantAcceptanceStatus) -> String {
    switch acceptanceStatus {
    case .accepted:
      return "Accepted"
    case .removed:
      return "Removed"
    case .pending:
      return "Invited"
    case .unknown:
      return "Unknown"
    @unknown default:
      fatalError("A new value added to CKShare.Participant.AcceptanceStatus")
    }
  }

  private var canEdit: Bool {
    stack.canEdit(object: destination)
  }
}
