//
//  ContentView.swift
//  ExternalLinkAccountSample
//
//  Created by Vineet Choudhary on 12/08/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
	let url = URL(string: "https://developerinsider.co/#/portal/signin")!
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
				.resizable()
				.frame(width: 70, height: 70)

            Text("Create or manage your account on the web.")
				.font(.title)
				.padding(.vertical, 10)
				.multilineTextAlignment(.center)

			Text(url.absoluteString)
				.font(.headline)
				.foregroundColor(.blue)
				.underline()
				.onTapGesture {
					Task(priority: .userInitiated) {
						await openManageAccountLink()
					}
				}
        }
        .padding()
    }

	func openManageAccountLink() async {
		// Make sure the client can make payment
		guard SKPaymentQueue.canMakePayments() else {
			return
		}

		if #available(iOS 16.0, *) {
			// this will return false in case the website link is not available in Info.plist
			guard await ExternalLinkAccount.canOpen else {
				return
			}

			do {
				try await ExternalLinkAccount.open()
			} catch {
				dump("Error - \(error)")
			}
		} else {
			// for device running earlier version of iOS 16.0, iPadOS 16.0 and tvOS 16.4
			// you'll need to implement the modal sheet by following the exactly the modal
			// sheet's design and text provided here -
			// https://developer.apple.com/support/downloads/Reader_App_Modal_Specifications.zip
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
