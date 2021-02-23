import socket


class Comm_Client():

    def __init__(self, ID, address, port):

        self.ID = ID
        self.address = address
        self.port = port
        self.sock = socket.socket()
        self.message = ''
        self.sock.connect((self.address, self.port))
        print('Connected to', self.address, self.port)

        while self.message != 'END':
            self.message = input('> ')
            self.sock.send(bytes(f'[{self.ID}]: {self.message}', 'utf-8'))

        self.sock.close()


client = Comm_Client(ID='NAV', address='localhost', port=12345)
