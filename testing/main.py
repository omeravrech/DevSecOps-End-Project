import os
import requests
import pytest

def get_url():
    url = os.environ.get("URL")
    if url:
        return url
    else:
        return input("Enter the URL of the website you want to test: ")

def test_website_status_code():
    url = get_url()
    print(f"PERFORMING TEST TO URL {url}")
    response = requests.get(url)
    assert response.status_code == 200, f"Failed: Expected status code 200, but received {response.status_code}"

if __name__ == "__main__":
    pytest.main([__file__])
