import joblib
import random
import numpy as np

n = 100

def secondary():
    x = random.uniform(-1, 1)
    y = random.uniform(-1, 1)

    return 1 if x**2 + y**2 <= 1 else 0

count = np.array(Parallel(n_jobs=-2)(delayed(secondary)() for _ in range(n))).sum()

pi = 4 * count / n
print(pi)