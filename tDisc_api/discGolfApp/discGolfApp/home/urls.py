from rest_framework import routers
from django.urls import path, include
from . import views
from .views import CourseList, CourseDetail, CoursesByZip, CourseCreate, CourseHoleCreate, GameView, GameDetailView, GameCreateView, GameUpdateView, GameDeleteView, GameViewUser

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'groups', views.GroupViewSet)
# router.register(r'courses', views.CourseViewSet)

urlpatterns = [
    path('courses/course/', CourseDetail.as_view()),
    path('courses/courselist/', CourseList.as_view()),
    path('courses/CREATE/NAME=<str:name>&ADDRESS=<str:addr>&CITY=<str:city>&STATE=<str:state>&ZIP=<int:zip>/', CourseCreate.as_view()),
    path('courses/ZIP=<int:zip>/', CoursesByZip.as_view()),
    path('courseholes/', CourseHoleCreate.as_view()),
    path('games/',GameView.as_view()),
    path('games/USER-ID=<int:userpk>/', GameViewUser.as_view()),
    path('games/GAME-ID=<int:pk>/',GameDetailView.as_view()),
    path('games/create/',GameCreateView.as_view()),
    path('games/delete/',GameDeleteView.as_view()),
    path('games/update/',GameUpdateView.as_view()),
]