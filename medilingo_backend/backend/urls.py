from django.contrib import admin
from django.urls import path
from api.views import AnalyzeReportView, ReportHistoryView, RegisterView, LoginView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/analyze/', AnalyzeReportView.as_view(), name='analyze_report'),
    path('api/history/', ReportHistoryView.as_view(), name='report_history'),
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/login/', LoginView.as_view(), name='login'),
]