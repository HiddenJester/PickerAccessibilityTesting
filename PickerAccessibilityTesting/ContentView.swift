//
//  ContentView.swift
//  PickerAccessibilityTesting
//
//  Created by Timothy Sanders on 2020-10-01.
//

import SwiftUI

struct ContentView: View {
    struct PickerContent: Identifiable {
        let id: UUID = UUID()

        /// The text to display for the picker item.
        let text: String

        /// The accessibilityLabel to use for the picker item. Note that the segmented picker will only use this after a control has been activated.
        let accessibility: String
    }

    /// Standardized content to use in multiple pickers with different styles.
    let pickerContent: [PickerContent] = [
        PickerContent(text: "Red", accessibility: "The first item"),
        PickerContent(text: "Blue", accessibility: "The second item"),
        PickerContent(text: "Green", accessibility: "The third item"),
    ]

    /// The backing to use for the default styled picker.
    @State
    private var defaultPickerSelection = UUID()

    /// The backing to use for the segmented picker.
    @State
    private var segmentedPickerSelection = UUID()

    /// This toggle doesn't *do* anything meaningful, but just activating the control changes the accessibility labels used by the segmented picker.
    @State
    private var uselessToggleBacking = false

    var body: some View {
        ScrollView {
            // A sample control to see the behavior change.
            Toggle("Useless Toggle", isOn: $uselessToggleBacking)

            // This default style picker will *always* use the provided accessibility labels.
            pickerView(title: "Default",
                       selectedElementID: $defaultPickerSelection,
                       style: DefaultPickerStyle())

            // This segmented-style picker will only use the accessibility labels provided *after* a control is
            // activated. Note you can even use the segmented control itself: just change the selection and it will
            // change which labels are used.
            pickerView(title: "Segmented",
                       selectedElementID: $segmentedPickerSelection,
                       style: SegmentedPickerStyle())
        }
    }
}

private extension ContentView {
    /// Creates a common standardized `Picker` content for a given `PickerContent`
    /// - Parameter forContent: the `PickerContent` used to create the `Text` element.
    /// - Returns: A `Text` view containing the content's text, with the content's ID and the accessibility label from the content provided.
    func pickerElementView(forContent content: PickerContent) -> some View {
        Text(content.text)
            // ⬇️ Only works in the segmented Picker if you activate a control first.
            .accessibilityLabel(content.accessibility)
            .tag(content.id)
    }

    /// Takes a UUID and returns the matching content name, or returns "No Selection" if there is no match
    /// - Parameter forElementID: the ID to search `pickerContent` for.
    /// - Returns: A `Text` view with either the text of the matching content, or just "No selection"
    func nameView(forElementID: UUID) -> some View {
        if let content = pickerContent.first(where: { $0.id == forElementID }) {
            return Text(content.text)
        } else {
            return Text("No selection")
        }
    }

    /// Creates a `Picker` with a title and the provided style.
    /// - Parameters:
    ///   - title: The title to display above the picker.
    ///   - selectedElementID: A `Binding<UUID>` to store the picker selection in.
    ///   - style: the `PickerStyle` to use on the `Picker`
    /// - Returns: a `VStack` with the `Picker` in the provided style, and a `Text` displaying the current selection.
    func pickerView<Style: PickerStyle>(title: String,
                                        selectedElementID: Binding<UUID>,
                                        style: Style) -> some View {
        VStack {
            Text(title)
                .font(.title)

            HStack {
                Text("Current Selection: ")

                nameView(forElementID: selectedElementID.wrappedValue)
            }
            .accessibilityElement(children: .combine)

            Picker(title, selection: selectedElementID) {
                ForEach(pickerContent) { pickerElementView(forContent: $0) }
            }
            .pickerStyle(style)
        }
        .background(Color(UIColor.systemFill))
        .overlay(Rectangle().stroke(lineWidth: 2))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
