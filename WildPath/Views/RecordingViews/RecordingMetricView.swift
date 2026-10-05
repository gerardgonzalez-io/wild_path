import SwiftUI

struct RecordingMetricView: View
{
    let distance: Double
    let duration: TimeInterval
    let pointCount: Int

    var body: some View
    {
        HStack
        {
            metric(title: "Distance", value: distanceText)
            Spacer()
            metric(title: "Duration", value: durationText)
            Spacer()
            metric(title: "Points", value: pointCount.formatted())
        }
        .padding()
    }
}

extension RecordingMetricView
{
    private var distanceText: String
    {
        Measurement(value: distance, unit: UnitLength.meters)
            .formatted(.measurement(width: .abbreviated))
    }

    private var durationText: String
    {
        Duration.seconds(duration)
            .formatted(.time(pattern: .hourMinuteSecond))
    }

    private func metric(title: LocalizedStringKey, value: String) -> some View
    {
        VStack(spacing: 4)
        {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)
        }
    }
}

#Preview
{
    RecordingMetricView(
        distance: 2_400,
        duration: 1_938,
        pointCount: 248
    )
}
