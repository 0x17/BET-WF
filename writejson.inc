embeddedCode Python:

import sys
import os
sys.path.append(os.getcwd())

import json

output_symbols = ['f', 'x', 'ynsa', 'ysa', 'z']
obj = { output_sym: list(gams.get(output_sym)) for output_sym in output_symbols }

with open('output.json', 'w') as fp:
    json.dump(obj, fp)

result_reader.compact_results(obj, 'instance1.json', 'compact.json')

endEmbeddedCode