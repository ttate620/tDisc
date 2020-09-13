from django.conf.urls import url
from django.contrib import admin
from .views import UserCreateAPIView, UserLoginAPIView
from rest_framework.generics import CreateAPIView, DestroyAPIView, UpdateAPIView, ListAPIView
from django.contrib.auth import get_user_model


User = get_user_model()

urlpatterns = [
   url(r'^register/$', UserCreateAPIView.as_view(), name='register'),
   url(r'^login/$', UserLoginAPIView.as_view(), name='login'),
]