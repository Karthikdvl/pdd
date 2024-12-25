

# Product Recommendation Updated Logic
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
import joblib

# Load the model and encoders
model = joblib.load("model.pkl")
brand_encoder = joblib.load("brand_encoder.pkl")
name_encoder = joblib.load("name_encoder.pkl")

# Example Dataset (replace with actual database query results)
cosmetics_data = pd.DataFrame()  # Placeholder for data fetched from the database

def preprocess_input(skin_type_selections, skin_sensitivity):
    skin_types = ['Combination', 'Dry', 'Normal', 'Oily', 'Sensitive']
    user_data = {stype: int(stype in skin_type_selections) for stype in skin_types}
    user_data['Sensitive'] = 1 if skin_sensitivity.lower() == 'sensitive' else 0
    return user_data

def recommend_products(skin_type_selections, skin_sensitivity, top_n=10):
    user_data = preprocess_input(skin_type_selections, skin_sensitivity)
    user_features = pd.DataFrame([user_data])

    cosmetics_data['Score'] = model.predict_proba(user_features)[:, 1]
    recommended = cosmetics_data.sort_values(by='Score', ascending=False).head(top_n)

    recommended['Brand'] = brand_encoder.inverse_transform(recommended['Brand'])
    recommended['Name'] = name_encoder.inverse_transform(recommended['Name'])

    return recommended[['id', 'Label', 'Brand', 'Name', 'Price', 'Rank']]
@app.route('/recommend', methods=['POST'])
def recommend():
    try:
        data = request.json
        skin_type_selections = data.get('skinTypeSelections', [])
        skin_sensitivity = data.get('skinSensitivity', 'Not Sensitive')

        # Validate input
        if not isinstance(skin_type_selections, list) or not isinstance(skin_sensitivity, str):
            return jsonify({'error': 'Invalid input format. Please provide valid skinTypeSelections and skinSensitivity values.'}), 400

        # Filter products based on user's input
        recommendations = recommend_products(skin_type_selections, skin_sensitivity, top_n=10)

        # Convert recommendations to a list of dictionaries
        response = recommendations.to_dict(orient='records')

        # Return recommendations in the response
        return jsonify({'recommendations': response}), 200

    except FileNotFoundError as e:
        return jsonify({'error': f"Model file not found: {str(e)}"}), 500
    except ValueError as e:
        return jsonify({'error': f"Data processing error: {str(e)}"}), 500
    except Exception as e:
        return jsonify({'error': f"An unexpected error occurred: {str(e)}"}), 500