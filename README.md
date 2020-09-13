

tDisc


Version 1.0
________________________________________


Build and Runtime Requirements
_______________________________________

-   Xcode  >= v11.6
-   python l>=3.7
-   virtualenv


Configuring the Project
________________________
    1. Download repo onto your local machine
    2. Open the folder "tDisc" in Xcode
    3. $cd tDisc_api/discGolfApp/
    4. $source env/bin/activate
    5. $cd discGolfApp/
    6. $python manage.py runserver
    7. In Xcode start your simulation on an >= iPhone 11
    8. Create a new account, sign in, and start playing.


About tDisc
_____________
    tDisc is an iPhone application for disc golf scoring. It is easy to quickly create an account and get started playing!
    Select a course from the Rochester, NY or Buffalo, NY area either by name of location. Get information about the course and holes you are playing and save your scores as you go. 


Tech Stack
______________
    Swift 
    UIKit
    MapKit
    Python
    Django API Framework
    SQLite3 database
    

Application Architexture
________________
    This application consists of the API built in Python and Django and the front end built in Swift using UIKit and MapKit.
    The Django backend maintains and serves course information and user data.
    Swift and UIKit create a simple user interface.


