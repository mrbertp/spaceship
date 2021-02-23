import socket
import datetime


class Comm_Server():

    def __init__(self, ID, address, port):

        self.ID = ID
        self.address = address
        self.port = port
        self.sock = socket.socket()
        self.data = ''

    def listen(self):

        self.sock.bind((self.address, self.port))
        print('Started server at', self.address, self.port)
        print('Waiting for connections...')
        self.sock.listen()
        self.conn, self.addr = self.sock.accept()
        with open('log.txt', 'w') as log:
            log.write('log'+'\t'+str(datetime.datetime.now())+'\n')

        while self.data[-3:] != 'END':
            self.data = self.conn.recv(1024)
            self.data = str(self.data, 'utf-8')
            print(self.data)
            with open('log.txt', 'a') as log:
                log.write(self.data+'\n')

        print('Session closed')

        self.sock.close()


server = Comm_Server(ID='energy', address='localhost', port=12345)
server.listen()