from rest_framework import serializers
from django.db.models import Q
from django.contrib.auth import get_user_model
from rest_framework.serializers import HyperlinkedIdentityField, ModelSerializer, SerializerMethodField, ValidationError, EmailField, CharField, IntegerField
User = get_user_model()

class UserCreateSerializer(ModelSerializer):
    email = serializers.EmailField(label='Email')
    class Meta:
        model = User
        fields = [
            
            'username',
            'email',
            'password',
        ]
        extra_kwargs = {"password": 
            {"write_only": True}
        }

    def validate_email(self, value):
        data = self.get_initial()
        email = data.get("email")
        user_qs = User.objects.filter(email=email)
        if user_qs.exists():
            raise ValidationError("This email is already registered.")
        return value

    def create(self, validated_data):
        username = validated_data['username']
        email = validated_data['email']
        password = validated_data['password']
        user_obj = User(username=username, email=email)
        user_obj.set_password(password)
        user_obj.save()
        return validated_data


class UserLoginSerializer(ModelSerializer):
    token = CharField(allow_blank=True, read_only=True)
    username = CharField(required=False, allow_blank=True)
    email = EmailField(label='Email Address',required=False, allow_blank=True)
    class Meta:
        model = User
        fields = [
            'token',
            'username',
            'email',
            'password',
        ]
        extra_kwargs = {"password": 
            {"write_only": True}
        }

    def validate(self, data):
        user_obj = None
        email = data.get('email', None)
        username = data.get('username', None)
        password = data.get('password')
        if not (username or email):
            raise ValidationError("Username OR Email required.")
        user = User.objects.filter(Q(email=email) | Q(username=username)).distinct()

        if user.exists() and user.count() == 1:
            user_obj= user.first()
            if not user_obj.check_password(password):
                raise ValidationError("Incorrect password")
        else:
            raise ValidationError("This usernmae/email is not valid.")
        data['token'] = user_obj.pk
        return data

    # def create(self, validated_data):
    #     username = validated_data['username']
    #     email = validated_data['email']
    #     password = validated_data['email']
    #     user_obj = User(username=username, email=email)
    #     user_obj.set_password(password)
    #     user_obj.save()
    #     return validated_data
    