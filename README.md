# PickerAccessibilityTesting
Demonstrates a bug with SwiftUI `accessibilityLabel` when using `SegmentedPickerStyle()`. A `Picker` using the default style will properly read custom `accessibilityLabel` modifiers when VoiceOver reads the picker contents. A `Picker` using the segmented style will read the system standard labels after creation, until a control is activated. After a control is activated the segmented control will properly read the custom labels.

Demonstration:

1. Build and run the app on a device using VoiceOver

1. Tap the default picker, note that it reads the custom labels for the picker items ("The first item" and so on.)

1. Tap the segmented picker note that it reads the standard label, and will say something like "Blue, button 2 of 3".

1. Toggle the "Useless Toggle" at the top of the screen.

1. Note that the default picker's labels did not change, but the segmented picker now reads the custom ones and says things like "The first item, button, 1 of 3."

**NOTE:** Sometimes once you have activated a control relaunching the app simple reconnects to the altered scene. You may have to kill the app from multitasking in order to see the original behavior.
