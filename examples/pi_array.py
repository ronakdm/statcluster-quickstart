import sys
import random
import pickle

job_id = int(sys.argv[1])

x = random.uniform(-1, 1)
y = random.uniform(-1, 1)

result = 1 if x**2 + y**2 <= 1 else 0

pickle.dump(result, open("out/array/pi_%d.p" % job_id, "wb"))