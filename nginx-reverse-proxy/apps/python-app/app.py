from flask import Flask, jsonify
from datetime import datetime
import os

app = Flask(__name__)
port = int(os.getenv('PORT', 5000))

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'ok',
        'service': 'python-app'
    }), 200

@app.route('/')
def index():
    """Main API response"""
    return jsonify({
        'message': 'Welcome to Python/Flask API',
        'timestamp': datetime.now().isoformat(),
        'service': 'flask-app'
    }), 200

@app.route('/api/data')
def get_data():
    """Sample API endpoint"""
    return jsonify({
        'data': [
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
            {'id': 3, 'name': 'Item 3'}
        ],
        'count': 3
    }), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port, debug=False)
