import time
from multiprocessing import Process, Queue


def checker(var, queue):
    print(var, 'is being processed...')
    message = str(var) + ' is cool'
    time.sleep(0.5)
    queue.put(message)


def routine(queue):
    running = True
    flag = 5

    while running:

        print('doing something...')
        time.sleep(1)
        print('done')
        checker(flag, queue)

        flag -= 1
        if flag <= 0:
            running = False


if __name__ == '__main__':

    q = Queue()
    var = 'eugh'

    #p1 = Process(target=checker, args=(var, q))
    p2 = Process(target=routine, args=(q, ))

    # p1.start()
    p2.start()
    # p1.join()
    p2.join()

    print('queue:')
    while not q.empty():
        print(q.get())
