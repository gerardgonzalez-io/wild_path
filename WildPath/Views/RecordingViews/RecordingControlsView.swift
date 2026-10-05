import SwiftUI

struct RecordingControlsView: View
{
    let recordingState: RecordingState
    let onStart: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    let onFinish: () -> Void

    var body: some View
    {
        HStack(spacing: 24)
        {
            switch recordingState
            {
            case .idle:
                Button(action: onStart)
                {
                    Label("Start", systemImage: "record.circle")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

            case .recording:
                Button(action: onPause)
                {
                    Label("Pause", systemImage: "pause.fill")
                }
                .buttonStyle(.bordered)

                finishButton

            case .paused:
                Button(action: onResume)
                {
                    Label("Resume", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                finishButton

            case .finished:
                Label("Finished", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding()
    }

    private var finishButton: some View
    {
        Button(action: onFinish)
        {
            Label("Finish", systemImage: "stop.fill")
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
}

#Preview
{
    RecordingControlsView(
        recordingState: .recording,
        onStart: {},
        onPause: {},
        onResume: {},
        onFinish: {}
    )
}
