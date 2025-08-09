import os
import pytesseract
import json
from .models import Report
from PIL import Image
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser
import google.generativeai as genai

# --- Configuration ---

# Tell pytesseract where to find the Tesseract-OCR executable
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# Configure the Gemini API directly with your key
# IMPORTANT: Replace "YOUR_API_KEY_HERE" with your actual key
genai.configure(api_key='AIzaSyBpiQYgNH-WwG608LaptsLLphZrMkJjtyo')
model = genai.GenerativeModel('gemini-1.5-flash-latest')


# --- API Views ---

class AnalyzeReportView(APIView):
    """
    Handles the analysis of an uploaded medical report image.
    """
    parser_classes = [MultiPartParser]

    def post(self, request, *args, **kwargs):
        # 1. Get the uploaded image from the request
        image_file = request.data.get('image')
        if not image_file:
            return Response({"error": "No image provided."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # 2. Perform OCR on the image
            image = Image.open(image_file)
            report_text = pytesseract.image_to_string(image)

            if not report_text.strip():
                return Response({"error": "Could not extract text from the image."}, status=status.HTTP_400_BAD_REQUEST)

            # 3. Construct the detailed prompt for the Gemini API
            prompt = f"""
            Analyze the following medical lab report text.
            1. Provide a beautiful and understandable overall summary of the report.
            2. Create a list of simple, one-sentence summaries for each individual test result.
            3. For any values outside the normal range, provide a list of actionable and
               culturally relevant dietary and lifestyle suggestions suitable for a person living in
               Kochi, Kerala, India.
            4. Generate a list of 3-4 relevant questions the user could ask their doctor.
            5. For each primary test (like Hemoglobin, Cholesterol, etc.), extract the numerical data and format it as a list of JSON objects under a key called "chartData". Each object must contain:
               - "testName" (string)
               - "userValue" (number)
               - "normalLow" (number, the low end of the normal range)
               - "normalHigh" (number, the high end of the normal range)
            6. Format the entire output as a single, valid JSON object with five keys: "overallSummary",
               "testSummaries", "recommendations", "doctorQuestions", and "chartData".
               Do not include any introductory text or markdown formatting.

            Report Text:
            ---
            {report_text}
            ---
            """

            # 4. Call the Gemini API
            response = model.generate_content(prompt)
            cleaned_response = response.text.strip().replace("```json", "").replace("```", "")
            
            # 5. Save the result to the database
            analysis_json = json.loads(cleaned_response) # Convert string to JSON object
            Report.objects.create(analysis_data=analysis_json) # Save it!

            # 6. Return the JSON object to the Flutter app
            return Response(analysis_json, status=status.HTTP_200_OK)

        except Exception as e:
            print(f"An error occurred: {e}") # For debugging on the server
            return Response({"error": "An internal error occurred during analysis."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ReportHistoryView(APIView):
    """
    Retrieves all saved report analyses from the database.
    """
    def get(self, request, *args, **kwargs):
        # Get all reports, ordered from newest to oldest
        reports = Report.objects.all().order_by('-analysis_date')
        # Prepare the data to be sent as JSON
        data = [
            {
                "id": report.id,
                "analysis_date": report.analysis_date,
                "analysis_data": report.analysis_data
            }
            for report in reports
        ]
        return Response(data, status=status.HTTP_200_OK)