import socket
import threading

from helpers import save_image
from settings import settings


def handle_client(conn, addr):
    print(f"Conexão recebida de {addr}")

    data = b""
    while True:
        packet = conn.recv(4096)
        if not packet:
            break
        data += packet

    conn.close()

    if data:
        try:
            save_image(data)
        except OSError as e:
            print(f"Erro ao salvar imagem: {e}")


def start_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((settings.HOST, int(settings.PORT)))
    server_socket.listen(5)
    print(f"Servidor rodando em {settings.HOST}:{settings.PORT}")

    while True:
        conn, addr = server_socket.accept()
        threading.Thread(target=handle_client, args=(conn, addr)).start()

if __name__ == "__main__":
    start_server()