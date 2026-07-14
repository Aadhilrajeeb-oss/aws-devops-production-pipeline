from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import TaskViewSet, health_check

router = DefaultRouter()
router.register(r"tasks", TaskViewSet, basename="task")

urlpatterns = [
    path("health/", health_check, name="health"),
    path("", include(router.urls)),
]
