from flask import Flask, request, jsonify
import pandas as pd

# Initialize the Flask app
app = Flask(__name__)

# Load clean ingredient list
clean_ingreds = set()

def load_clean_ingredients():
    global clean_ingreds
    try:
        # Load CSV and ensure column name matches
        df = pd.read_csv("F:/Android development/skincare_products_clean.csv")
        print("CSV columns:", df.columns)  # Debugging: print column names
        clean_ingreds = set(df['clean_ingreds'].str.lower().str.strip())
        print(f"Loaded {len(clean_ingreds)} clean ingredients.")  # Debugging: print count
    except Exception as e:
        print(f"Error loading clean ingredients: {e}")

# Load the ingredient list on startup
load_clean_ingredients()

@app.route("/analyze", methods=["POST"])
def analyze_ingredients():
    try:
        # Parse the JSON payload
        data = request.json
        if not data or "ingredients" not in data:
            return jsonify({"error": "Missing 'ingredients' field in the request."}), 400

        # Extract and process ingredients
        ingredients = [ing.lower().strip() for ing in data["ingredients"]]
        clean = [ing for ing in ingredients if ing in clean_ingreds]
        bad = [ing for ing in ingredients if ing not in clean_ingreds and ing != ""]
        na = [ing for ing in ingredients if ing == ""]

        # Prepare the response
        response = {
            "clean_ingredients": clean,
            "bad_ingredients": bad,
            "not_recognized": na
        }
        print("Analysis response:", response)  # Debugging: log response
        return jsonify(response)

    except Exception as e:
        print(f"Error during analysis: {e}")  # Debugging: log errors
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)



import pandas as pd

# Load clean ingredient list
clean_ingreds = set()

def load_clean_ingredients():
    global clean_ingreds
    try:
        # Load CSV and ensure column name matches
        df = pd.read_csv("F:/Android development/skincare_products_clean.csv")
        print("CSV columns:", df.columns)  # Debugging: print column names
        clean_ingreds = set(df['clean_ingreds'].str.lower().str.strip())
        print(f"Loaded {len(clean_ingreds)} clean ingredients.")  # Debugging: print count
    except Exception as e:
        print(f"Error loading clean ingredients: {e}")

# Load the ingredient list on startup
load_clean_ingredients()

@app.route("/analyze", methods=["POST"])
def analyze_ingredients():
    try:
        # Parse the JSON payload
        data = request.json
        if not data or "ingredients" not in data:
            return jsonify({"error": "Missing 'ingredients' field in the request."}), 400

        # Extract and process ingredients
        ingredients = [ing.lower().strip() for ing in data["ingredients"]]
        bad = [ing for ing in ingredients if ing in clean_ingreds]
        clean = [ing for ing in ingredients if ing not in clean_ingreds and ing != ""]
        na = [ing for ing in ingredients if ing == ""]

        # Prepare the response
        response = {
            "clean_ingredients": clean,
            "bad_ingredients": bad,
            "not_recognized": na
        }
        print("Analysis response:", response)  # Debugging: log response
        return jsonify(response)

    except Exception as e:
        print(f"Error during analysis: {e}")  # Debugging: log errors
        return jsonify({"error": str(e)}), 500



   
#-----------------------------------------------------------------------------------------------------------------------
import pandas as pd

# Load clean and bad ingredient lists
good_ingreds = set()
bad_ingreds = set()

def load_ingredients():
    global good_ingreds, bad_ingreds
    try:
        # Load CSV and process columns
        file_path = "F:/Android development/skincare_ingredients_classification.csv"
        df = pd.read_csv(file_path)
        print("CSV columns:", df.columns)  # Debugging: print column names

        # Extract and clean ingredients
        good_ingreds.update(
            ing.strip().lower() for row in df['good_ingredients'] for ing in eval(row)
        )
        bad_ingreds.update(
            ing.strip().lower() for row in df['bad_ingredients'] for ing in eval(row)
        )

        print(f"Loaded {len(good_ingreds)} good ingredients and {len(bad_ingreds)} bad ingredients.")

    except Exception as e:
        print(f"Error loading ingredients: {e}")

# Load the ingredient lists on startup
load_ingredients()

@app.route("/analyze", methods=["POST"])
def analyze_ingredients():
    try:
        # Parse the JSON payload
        data = request.json
        if not data or "ingredients" not in data:
            return jsonify({"error": "Missing 'ingredients' field in the request."}), 400

        # Extract and process ingredients
        ingredients = [ing.lower().strip() for ing in data["ingredients"]]
        
        good = [ing for ing in ingredients if ing in good_ingreds]
        bad = [ing for ing in ingredients if ing in bad_ingreds]
        not_recognized = [ing for ing in ingredients if ing not in good_ingreds and ing not in bad_ingreds]

        # Prepare the response
        response = {
            "good_ingredients": good,
            "bad_ingredients": bad,
            "not_recognized": not_recognized
        }
        print("Analysis response:", response)  # Debugging: log response
        return jsonify(response)

    except Exception as e:
        print(f"Error during analysis: {e}")  # Debugging: log errors
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
