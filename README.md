# Demo - Fuel Station frontend
Small demo project for displaying and editing fuel stations.

## Setup
Download this git repo (https://github.com/whiteseppel/fuelStationFrontend) and 
install all dependencies with `flutter pub get`. You will have to enter the IP where
the backend service is running, as there currently is no option for entering the IP
at runtime. This can be done in `lib/injection_container.dart`. Afterwards you can 
run the application with `flutter run` or just start it in Android Studio or VS Code. 

You will also need to host the backend of this project for the app to display the
fuel stations correctly. All data is only loaded from the backend, there currently is 
no device persistence.
