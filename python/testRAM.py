import time

a = []
for i in range(1000000):
    print(len(a))
    a.append(' ' * 10**6)
    print(i)
    time.sleep(0.01)

