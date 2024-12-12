import pandas as pd

# Load the cosmetics dataset
file_path = "F:/Android development/cosmetics.csv"
try:
    cosmetics_data = pd.read_csv(file_path)
except FileNotFoundError:
    cosmetics_data = None
    print(f"Error: File not found at {file_path}. Ensure the file path is correct.")

# Function for product recommendations
def recommend_products(user_data, cosmetics_data):
    """Generate product recommendations based on user preferences."""
    try:
        # Ensure the cosmetics dataset is loaded
        if cosmetics_data is None:
            raise ValueError("Cosmetics dataset is not loaded. Please check the file path.")

        # Validate required user data fields
        required_fields = ["skinType", "skinSensitivity", "skinConcerns"]
        for field in required_fields:
            if field not in user_data:
                raise ValueError(f"Missing required field in user data: {field}")

        # Extract user preferences
        skin_type_column = user_data["skinType"]
        sensitivity_column = "Sensitive" if user_data["skinSensitivity"] == "High" else None
        skin_concerns = user_data["skinConcerns"]

        # Validate skin type column
        if skin_type_column not in cosmetics_data.columns:
            raise ValueError(f"Invalid skin type: {skin_type_column} not found in dataset.")

        # Filter by skin type
        filtered_data = cosmetics_data[cosmetics_data[skin_type_column] == 1]

        # Filter by sensitivity compatibility (if applicable)
        if sensitivity_column and sensitivity_column in cosmetics_data.columns:
            filtered_data = filtered_data[filtered_data[sensitivity_column] == 1]

        # Further filter by skin concerns
        for concern in skin_concerns:
            if concern in cosmetics_data.columns:
                filtered_data = filtered_data[filtered_data[concern] == 1]

        # Sort by rank (descending) and price (ascending)
        recommended_products = filtered_data.sort_values(by=["Rank", "Price"], ascending=[False, True])

        # Select relevant columns for output
        return recommended_products[["Brand", "Name", "Price", "Rank", "Ingredients"]].head(5).to_dict(orient="records")

    except Exception as e:
        raise ValueError(f"Error during recommendation: {str(e)}")

# Sample user data
user_data = {
    "skinType": "Dry",              # User's skin type
    "skinSensitivity": "High",      # User's skin sensitivity level
    "skinConcerns": ["Hydration", "Anti-Aging"],  # User's skin concerns
}

# Generate recommendations
try:
    recommendations = recommend_products(user_data, cosmetics_data)
    print("Top Recommended Products:")
    for idx, product in enumerate(recommendations, 1):
        print(f"{idx}. {product['Brand']} - {product['Name']}, Price: ${product['Price']}, Rank: {product['Rank']}")
        print(f"   Ingredients: {product['Ingredients']}")
except ValueError as e:
    print(f"Recommendation Error: {e}")
