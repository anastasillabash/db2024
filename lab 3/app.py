from flask import Flask, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

conn = psycopg2.connect(
    dbname="gym_new",
    user="postgres",
    password="admin",
    host="localhost",
    port="5432"
)
cur = conn.cursor()

@app.route('/members', methods=['GET'])
def get_members():
    cur.execute('SELECT * FROM "Member";')
    members = cur.fetchall()
    return jsonify(members)

@app.route('/trainers', methods=['GET'])
def get_trainers():
    cur.execute('SELECT * FROM "Trainer";')
    trainers = cur.fetchall()
    return jsonify(trainers)

@app.route('/services', methods=['GET'])
def get_services():
    cur.execute('SELECT * FROM "Service";')
    services = cur.fetchall()
    return jsonify(services)

@app.route('/members/<int:id>', methods=['GET'])
def get_member(id):
    cur.execute('SELECT * FROM "Member" WHERE id = %s;', (id,))
    member = cur.fetchone()
    if member is None:
        return jsonify({'error': 'Member not found'}), 404
    return jsonify(member)


@app.route('/members', methods=['POST'])
def create_member():
    new_member = request.get_json()
    try:
        cur.execute('''
            CALL add_member(%s, %s, %s);
        ''', (new_member['name'], new_member['surname'], new_member['phone']))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 400
    return jsonify(new_member), 201

@app.route('/trainers', methods=['POST'])
def create_trainer():
    new_trainer = request.get_json()
    try:
        cur.execute('''
            CALL add_trainer(%s, %s, %s);
        ''', (new_trainer['name'], new_trainer['surname'], new_trainer['phone']))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 400
    return jsonify(new_trainer), 201

""" {
    "name" : "Anastasiia",
    "surname" : "Bash",
    "phone" : "211 686 9435"
} """

@app.route('/services', methods=['POST'])
def create_service():
    new_service = request.get_json()
    try:
        cur.execute('''
            CALL add_service(%s, %s);
        ''', (new_service['name'], new_service['price']))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 400
    return jsonify(new_service), 201

""" {
    "name" : "Yoga",
    "price" : 479.99
} """

@app.route('/members', methods=['PUT'])
def update_member():
    update_data = request.get_json()
    try:
        cur.execute('''
            CALL update_phonenumber_member(%s, %s, %s);
        ''', (update_data['name'], update_data['surname'], update_data['phone']))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 400
    return jsonify(update_data)

""" {
    "name" : "Anastasiia",
    "surname" : "Bash",
    "phone": "630 775 7945"
} """

@app.route('/services', methods=['PUT'])
def update_service():
    update_data = request.get_json()
    try:
        cur.execute('''
            CALL update_service_price(%s, %s);
        ''', (update_data['name'], update_data['price']))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 400
    return jsonify(update_data)

""" {
    "name" : "Yoga",
    "price" : 599.99
} """


@app.route('/services', methods=['DELETE'])
def delete_service():
    delete_data = request.json
    try:
        cur.execute('''
            CALL delete_service(%s);
        ''', (delete_data['name'],))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 400
    return jsonify(delete_data), 204


@app.route('/avg_duration/<int:member_id>', methods=['GET'])
def get_avg_duration(member_id):
    try:
        cur.callproc('avg_duration', (member_id,))
        avg_duration = cur.fetchone()[0]
        return jsonify({'avg_duration_seconds': avg_duration}), 200
    
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    

@app.route('/ms_by_service/<string:service_name>', methods=['GET'])
def get_ms_by_service(service_name):
    try:
        cur.callproc('ms_by_service', (service_name,))
        count = cur.fetchone()[0]
        return jsonify({'membership_count': count}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
