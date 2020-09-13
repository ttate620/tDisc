Django REST API for disc golf courses in Rochester, NY.

    GET:

        + Get all courses:
            'http://127.0.0.1:8000/courses/'

        + Get course by course ID (<courseID>):
            'http://127.0.0.1:8000/courses/COURSE-ID=<courseID>/'

    DELETE:
        + Delete course by course ID (<courseID>):
            'http://127.0.0.1:8000/courses/COURSE-ID=<courseID>/'
            
    PUT:
        + create new course
        'http://127.0.0.1:8000/courses/CREATE/' (do this as post instead)
            'http://127.0.0.1:8000/courses/CREATE/NAME=<name>&ADDRESS=<addr>&CITY=<city>&STATE=<state>&ZIP=<zip>/'


User Management
    Login: api/accounts ;  POST request : "username", "email", "password"

Game:
    All Games : "http://127.0.0.1:8000/games/" with GET 
    All games of certain User" "http://127.0.0.1:8000/games/USER-ID=<Int>/" with GET
    Game Detail:  "http://127.0.0.1:8000/games/GAME-ID=<Int>/" with GET 
    Create : "http://127.0.0.1:8000/games/create/" with POST {"courseID": <Int> , "userID": <Int>}
    Delete : "http://127.0.0.1:8000/games/delete/" with POST {"gameID":<Int>}
    Update : "http://127.0.0.1:8000/games/update/" with PUT {"gameID":<Int>, "hole":<Int>, "score":<Int>}