from django.contrib import admin
from django.urls import path
from api.views import AnalyzeReportView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/analyze/', AnalyzeReportView.as_view(), name='analyze_report'),
]