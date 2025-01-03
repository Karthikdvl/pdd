from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt  # Import Bcrypt for password hashing
from sqlalchemy.orm import class_mapper, ColumnProperty
from sqlalchemy.orm.attributes import InstrumentedAttribute
from sqlalchemy import func
from sqlalchemy import text
from sqlalchemy import Integer
from flask import session

import os
from werkzeug.utils import secure_filename

import base64
import uuid
from flask_restful import Api
from datetime import datetime, timedelta
from textblob import TextBlob

import pymysql
pymysql.install_as_MySQLdb()

from werkzeug.utils import secure_filename
import pytesseract
pytesseract.pytesseract.tesseract_cmd = r"C:/Program Files/Tesseract-OCR/tesseract.exe"  # Update path as per your system
from PIL import Image
import cv2
import numpy as np

import smtplib
import random

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:@127.0.0.1/skindatabase'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'karthik'
bcrypt = Bcrypt(app)

db = SQLAlchemy(app)


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


#----------------------------------------api calls here---------------------------------------------------------------

# Define the allowed extensions for file uploads if needed
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp'}

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(255), nullable=False, unique=True)
    password_hash = db.Column(db.String(255), nullable=False)

otp_store = {}

@app.route('/send-otp', methods=['POST'])
def send_otp():
    try:
        data = request.get_json()  # Use get_json() for better handling of JSON requests
        email = data.get('email')

        if not email:
            return jsonify({"error": "Email is required"}), 400

        # Generate a random 6-digit OTP
        otp = str(random.randint(100000, 999999))
        otp_store[email] = otp

        # SMTP server configuration
        smtp_server = "smtp.gmail.com"
        smtp_port = 587
        sender_email = "dvlkarthik123@gmail.com"  # Replace with your email
        sender_password = "veij nqen btom gxph" # Replace with your app password

        # Email content
        subject = "Your One-Time OTP Code for Verification"
        body = f"""
        Hi there,
        
        Thank you for choosing to verify your account with us. Below is your one-time password (OTP) to complete the verification process:
        
        Your OTP code: {otp}
        
        This code is valid for the next 10 minutes, so please enter it soon to complete your registration.
        
        If you didn't request this OTP or need any assistance, feel free to contact us at [Your Support Email/Contact].
        
        Thank you for your trust, and welcome to [Your Company Name]!
        
        Best regards,
        [Your Company Name]
        [Your Website URL]
        [Your Support Email/Contact]
        """
        message = f"Subject: {subject}\n\n{body}"


        # Sending the email
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, email, message)

        return jsonify({"message": "OTP sent successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
# Route for verifying OTP
@app.route('/verify-otp', methods=['POST'])
def verify_otp():
    try:
        data = request.json
        email = data.get('email')
        otp = data.get('otp')

        if not email or not otp:
            return jsonify({"error": "Email and OTP are required"}), 400

        stored_otp = otp_store.get(email)
        if stored_otp and stored_otp == otp:
            del otp_store[email]  # Remove OTP after successful verification
            return jsonify({"message": "OTP verified successfully"}), 200
        else:
            return jsonify({"error": "Invalid OTP"}), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route for user registration
@app.route('/register', methods=['POST'])
def register():
    data = request.json
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    confirm_password = data.get('confirm_password')

    if not all([name, email, password, confirm_password]):
        return jsonify({'message': 'All fields are required!'}), 400

    if password != confirm_password:
        return jsonify({'message': 'Passwords do not match!'}), 400

    existing_user = User.query.filter_by(email=email).first()
    if existing_user:
        return jsonify({'message': 'Email already registered!'}), 400

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(name=name, email=email, password_hash=hashed_password)

    try:
        db.session.add(new_user)
        db.session.commit()
        return jsonify({'message': 'User registered successfully!'}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'An error occurred during registration.', 'error': str(e)}), 500


# Route for user login
@app.route('/login', methods=['POST'])
def login():
    data = request.json  # Expecting JSON data
    email = data.get('email')
    password = data.get('password')

    # Validation checks
    if not all([email, password]):
        return jsonify({'message': 'Email and password are required!'}), 400

    # Find the user by email
    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({'message': 'Invalid email or password!'}), 401

    # Verify the password
    if not bcrypt.check_password_hash(user.password_hash, password):
        return jsonify({'message': 'Invalid email or password!'}), 401

    # Successful login
    return jsonify({
        'message': 'Login successful!',
        'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email
        }
    }), 200


