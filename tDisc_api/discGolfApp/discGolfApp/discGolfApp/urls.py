from django.contrib import admin
from django.urls import include, path


urlpatterns = [
    path('', include('home.urls')),
    path('admin/', admin.site.urls),
    path('api/accounts/', include('accounts.urls')),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]