import SwiftData
import SwiftUI

struct RecordingView: View
{
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var locationsHandler = LocationsHandler.shared
    @State private var viewModel = RecordingViewViewModel()
    @State private var isShowingSaveConfirmation = false
    @State private var dismissAfterSaveConfirmation = false

    var body: some View
    {
        VStack(spacing: 0)
        {
            RecordingMapView()
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(edges: .top)

            MetricView(
                distance: viewModel.distance,
                duration: viewModel.duration,
                pointCount: viewModel.pointCount
            )

            RecordingControlsView(
                recordingState: viewModel.recordingState,
                onStart: startRecording,
                onPause: pauseRecording,
                onResume: resumeRecording,
                onFinish: { finishRecording(shouldDismiss: false) }
            )
        }
        .navigationTitle("Record Route")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(viewModel.hasActiveRoute)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar
        {
            if viewModel.hasActiveRoute
            {
                ToolbarItem(placement: .topBarLeading)
                {
                    Button("Back", systemImage: "chevron.backward")
                    {
                        finishRecording(shouldDismiss: true)
                    }
                }
            }
        }
        .onChange(of: locationsHandler.count)
        {
            viewModel.record(
                location: locationsHandler.lastLocation,
                isStationary: locationsHandler.isStationary,
                using: locationsHandler,
                in: modelContext
            )
        }
        .alert("Route Saved", isPresented: $isShowingSaveConfirmation)
        {
            Button("OK")
            {
                if dismissAfterSaveConfirmation
                {
                    dismissAfterSaveConfirmation = false
                    dismiss()
                }
            }
        }
        message:
        {
            Text("Your route was saved successfully. You can rename it later from Saved Routes.")
        }
        .alert("Recording Error", isPresented: errorPresentation)
        {
            Button("OK")
            {
                viewModel.clearError()
            }
        } message:
        {
            Text(viewModel.errorMessage ?? "The route could not be saved.")
        }
    }
}

extension RecordingView
{
    private var errorPresentation: Binding<Bool>
    {
        Binding(
            get: { viewModel.errorMessage != nil },
            set:
            { isPresented in
                if !isPresented
                {
                    viewModel.clearError()
                }
            }
        )
    }

    private func startRecording()
    {
        viewModel.clearError()
        viewModel.startRecording(using: locationsHandler, in: modelContext)
    }

    private func pauseRecording()
    {
        viewModel.pauseRecording(using: locationsHandler, in: modelContext)
    }

    private func resumeRecording()
    {
        viewModel.resumeRecording(using: locationsHandler)
    }

    private func finishRecording(shouldDismiss: Bool)
    {
        viewModel.finishRecording(
            named: nil,
            using: locationsHandler,
            in: modelContext
        )

        guard !viewModel.hasActiveRoute, viewModel.errorMessage == nil
        else
        {
            return
        }

        dismissAfterSaveConfirmation = shouldDismiss
        isShowingSaveConfirmation = true
    }
}

#Preview
{
    NavigationStack
    {
        RecordingView()
    }
    .modelContainer(for: [Route.self, RoutePoint.self], inMemory: true)
}
