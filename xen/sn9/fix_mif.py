#!/usr/bin/env python3
import argparse
import mif


def main(args):
    with open(args.mif_fn) as f:
        mem = mif.load(f)
    with open(args.out_fn, 'w') as fo:
        fo.write(mif.dumps(mem))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog='mif_v')
    parser.add_argument('-f', dest='mif_fn', required=True)
    parser.add_argument('-o', dest='out_fn', required=True)
    args = parser.parse_args()
    main(args)
