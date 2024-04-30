# Sciflare-Tech-Task

This iOS application is designed to demonstrate the integration of various functionalities including fetching data from an API, storing it locally using Core Data, editing/updating existing data, adding new user data, and displaying the user's location on a map.

# Users Screen

The Users screen is responsible for fetching data from the provided API endpoint and storing it locally using Core Data. It displays the most recent data stored in Core Data in a table view.

# Register/Edit Screen

The Register/Edit screen allows users to perform two main actions:

Edit: Users can edit or update existing data by selecting the edit button from the table view row. This triggers a PUT request to update the data on the server.
Register: Users can create new user data by clicking the "New" button. This action sends a POST request to the server to create new user data.

# Location Screen

The Location functionality displays the user's current location on a map. It includes the following features:

Annotated Pin: The user's current location is marked with an annotation pin on the map.
Latitude and Longitude: The latitude and longitude values of the user's current location are displayed in a label.


Clone the repository.
Open the project in Xcode.
Build and run the application on a simulator or physical device.
