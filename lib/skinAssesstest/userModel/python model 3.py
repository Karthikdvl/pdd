import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, mean_squared_error
import joblib

# Step 1: Load the data
def load_data(file_path):
    try:
        return pd.read_csv(file_path, encoding="ISO-8859-1")
    except UnicodeDecodeError:
        return pd.read_csv(file_path, encoding="latin1")

# Step 2: Preprocess the data
def preprocess_data(data):
    # Handle missing values
    data.fillna('', inplace=True)

    # Encode categorical columns (Brand and Name)
    brand_encoder = LabelEncoder()
    name_encoder = LabelEncoder()

    data['Brand'] = brand_encoder.fit_transform(data['Brand'])
    data['Name'] = name_encoder.fit_transform(data['Name'])

    return data, brand_encoder, name_encoder

# Step 3: Train the model
def train_model(data):
    features = ['Combination', 'Dry', 'Normal', 'Oily', 'Sensitive']
    X = data[features]

    # Check if the target ('Rank') is continuous or categorical
    if np.issubdtype(data['Rank'].dtype, np.number):
        is_continuous = True
        y = data['Rank']
    else:
        is_continuous = False
        y = data['Rank']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    if is_continuous:
        model = RandomForestRegressor(random_state=42)
        model.fit(X_train, y_train)
        y_pred = model.predict(X_test)
        rmse = np.sqrt(mean_squared_error(y_test, y_pred))
        print(f"Regression Model RMSE: {rmse:.2f}")
    else:
        model = RandomForestClassifier(random_state=42)
        model.fit(X_train, y_train)
        y_pred = model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        print(f"Classification Model Accuracy: {accuracy * 100:.2f}%")

    return model, is_continuous

# Step 4: Save the model and encoders
def save_artifacts(model, brand_encoder, name_encoder, is_continuous):
    joblib.dump(model, 'model.pkl')
    joblib.dump(brand_encoder, 'brand_encoder.pkl')
    joblib.dump(name_encoder, 'name_encoder.pkl')
    joblib.dump(is_continuous, 'is_continuous.pkl')
    print("Artifacts saved successfully.")

# Step 5: Recommend products
def preprocess_input(skin_type_selections, skin_sensitivity):
    skin_types = ['Combination', 'Dry', 'Normal', 'Oily', 'Sensitive']
    user_data = {stype: int(stype in skin_type_selections) for stype in skin_types}
    user_data['Sensitive'] = 1 if skin_sensitivity.lower() == 'sensitive' else 0
    return user_data

def recommend_products(data, skin_type_selections, skin_sensitivity, top_n=10):
    user_data = preprocess_input(skin_type_selections, skin_sensitivity)
    user_features = pd.DataFrame([user_data])

    is_continuous = joblib.load('is_continuous.pkl')
    model = joblib.load('model.pkl')
    brand_encoder = joblib.load('brand_encoder.pkl')
    name_encoder = joblib.load('name_encoder.pkl')

    if is_continuous:
        data['PredictedRank'] = model.predict(data[['Combination', 'Dry', 'Normal', 'Oily', 'Sensitive']])
        recommended = data.sort_values(by='PredictedRank', ascending=True).head(top_n)
    else:
        probabilities = model.predict_proba(user_features)[0]
        data['Score'] = model.predict_proba(data[['Combination', 'Dry', 'Normal', 'Oily', 'Sensitive']])[:, 1]
        recommended = data.sort_values(by='Score', ascending=False).head(top_n)

    recommended['Brand'] = brand_encoder.inverse_transform(recommended['Brand'])
    recommended['Name'] = name_encoder.inverse_transform(recommended['Name'])

    return recommended[['id', 'Label', 'Brand', 'Name', 'Price', 'Rank']]

# Main Execution
if __name__ == '__main__':
    file_path = "F:/Android development/cosmetics.csv"
    data = load_data(file_path)
    data, brand_encoder, name_encoder = preprocess_data(data)
    model, is_continuous = train_model(data)
    save_artifacts(model, brand_encoder, name_encoder, is_continuous)

    # Example user input
    user_skin_types = ['Combination', 'Normal']
    user_skin_sensitivity = 'Sensitive'

    recommendations = recommend_products(data, user_skin_types, user_skin_sensitivity, top_n=10)
    print("Recommended Products:")
    pd.set_option('display.max_columns', None)
    pd.set_option('display.width', 1000)
    print(recommendations)
