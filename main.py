import requests
import pytest

def test_website_status_code():
    url = input("Enter the URL of the website you want to test: ")
    response = requests.get(url)
    assert response.status_code == 200, f"Failed: Expected status code 200, but received {response.status_code}"

if __name__ == "__main__":
    pytest.main([__file__])