# Admin model
class Admin(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)

    def set_password(self, password):
        self.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password):
        return bcrypt.check_password_hash(self.password_hash, password)


# Route: Admin Register
@app.route('/admin/register', methods=['POST'])
def admin_register():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Email and password are required', 'status': 'error'}), 400

    existing_admin = Admin.query.filter_by(email=email).first()
    if existing_admin:
        return jsonify({'message': 'Admin with this email already exists', 'status': 'error'}), 409

    new_admin = Admin(email=email)
    new_admin.set_password(password)
    db.session.add(new_admin)
    db.session.commit()

    return jsonify({'message': 'Admin registered successfully', 'status': 'success'}), 201


# Route: Admin Login
@app.route('/admin/login', methods=['POST'])
def admin_login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    admin = Admin.query.filter_by(email=email).first()
    if admin and admin.check_password(password):
        session['admin_id'] = admin.id
        return jsonify({'message': 'Login successful', 'status': 'success'}), 200
    return jsonify({'message': 'Invalid email or password', 'status': 'error'}), 401


# Route: Admin Logout
@app.route('/admin/logout', methods=['POST'])
def admin_logout():
    session.pop('admin_id', None)
    return jsonify({'message': 'Logout successful', 'status': 'success'}), 200


# Route: Check Login Status
@app.route('/admin/status', methods=['GET'])
def admin_status():
    if 'admin_id' in session:
        return jsonify({'logged_in': True}), 200
    return jsonify({'logged_in': False}), 200


# --------------------------------------------------------------------------------------------------------

# Product Data Model
class Product(db.Model):
    __tablename__ = 'cosmetics'  # Match the name of your table
    id = db.Column(db.Integer, primary_key=True)
    label = db.Column(db.String(100))
    brand = db.Column(db.String(100))
    name = db.Column(db.String(100))
    price = db.Column(db.Float)
    rank = db.Column(db.Float)

    def to_dict(self):
        return {
            "id": self.id,
            "label": self.label,
            "brand": self.brand,
            "name": self.name,
            "price": self.price,
            "rank": self.rank,
            
        }


# class Product(db.Model):
#     __tablename__ = 'cosmetics'  # Match the name of your table
#     id = db.Column(db.Integer, primary_key=True)
#     label = db.Column(db.String(100))
#     brand = db.Column(db.String(100))
#     name = db.Column(db.String(100))
#     price = db.Column(db.Float)
#     rank = db.Column(db.Float)
#     ingredients = db.Column(db.Text)  # Add the ingredients field

#     def to_dict(self):
#         return {
#             "id": self.id,
#             "label": self.label,
#             "brand": self.brand,
#             "name": self.name,
#             "price": self.price,
#             "rank": self.rank,
#             "ingredients": self.ingredients  # Include ingredients in the response
#         }
# Route for searching products in the database


@app.route('/search', methods=['GET'])
def search_products():
    query = request.args.get('query', '').lower()

    # Check if query is provided
    if not query:
        return jsonify({"results": [], "message": "Please provide a search query"}), 400

    # Query the database for products matching name, label, or brand
    products = Product.query.filter(
        (Product.name.ilike(f"%{query}%")) |
        (Product.label.ilike(f"%{query}%")) |
        (Product.brand.ilike(f"%{query}%"))
    ).all()

    # Convert results to JSON
    results = [product.to_dict() for product in products]

    # Return results or a "not found" message
    if results:
        return jsonify({"results": results}), 200
    else:
        return jsonify({"results": [], "message": "No products found"}), 404


@app.route('/productlist', methods=['GET'])
def get_products():
    try:
        # Query all products
        products = Product.query.all()
        results = [product.to_dict() for product in products]
        return jsonify({"results": results}), 200
    except Exception as e:
        return jsonify({"message": "Failed to fetch products", "error": str(e)}), 500
    
    response = jsonify({"results": results})
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    return response, 200

