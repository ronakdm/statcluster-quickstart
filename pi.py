
import numpy as np

n = 10000

x = np.random.uniform(low=-1, high=1, size=n)
y = np.random.uniform(low=-1, high=1, size=n)
pi = 4 * np.mean(x**2 + y**2 <= 1)

print(pi)