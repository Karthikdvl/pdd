from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt  # Import Bcrypt for password hashing
from sqlalchemy.orm import class_mapper, ColumnProperty
from sqlalchemy.orm.attributes import InstrumentedAttribute
from sqlalchemy import func
from sqlalchemy import text
from sqlalchemy import Integer
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



if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')