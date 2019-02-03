import json
from random import randint
import sys
import random

options = {
    'T': [100, 120],
    'I': [2, 4],
    'K': [4, 6],
    'J': [4, 6],
    'S': [1, 2],
    'reldate': [10, 50],
    'due': [60, 80],
    'nsa0': [10, 20],
    'sa0': [5, 10],
    'csa': [30, 60],
    'cnsa': [15, 30],
    'c': [60, 100],
    'd': [2, 20]
}


def generate_instance(options):
    def rset_rng(set_name):
        return [ix for ix in range(randint(options[set_name][0], options[set_name][1]))]

    def rparam3d(s1, s2, s3, name):
        return [[[randint(options[name][0], options[name][1]) for e3 in s3] for e2 in s2] for e1 in s1]

    def batch_rset(set_letters_str):
        return [rset_rng(sn) for sn in list(set_letters_str)]

    def rparam2d(s1, s2, name):
        return [[randint(options[name][0], options[name][1]) for e2 in s2] for e1 in s1]

    def rparam1d(s1, name):
        return [randint(options[name][0], options[name][1]) for e1 in s1]

    T, I, K, J, S = batch_rset('TIKJS')

    reldate = rparam3d(I, K, J, 'reldate')
    ek = [[[sum(1 if reldate[i][k][j] == t else 0 for i in I for j in J) for t in T] for s in S] for k in K]
    due = rparam3d(I, K, J, 'due')

    nsa0 = rparam2d(K, S, 'nsa0')
    sa0 = rparam1d(K, 'sa0')
    csa = rparam1d(K, 'csa')
    cnsa = rparam2d(K, S, 'cnsa')
    c = rparam1d(I, 'c')
    d = rparam2d(K, S, 'd')

    return dict(T=T, I=I, K=K, J=J, S=S, ek=ek, due=due, nsa0=nsa0, sa0=sa0, csa=csa, cnsa=cnsa, c=c, d=d)


def serialize_to_json(instance, out_filename):
    with open(out_filename, 'w') as fp:
        json.dump(instance, fp, indent=4, sort_keys=True)


def main(args):
    random.seed(23)
    instance = generate_instance(options)
    serialize_to_json(instance, 'instance1.json')


if __name__ == '__main__':
    main(sys.argv)
