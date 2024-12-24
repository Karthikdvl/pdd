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
import os
import uuid
from flask_restful import Api
from datetime import datetime, timedelta
from textblob import TextBlob

import pymysql
pymysql.install_as_MySQLdb()

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

# Define the User model for the `register` table
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(255), nullable=False, unique=True)
    password_hash = db.Column(db.String(255), nullable=False)


# Route for user registration
@app.route('/register', methods=['POST'])
def register():
    data = request.json  # Expecting JSON data
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    confirm_password = data.get('confirm_password')

    # Validation checks
    if not all([name, email, password, confirm_password]):
        return jsonify({'message': 'All fields are required!'}), 400

    if password != confirm_password:
        return jsonify({'message': 'Passwords do not match!'}), 400

    # Check if the email is already registered
    existing_user = User.query.filter_by(email=email).first()
    if existing_user:
        return jsonify({'message': 'Email already registered!'}), 400

    # Hash the password
    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

    # Create a new user instance
    new_user = User(name=name, email=email, password_hash=hashed_password)

    # Add the new user to the database
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
            "rank": self.rank
        }

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


#CORS(app, supports_credentials=True)  # Enable CORS for frontend integration

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


if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')