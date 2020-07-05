#!/usr/bin/python3
#
# M4 processor PDP-11 instruction decoding PLM Analyzer
# Copyright (c) 2020 Viacheslav Ovsiienko <1801BM1@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
import sys
import argparse

def get_x16(mset, mclr, x=16):
    s = ''
    for i in range(x):
        if mset & (1 << (x - 1 - i)):
            if mclr & (1 << (x - 1 - i)):
                s += '.'
            else:
                s += '1'
        elif mclr & (1 << (x - 1 - i)):
            s += '0'
        else:
            s += 'x'
    return s

def createParser():
    p = argparse.ArgumentParser(
        description='M4 processor PLM analyzer, '
                    'Version 20.06a, (c) 1801BM1')
    p.add_argument('src', nargs=1, type=str,
                   help='input binary file(s)', metavar='file')
    p.add_argument ('-b', type=lambda x: int(x,8), nargs='?',
                    default=0, metavar='begin', 
                    help='initial address of scan range')
    p.add_argument ('-e', type=lambda x: int(x,8), nargs='?',
                    default=0xFFFF, metavar='end', 
                    help='end address of scan range')
    return p

def main():
    # Parse the command line
    parser = createParser()
    params = parser.parse_args()
    ba = params.b
    ea = params.e

    # Read the entire binary file
    with open(params.src[0], "rb") as bin_file:
        data = bytes(bin_file.read())
    if (len(data) != 0x10000):
        print('Error: invalid file length %d' % len(data))
        return 1

    # Scan the specified range for byte flag (upper 8)
    mset = 0xFFFF
    mclr = 0xFFFF
    mcnt = 0
    for a in range(ba, ea + 1):
        if data[a] & 0x80:
            mset &= a
            mclr &= ~a
            mcnt += 1
    print("Cnt: %05X, Mask: %s" % (mcnt, get_x16(mset, mclr)))

    # Scan the specified range for address field
    ls = {}
    for a in range(ba, ea + 1):
        v = data[a] & 0x7F 
        if v in ls:
            ls[v][0] += 1
            ls[v][1] &= a
            ls[v][2] &= ~a
        else:
            ls[v] = [1, a, ~a]
    for v in ls:
        print('%02X: %04X %s' % (v, ls[v][0], get_x16(ls[v][1], ls[v][2])))
    return 0

if __name__ == '__main__':
    status = main()
    sys.exit(status)