@app.route('/products/<int:product_id>', methods=['GET'])
def get_product_details(product_id):
    try:
        # Query the product by its ID
        product = Product.query.get(product_id)
        if product:
            # Convert the product to a dictionary and return it
            return jsonify(product.to_dict()), 200
        else:
            # If product not found, return a 404 error
            return jsonify({"message": "Product not found"}), 404
    except Exception as e:
        # Handle any unexpected errors
        return jsonify({"message": "Failed to fetch product details", "error": str(e)}), 500

@app.route('/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    try:
        # Get the product by ID
        product = Product.query.get(product_id)
        if not product:
            return jsonify({"message": "Product not found"}), 404
        
        # Parse the incoming data
        data = request.get_json()
        product.label = data.get('label', product.label)
        product.brand = data.get('brand', product.brand)
        product.name = data.get('name', product.name)
        product.price = data.get('price', product.price)
        product.rank = data.get('rank', product.rank)

        # Save changes to the database
        db.session.commit()
        return jsonify({"message": "Product updated successfully", "product": product.to_dict()}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"message": "Failed to update product", "error": str(e)}), 500

# ---------------------------------------------------------------------------------------

@app.route('/recommend', methods=['POST'])
def recommend_products():
    try:
        data = request.get_json()
        skin_type_selections = data.get('skinTypeSelections', {})
        skin_sensitivity = data.get('skinSensitivity')  # 0 for NotSensitive, 1 for Sensitive

        # Determine the primary skin type from selections
        skin_type = max(skin_type_selections.items(), key=lambda x: x[1])[0] if skin_type_selections else None

        # Base query
        query = Product.query

        # Filter based on skin type
        if skin_type:
            if skin_type == 'Dry':
                query = query.filter(Product.label.ilike('%moisturizer%'))
            elif skin_type == 'Oily':
                query = query.filter(Product.label.ilike('%cleanser%'))
            elif skin_type == 'Combination':
                query = query.filter(
                    (Product.label.ilike('%moisturizer%')) |
                    (Product.label.ilike('%cleanser%'))
                )
            elif skin_type == 'Normal':
                # For normal skin, include a variety of recommended products
                query = query.filter(
                    (Product.label.ilike('%vitamin c%')) |
                    (Product.label.ilike('%face wash%')) |
                    (Product.label.ilike('%Sun protect%')) |
                    (Product.label.ilike('%cleanser%')) |
                    (Product.label.ilike('%serum%')) |
                    (Product.label.ilike('%Treatment%'))
                )

        # Filter based on sensitivity
        if skin_sensitivity == 1:  # Sensitive
            query = query.filter(Product.rank >= 4.0)

        # Get recommendations and ensure a good mix of products
        recommended_products = query.order_by(
            func.random()  # Randomize to get a mix of different product types
        ).limit(20).all()
        
        # Convert to list of dictionaries
        recommendations = [product.to_dict() for product in recommended_products]
        
        return jsonify({
            "status": "success",
            "recommendations": recommendations
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

import logging
import re 

UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure the upload folder exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image file provided'}), 400
    
    image_file = request.files['image']
    
    if image_file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    file_path = os.path.join(app.config['UPLOAD_FOLDER'], image_file.filename)
    image_file.save(file_path)

    try:
        image = Image.open(file_path)
        extracted_text = pytesseract.image_to_string(image)
        
        # Look for ingredients section
        ingredients_text = ""
        lines = extracted_text.split('\n')
        found_ingredients = False
        
        for line in lines:
            # Check for ingredients header
            if re.search(r'ingredients?[:]*', line.lower()):
                found_ingredients = True
                continue
                
            # Collect ingredients until we hit another section or empty lines
            if found_ingredients:
                if line.strip() and not line.lower().endswith(':') and not re.match(r'^[A-Z\s]+:', line):
                    ingredients_text += line.strip() + '\n'
                elif not line.strip():
                    continue
                else:
                    break
        
        if not ingredients_text:
            return jsonify({'error': 'No ingredients found in image'}), 404

        # Clean up the ingredients text
        ingredients_text = "ingredients:\n" + ingredients_text.strip()
        
        return jsonify({'extracted_text': ingredients_text}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    

    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
