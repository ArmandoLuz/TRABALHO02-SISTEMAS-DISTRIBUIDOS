import os
from io import BytesIO
from PIL import Image

from settings import settings
import datetime


def save_image(data):
    try:
        image = Image.open(BytesIO(data))
        image_path = f"server/data/{datetime.datetime.now()}.jpg"
        image.save(image_path)
        print(f"Imagem salva com sucesso: {image_path}")
    except Exception as e:
        print(f"Erro ao salvar imagem: {e}")