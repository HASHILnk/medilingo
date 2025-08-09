from django.db import models

class Report(models.Model):
    # Stores the full JSON analysis from Gemini
    analysis_data = models.JSONField() 
    # Automatically records the date and time when the report is saved
    analysis_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Report from {self.analysis_date.strftime('%Y-%m-%d %H:%M')}"
