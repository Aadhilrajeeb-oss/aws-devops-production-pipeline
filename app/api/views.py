import logging
import time

from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Task
from .serializers import TaskSerializer

logger = logging.getLogger(__name__)


@api_view(["GET"])
def health_check(request):
    """Used by load balancer / monitoring / load testing tools."""
    logger.info("Health check hit")
    return Response({"status": "ok", "timestamp": time.time()})


class TaskViewSet(viewsets.ModelViewSet):
    queryset = Task.objects.all().order_by("-created_at")
    serializer_class = TaskSerializer

    def list(self, request, *args, **kwargs):
        logger.info("Listing tasks")
        return super().list(request, *args, **kwargs)
