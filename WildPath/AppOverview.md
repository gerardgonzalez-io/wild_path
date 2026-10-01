# WildPath Overview

1. **How does the app help people reach a goal?**  
   It records a user’s route so they can track their outdoor activity and progress.

2. **What data does the app store?**  
   Routes and their location points, including coordinates, time, altitude, speed, course, accuracy, and stationary state.

3. **How does the app process the data?**  
   It receives live location updates, converts them into route points, and groups them into a route.

4. **What is the app’s source of truth?**  
   SwiftData is the source of truth for saved routes and route points.
