import json
import sys


def from_file(in_filename):
    with open(in_filename, 'r') as fp:
        return json.load(fp)


def compact_results(obj, instance_filename, out_filename):
    with open(instance_filename, 'r') as fp:
        instance = json.load(fp)

    def conv_ix(str_v):
        return int(str_v[1:]) - 1

    def snd_where(pair_list, first, ix=0):
        for pair in pair_list:
            if pair[0] == first:
                return pair[1][ix]
        return -1

    cobj = {
        'objective': obj['f'][0][0],
        'repairs': [
            [ { index[0]:conv_ix(index) for index in pair[0] } for pair in obj['z'] if pair[1][0] > 0 ]
        ],
        'sa_orders': [
            {f'component no. {k}': [snd_where(obj['ysa'], [f'k{k + 1}', f't{t + 1}']) for t in instance['T']] for k in instance['K']}
        ],
        'nsa_orders': [
            {f'component no. {k} damage type {s}': [snd_where(obj['ynsa'], [f'k{k + 1}', f's{s+1}', f't{t + 1}']) for t in instance['T']] for k in instance['K'] for s in instance['S']}
        ],
        'availabilities': [
            [ {'part': pair[0][:3], 'date': pair[0][3] } for pair in obj['x'] if pair[1][0] > 0 ]
        ]
    }
    with open(out_filename, 'w') as fp:
        json.dump(cobj, fp, indent=4, sort_keys=False)


def main(args):
    obj = from_file('output.json')
    compact_results(obj, 'instance1.json', 'compact.json')


if __name__ == '__main__':
    main(sys.argv)
