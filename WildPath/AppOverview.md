# WildPath Overview

1. **How does the app help people reach a goal?**  
   It records a user’s route so they can track their outdoor activity and progress.

2. **What data does the app store?**  
   Routes and their location points, including coordinates, time, altitude, speed, course, accuracy, and stationary state.

3. **How does the app process the data?**  
   SwiftData loads the stored route points, Core Location tracks the user’s current position, and ARKit displays directions that guide them along the recorded route.

4. **What is the app’s source of truth?**  
   SwiftData is the source of truth for saved routes and route points.
