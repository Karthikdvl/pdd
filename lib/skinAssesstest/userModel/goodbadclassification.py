import pandas as pd

# Load the skincare products dataset
data = pd.read_csv('skincare_products_clean.csv')

# Display the first few rows to understand the structure of the data
print(data.head())
print(data.columns)

import ast
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB

# Define lists of known good and bad ingredients
good_ingredients = [
    'glycerin', 'hyaluronic acid', 'sodium hyaluronate', 'niacinamide', 'vitamin e', 
    'tocopherol', 'panthenol', 'allantoin', 'aloe vera', 'ceramides', 'peptides',
    'vitamin c', 'retinol', 'zinc oxide', 'titanium dioxide', 'squalane', 'centella asiatica',
    'green tea', 'collagen', 'amino acids', 'antioxidants', 'vitamin b3', 'vitamin b5',
    'jojoba oil', 'argan oil', 'shea butter', 'linoleic acid', 'oleic acid'
]

bad_ingredients = [
    'parabens', 'phthalates', 'formaldehyde', 'triclosan', 'sodium lauryl sulfate',
    'sodium laureth sulfate', 'synthetic fragrances', 'artificial colors', 'mineral oil',
    'propylene glycol', 'benzophenone', 'hydroquinone', 'methylisothiazolinone',
    'oxybenzone', 'synthetic dyes', 'dmdm hydantoin', 'butylated hydroxyanisole',
    'coal tar', 'diethanolamine', 'polyethylene glycol'
]

# Process the ingredients data
def clean_ingredients(ingredients_str):
    try:
        ingredients_list = ast.literal_eval(ingredients_str)
        return [ing.lower().strip() for ing in ingredients_list]
    except:
        return []

# Create new dataframe with processed ingredients
df = data.copy()
df['ingredients_list'] = df['ingredients'].apply(clean_ingredients)

# Function to classify ingredients
def classify_ingredients(ingredients_list):
    good = [ing for ing in ingredients_list if any(good in ing.lower() for good in good_ingredients)]
    bad = [ing for ing in ingredients_list if any(bad in ing.lower() for bad in bad_ingredients)]
    return good, bad

# Apply classification
df['good_ingredients'] = ''
df['bad_ingredients'] = ''

for idx, row in df.iterrows():
    good, bad = classify_ingredients(row['ingredients_list'])
    df.at[idx, 'good_ingredients'] = str(good)
    df.at[idx, 'bad_ingredients'] = str(bad)

# Create final dataframe with required columns
result_df = df[['id', 'good_ingredients', 'bad_ingredients']]

# Save to CSV
result_df.to_csv('skincare_ingredients_classification.csv', index=False)

# Display first few rows of the result
print(result_df.head())