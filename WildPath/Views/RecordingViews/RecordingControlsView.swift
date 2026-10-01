import SwiftUI

struct RecordingControlsView: View
{
    var body: some View
    {
        HStack(spacing: 24)
        {
            Button
            {
            } label:
            {
                Label("Start", systemImage: "record.circle")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)

            Button
            {
            } label:
            {
                Label("Pause", systemImage: "pause.fill")
            }
            .buttonStyle(.bordered)

            Button
            {
            } label:
            {
                Label("Stop", systemImage: "stop.fill")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding()
    }
}

#Preview
{
    RecordingControlsView()
}
