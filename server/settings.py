import os
from dotenv import load_dotenv

dotenv_path = os.path.join(os.path.dirname(__file__), '.env')

load_dotenv(dotenv_path)

class Settings:
    def __init__(self, data):
        for key, value in data.items():
            setattr(self, key, value)

data_settings = {
    "HOST": os.getenv("HOST"),
    "PORT": os.getenv("PORT"),
    "LOCAL_DATA_PATH": os.getenv("LOCAL_DATA_PATH"),
}

settings = Settings(data_settings)