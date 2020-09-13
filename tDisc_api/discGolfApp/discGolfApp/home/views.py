from django.shortcuts import render
from rest_framework import generics
from django.contrib.auth.models import Group
from django.contrib.auth import get_user_model
from .models import Course, CourseHoles, Game
from rest_framework import viewsets, status
from .serializers import UserSerializer, GroupSerializer, CourseSerializer, CourseHolesSerializer, GameSerializer
from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response

User = get_user_model()

class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer


class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

# course list view
class CourseList(APIView):
    def get(self, request, format=None):
        courses = Course.objects.all()
        serializer = CourseSerializer(courses, many=True)
        return Response(serializer.data)

# single course detail view , allowed: GET, DELETE
class CourseDetail(APIView):
    def get_object(self, pk):
        try:
            return Course.objects.get(id=pk)
        except Course.DoesNotExist:
            raise Http404

    # def get(self, request, pk, format=None):
    #     course = self.get_object(pk) 
    #     serializer = CourseSerializer(course)
    #     return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        data = request.data
        course_name = data.get("name")
        course = Course.objects.filter(name=course_name)
        print(course)
        if not course:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        course = course.first()
        
        serializer = CourseSerializer(course)
      
        return Response(serializer.data , status=status.HTTP_202_ACCEPTED)

    def delete(self, request, pk, format=None):
        course = self.get_object(pk)
        course.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

# all courses within given zip code, allowed: GET
class CoursesByZip(APIView):
    def get_object(self, zip):
        courseList = Course.objects.filter(zip_code=zip)
        if len(courseList)==0:
            return []
        else:
            return courseList

    def get(self, request, zip, format=None):
        courses = self.get_object(zip)
        serializer = CourseSerializer(courses, many=True)
        return Response(serializer.data)


class CourseCreate(APIView):
    def create_course(self, name, addr, city, state, zip):
        course = Course(name=name.replace('+',' '), address=addr.replace('+',' '), city=city, state=state, zip_code=zip)
        return course

    def post(self, request, name, addr, city, state, zip, format=None):
        qs = Course.objects.filter(name=name)
        if not qs:
            return Response(status=status.HTTP_409_CONFLICT)

        course = self.create_course(name, addr, city, state, zip)
        serializer = CourseSerializer(course, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, name, addr, city, state, zip, format=None):
        qs = Course.objects.filter(name=name.replace('+',' '))
        if qs:
            course = qs
            course.update(
                address = addr.replace('+',' '),
                city = city,
                state = state,
                zip_code = zip
            )
            
            serializer = CourseSerializer(course, data=request.data)  
            if serializer.is_valid():
                print("update", serializer.data)
                return Response(serializer.data)
            return Response(status=status.HTTP_409_CONFLICT)

        course = self.create_course(name, addr, city, state, zip)
        serializer = CourseSerializer(course, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CourseHoleCreate(APIView):
    def get_object(self, pk):
        ch = CourseHoles.objects.filter(pk=pk)
        if ch.exists():
            return ch.first()
        return None

    def get(self, request, pk):
        course_hole = self.get_object(pk)
        if course_hole == None:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        serializer = CourseHolesSerializer(course_hole)   
        return Response(serializer.data)

    def create_course_hole(numOfHoles, parList, distList, coursepk):
        course_hole = CourseHoles(numberOfHoles=numberOfHoles, parList=parList, distList=distList, course=course)
        return course_hole

    def post(self, request, *args, **kwargs):
        data = request.data

        course = Course.objects.filter(pk=data['course'])
        if not course:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        qs = CourseHoles.objects.filter(course=course.first())
        if qs:
            return Response(status=status.HTTP_409_CONFLICT)
        
        serializer =  CourseHolesSerializer(data=data)
        if serializer.is_valid(raise_exception=True):
            new_data = serializer.data
            return Response(new_data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

# Game model views 
class GameView(APIView):
    
    def get(self, request, format=None):
        games = Game.objects.all()
        serializer_context = {
            'request': request,
        }
        serializer = GameSerializer(games, many=True, context=serializer_context)
        return Response(serializer.data)

class GameDetailView(APIView):
    def get_object(self, pk):
        try:
            return Game.objects.get(id=pk)
        except Game.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        game = self.get_object(pk)  
        serializer = GameSerializer(game)
        return Response(serializer.data)

class GameViewUser(APIView):
    def get(self, request, userpk):
        games = Game.objects.filter(user = User.objects.get(pk=userpk))
        serializer_context = {
            'request': request,
        }
        serializer = GameSerializer(games, many=True, context=serializer_context)
        return Response(serializer.data)
        
class GameDeleteView(APIView):
    def post(self, request, *args, **kwargs):
        data = request.data
        gamepk = data.get("gameID") 
        game = Game.objects.filter(pk=gamepk)
        if game.exists():
            game.first().delete()
            return Response(status=status.HTTP_202_ACCEPTED)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)

class GameCreateView(APIView):
    def post(self, request, *args, **kwargs):
        data = request.data
        coursepk = data.get("courseID")
        userpk = data.get("userID")
        course = Course.objects.filter(pk=coursepk)
        user = User.objects.filter(pk=userpk)
        if not (course.exists() and user.exists()):
            return Response(status=status.HTTP_400_BAD_REQUEST)
        game = Game.objects.create(course=course.first(), user=user.first())
        serializer = GameSerializer(game)
        return Response(serializer.data , status=status.HTTP_201_CREATED)

class GameUpdateView(APIView):
    def put(self, request,  *args, **kwargs):
        data = request.data
        gamepk = data.get('gameID')
        hole = data.get('hole')
        score = data.get('score')
        game = Game.objects.filter(pk=gamepk)
        if not game.exists():
            print('no game')
            return Response(status=status.HTTP_400_BAD_REQUEST)
        game=game.first()
        game.update_game(hole, score)
        game.save()
        serializer = GameSerializer(game)
        return Response(serializer.data)