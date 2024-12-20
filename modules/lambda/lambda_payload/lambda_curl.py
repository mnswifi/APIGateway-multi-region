import subprocess
import os

def lambda_handler(event, context):
    api_gateway_url = os.environ.get("API_GATEWAY_URL", "")
    curl_command = f"curl -vk {api_gateway_url}"
    
    result = subprocess.run(curl_command, shell=True, capture_output=True, text=True)
    
    return {
        "statusCode": result.returncode,
        "body": result.stdout if result.returncode == 0 else result.stderr
    }
