import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, mean_squared_error
import numpy as np

# Step 1: Load the data
try:
    data = pd.read_csv("F:/Android development/cosmetics.csv", encoding="ISO-8859-1")
except UnicodeDecodeError:
    data = pd.read_csv("F:/Android development/cosmetics.csv", encoding="latin1")

# Step 2: Preprocess the data
# Handle missing values
data.fillna('', inplace=True)

# Encode categorical columns
label_encoder = LabelEncoder()
data['Brand'] = label_encoder.fit_transform(data['Brand'])
data['Name'] = label_encoder.fit_transform(data['Name'])

# Features and target
features = ['Combination', 'Dry', 'Normal', 'Oily', 'Sensitive', 'Price']
X = data[features]

# Check if target is continuous or categorical
if data['Rank'].dtype in [np.float64, np.int64]:  # Continuous target
    is_continuous = True
    y = data['Rank']
else:  # Categorical target
    is_continuous = False
    y = data['Rank']

# Step 3: Split the dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the model based on the target type
if is_continuous:
    model = RandomForestRegressor(random_state=42)
    model.fit(X_train, y_train)
    # Evaluate regression model
    y_pred = model.predict(X_test)
    rmse = np.sqrt(mean_squared_error(y_test, y_pred))
    print(f"Regression Model RMSE: {rmse:.2f}")
else:
    model = RandomForestClassifier(random_state=42)
    model.fit(X_train, y_train)
    # Evaluate classification model
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    print(f"Classification Model Accuracy: {accuracy * 100:.2f}%")

# Step 5: Recommend products
# Updated recommend_products function
def recommend_products(user_data, top_n=10):
    # Convert user input into a DataFrame
    user_features = pd.DataFrame([user_data])
    
    if is_continuous:
        # Predict regression target
        predicted_rank = model.predict(user_features)
        data['PredictedRank'] = model.predict(X)
        recommended = data.sort_values(by='PredictedRank', ascending=True).head(top_n)  # Lower rank is better
    else:
        # Predict probabilities for classification
        if hasattr(model, 'predict_proba'):
            predictions = model.predict_proba(user_features)
            data['Probability'] = predictions[:, 1]  # Assuming binary classification
            recommended = data.sort_values(by='Probability', ascending=False).head(top_n)
        else:
            # Fallback: Sort by actual Rank
            recommended = data.sort_values(by='Rank', ascending=False).head(top_n)
    
    # Decode the 'Brand' and 'Name' columns
    recommended['Brand'] = recommended['Brand'].apply(lambda x: label_encoder.inverse_transform([x])[0])
    recommended['Name'] = recommended['Name'].apply(lambda x: label_encoder.inverse_transform([x])[0])
    
    return recommended[['id', 'Label', 'Brand', 'Name', 'Price', 'Rank']]


# Example user data (replace with actual user data from UserSkinData)
user_data = {
    'Combination': 1,  # 1 if suitable, 0 otherwise
    'Dry': 0,
    'Normal': 1,
    'Oily': 0,
    'Sensitive': 1,
    'Price': 500  # Example price range
}

# Get recommendations
recommendations = recommend_products(user_data)
print("Recommended Products:")
pd.set_option('display.max_columns', None)  # Show all columns
pd.set_option('display.max_rows', None)     # Show all rows
pd.set_option('display.width', 1000)        # Adjust width to avoid wrapping
pd.set_option('display.colheader_justify', 'center')  # Align headers
print(recommendations)
