import os
import pytesseract
from PIL import Image
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser
import google.generativeai as genai
from dotenv import load_dotenv

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

load_dotenv() # Load environment variables from .env file

# Configure the Gemini API
genai.configure(api_key="AIzaSyBpiQYgNH-WwG608LaptsLLphZrMkJjtyo")
model = genai.GenerativeModel('gemini-1.5-flash-latest')

# --- Main API View ---
class AnalyzeReportView(APIView):
    parser_classes = [MultiPartParser] # This allows the view to handle file uploads

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

           # In api/views.py

            prompt = f"""
            Analyze the following medical lab report text.
            1. Provide a beautiful and understandable overall summary of the report.
            2. Create a list of simple, one-sentence summaries for each individual test result.
            3. For any values outside the normal range, provide a list of actionable and
            culturally relevant dietary and lifestyle suggestions suitable for a person living in
            Kochi, Kerala, India.
            4. Generate a list of 3-4 relevant questions the user could ask their doctor.
            5. **Crucially, for each primary test (like Hemoglobin, Cholesterol, etc.), extract the numerical data and format it as a list of JSON objects under a key called "chartData". Each object must contain:
            - "testName" (string)
            - "userValue" (number)
            - "normalLow" (number, the low end of the normal range)
            - "normalHigh" (number, the high end of the normal range)**
            6. Format the entire output as a single, valid JSON object with five keys: "overallSummary",
            "testSummaries", "recommendations", "doctorQuestions", and "chartData".
            Do not include any introductory text or markdown formatting.

            Report Text:
            ---
            {report_text}
            ---
            """

            # 4. Call the Gemini API and get the response
            response = model.generate_content(prompt)
            
            # 5. Return the AI's response to the Flutter app
            # The Gemini library can often return valid JSON directly.
            # We will clean it up just in case to be safe.
            cleaned_response = response.text.strip().replace("```json", "").replace("```", "")
            return Response(cleaned_response, status=status.HTTP_200_OK)

        except Exception as e:
            print(f"An error occurred: {e}") # For debugging on the server
            return Response({"error": "An internal error occurred during analysis."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)