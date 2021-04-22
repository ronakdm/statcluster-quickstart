
import random

n = 100

count = 0
for i in range(n):
    x = random.uniform(-1, 1)
    y = random.uniform(-1, 1)

    if x**2 + y**2 <= 1:
        count += 1

pi = 4 * count / n
print(pi)