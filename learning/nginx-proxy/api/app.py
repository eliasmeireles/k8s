from flask import Flask, request, jsonify, send_file
import os
import subprocess

app = Flask(__name__)

CONF_DIR = "/app/conf.d"
DOC_FILE = "/app/doc.html"

@app.route('/ingress', methods=['POST'])
def ingress():
    print("Received request")
    try:
        data = request.json
        name = data.get("name")
        host = data.get("host")
        protocol = data.get("protocol", "http")  # http/https/tcp/udp
        upstream = data.get("upstream")

        print(f"Creating ingress: {name} {host} {protocol} {upstream}")

        if not name or not host or not upstream:
            return jsonify({"error": "Missing required fields"}), 400

        # Create a new configuration file
        conf_path = os.path.join(CONF_DIR, f"{name}.conf")
        with open(conf_path, 'w') as conf_file:
            if protocol in ["http", "https"]:
                conf_file.write(f"""
server {{
    listen 80;
    server_name {host};

    location / {{
        proxy_pass {upstream};
    }}
}}
""")
            elif protocol in ["tcp", "udp"]:
                conf_file.write(f"""
stream {{
    server {{
        listen 12345;  # Change to desired port
        proxy_pass {upstream};
    }}
}}
""")
            else:
                return jsonify({"error": f"Unsupported protocol: {protocol}"}), 400

        # Signal NGINX to reload
        subprocess.run(["nginx", "-s", "reload"])

        return jsonify({"message": "Ingress created successfully"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/', methods=['GET'])
def doc():
    try:
        return send_file(DOC_FILE, mimetype='text/html')
    except Exception as e:
        return f"<h1>Error</h1><p>{str(e)}</p>", 500

if __name__ == "__main__":
    print("Starting API server on port 8080")
    app.run(host="0.0.0.0", port=8080)
