from django.contrib.auth.models import Group

from .models import Course, CourseHoles, Game
from rest_framework import serializers, generics
from django.contrib.auth import get_user_model

User = get_user_model()

class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ['pk', 'username', 'email']


class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Group
        fields = ['url', 'name']

class CourseHolesSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseHoles
        fields = ['pk', 'numberOfHoles', 'parList','distList']

class CourseSerializer(serializers.ModelSerializer):
    course_holes_set = CourseHolesSerializer(many=True,source="courseholes_set", read_only=True)
    class Meta:
        model = Course
        fields = ['pk','name', 'address', 'state','city','zip_code', 'rating', 'course_holes_set', 'latitude', 'longitude']


class GameSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    course = CourseSerializer()
    
    class Meta:
        model = Game
        fields = ['pk','user', 'course', 'scoreList', 'score', 'date_created', 'date_edited']

