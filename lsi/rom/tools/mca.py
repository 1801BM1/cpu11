#!/usr/bin/python3
#
# Microcode Jump Analyzer for the LSI-11 Microcode
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

def mc(value, pattern):
    ''' Match value with char pattern '''
    mask = 1 << len(pattern)
    for sym in pattern:
        mask >>= 1
        if sym == '1':
            if value & mask == 0:
                return False
            continue
        if sym == '0':
            if value & mask:
                return False
    return True

class Mca(object):
    ''' Microcode Jump Analyzer for LSI-11 Microcode '''
    valid_tc = (
        0x07, 0x0B, 0x0D, 0x0E, 0x13,
        0x15, 0x16, 0x19, 0x1A, 0x1C,
        0x23, 0x25, 0x26, 0x29, 0x2A,
        0x2C, 0x32, 0x34, 0x38, 0x49,
        0x4A, 0x4C, 0x51, 0x52, 0x54,
        0x58, 0x62, 0x64, 0x68, 0x70)

    p_desc = {
        0:  "0_xx_0x0x0x0_xxxxxxxx", #
        1:  "0_xx_0x0x0x0_xxxx1xxx", # -- DC1
        2:  "0_xx_0x0x0x0_xxxxx1xx", # -- DC1
        3:  "0_xx_0x0x0x0_xxxxxx1x", # -- DC1
        4:  "0_xx_0x0x0x0_10xx000x", # -- DC1
        5:  "0_xx_0x0x0x0_1x0x000x", # -- DC1
        6:  "x_xx_0x0x0x0_10xxxxxx", # -- DC1
        7:  "x_xx_0x0x0x0_1x0xxxxx", # -- DC1
        8:  "x_xx_0x0x0x0_10xxxxx1", # -- DC1
        13: "x_xx_0x0x0x0_10001101", # ** DC1
        14: "x_xx_0x0x0x0_0001xxxx", # -* DC1
        27: "x_xx_0x0x0x0_1x0xxxx1", # -- DC1
        28: "x_xx_0x0x0x0_00000000", # ** DC1
        30: "x_xx_0x0x0x0_01110xxx", # ** DC1
        32: "x_xx_0x0x0x0_01111010", # *- DC1
        33: "x_xx_0x0x0x0_x0000xxx", # *- DC1
        36: "x_xx_0x0x0x0_0111111x", # *- DC1
        37: "x_xx_0x0x0x0_1000101x", # ** DC1
        38: "x_xx_0x0x0x0_10001100", # ** DC1
        39: "x_xx_0x0x0x0_0000101x", # ** DC1
        40: "x_xx_0x0x0x0_00001100", # ** DC1
        41: "x_xx_0x0x0x0_0111100x", # ** DC1
        42: "x_xx_0x0x0x0_00001101", # ** DC1
        43: "x_xx_0x0x0x0_0000100x", # ** DC1
        44: "x_xx_0x0x0x0_10001000", # *- DC1
        45: "x_xx_0x0x0x0_10001001", # *- DC1
        52: "x_xx_0x0x0x0_1111xxxx", # *- DC1

        9:  "x_xx_x0x00xx_xxxx1xxx", # -- 13, 51, 52 (43 not used)
        10: "x_xx_x0x00xx_xxx1xxxx", # -- 13, 51, 52 (43 not used)
        11: "x_xx_x0x00xx_xx1xxxxx", # -- 13, 51, 52 (43 not used)
        12: "x_xx_00x00xx_xxxxxxxx", # ** 13
        15: "x_xx_00x00xx_xxxxx11x", # -- 13
        31: "x_10_00x00xx_xxxxxxxx", # -- 13
        51: "x_xx_x0x000x_xxxxxxxx", # ** 51
        54: "x_xx_x0x000x_xxxxx11x", # -- 51
        66: "x_xx_x0x00x0_xxxxxxxx", # *- 52

        16: "x_xx_xxxx000_xxx1xxxx", # -- 38, 58, 68, 70
        17: "x_xx_xxxx000_xx1xxxxx", # -- 38, 58, 68, 70
        18: "x_xx_xxxx000_x1xxxxxx", # -- 38, 58, 68, 70
        20: "x_xx_xxxx000_xxxxx1xx", # -- 38, 58, 68, 70
        21: "x_xx_xxxx000_xxxxxxx1", # -- 38, 58, 68, 70
        23: "x_xx_xxxx000_1110xxxx", # -- 38, 58, 68, 70
        24: "x_xx_xxxx000_00000000", # -- 38, 58, 68, 70
        76: "x_xx_xxxx000_01110x1x", # -- 38, 58, 68, 70
        77: "x_xx_xxxx000_01110x0x", # -- 38, 58, 68, 70
        19: "x_xx_xxx0000_xxxxxxxx", # ** 70
        22: "x_xx_xx0x000_xxxxxxxx", # ** 68
        25: "x_xx_x0xx000_xxxxxxxx", # ** 58
        26: "x_xx_0xxx000_xxxxxxxx", # ** 38

        29: "x_xx_0x00x0x_00000xxx", # *- 25
        35: "x_xx_0x00x0x_00000x10", # *- 25
        63: "x_xx_0x00x0x_10000xxx", # *- 25
        64: "x_xx_0x00x0x_01xxxxxx", # *- 25
        65: "x_xx_0x00x0x_11xxxxxx", # *- 25
        78: "x_xx_0x00x0x_1010xxxx", # *- 25
        79: "x_xx_0x00x0x_1011xxxx", # *- 25

        55: "x_xx_000xxxx_1xxxxxxx", # -- 07, 0B, 0D, 0E
        56: "x_xx_000xxxx_x1xxxxxx", # -- 07, 0B, 0D, 0E
        57: "x_x1_000xxxx_xxxxxxxx", # -- 07, 0B, 0D, 0E
        58: "x_1x_000xxxx_xxxxxxxx", # -- 07, 0B, 0D, 0E
        59: "x_xx_0000xxx_xxxxxxxx", # *- 07
        60: "x_xx_000x0xx_xxxxxxxx", # *- 0B
        61: "x_xx_000xx0x_xxxxxxxx", # *- 0D
        62: "x_xx_000xxx0_xxxxxxxx", # *- 0E

        34: "x_xx_x0x0x00_xxxxxxxx", # *- 54
        46: "x_x1_0xx00x0_xxxxxxxx", # *- 32
        47: "x_x1_00x0xx0_xxxxxxxx", # *- 16
        48: "x_x1_0x000xx_xxxxxxxx", # *- 23
        49: "x_1x_xx00x00_1xxxxxxx", # *- 64
        50: "x_1x_x00xx00_1xxxxxxx", # *- 4C
        71: "x_1x_0x0xx00_xxxxxxxx", # *- 2C
        72: "x_1x_x00x00x_xxxxxxxx", # *- 49

        67: "x_x1_00x0x0x_xxxxxxxx", # *- 15
        68: "x_11_00x0x0x_11xxxxxx", # *- 15
        53: "x_xx_00xx00x_1xxxxxxx", # -- 19
        70: "x_xx_00xx00x_xxx1xxxx", # -- 19
        75: "x_xx_00xx00x_xxxxxxxx", # *- 19

        69: "x_xx_00xx0x0_1000xxxx", # *- 1A
        73: "x_xx_00xx0x0_0001xxxx", # *- 1A
        80: "x_xx_00xx0x0_0110xxxx", # *- 1A
        81: "x_xx_00xx0x0_0100xxxx", # *- 1A
        82: "x_xx_00xx0x0_0010xxxx", # *- 1A
        83: "x_xx_00xx0x0_0000xxxx", # *- 1A

        95: "x_xx_00xxx00_xxxx1xxx", # REF
        84: "x_xx_xx000x0_xx1xxx01", # FII
        88: "x_xx_xx000x0_xx1xxx1x", # FII
        85: "x_xx_0xx0x00_xx1xxx01", # EII
        86: "x_xx_0xx0x00_xx1xxx1x", # EII
        87: "x_xx_0x00xx0_xx100001", # QIR
        90: "x_xx_0x00xx0_xx10001x", # QIR
        91: "x_xx_0x00xx0_xxx001xx", # QIR
        92: "x_xx_0x00xx0_xxxx1xxx", # QIR

        89: "x_xx_x00x0x0_x00000xx", # RNI
        99: "x_xx_x00x0x0_x0x00000", # RNI
        93: "x_xx_x00x0x0_x0100001", # RNI
        96: "x_xx_x00x0x0_x010001x", # RNI
        97: "x_xx_x00x0x0_x0x001xx", # RNI
        98: "x_xx_x00x0x0_x0xx1xxx", # RNI
        94: "x_xx_x00x0x0_x0x10xxx", # RNI
    }
#
# self.p_desc[n][0:1]
# self.p_desc[n][2:4]
# self.p_desc[n][5:12]
# self.p_desc[n][13:21]
#
    s_lta = (0, 12, 13, 19, 22, 25, 26, 28, 29, 30,
            32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
            42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
            52, 59, 60, 61, 62, 63, 64, 65, 66, 67,
            68, 69, 71, 72, 73, 75, 78, 79, 80, 81,
            82, 83, 84, 85, 86, 87, 88, 89, 90, 91,
            92, 93, 94, 95, 96, 97, 98, 99)

    s_lts = (0, 12, 13, 14, 19, 22, 25, 26, 28, 30,
            37, 38, 39, 40, 41, 42, 43, 51, 84, 85,
            86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
            96, 97, 98, 99)

    s_tsr = ((6, 7, 21, 43, 53),                # tsr[0]
             (8, 14, 15, 20, 27, 54),           # tsr[1]
             (0, 13, 19, 22, 25, 26, 28, 30,    # tsr[2]
              37, 38, 39, 40, 41, 42, 43))
    s_pta = ((4,  5,  13, 24, 30, 33, 35, 36, 37, 38,
              43, 45, 49, 50, 52, 64, 69, 70, 71, 77,
              78, 79, 80, 83, 85, 86, 87, 89, 92, 93,
              95, 98, 99),
             (28, 36, 42, 43, 44, 46, 47, 50, 53, 64,
              67, 68, 69, 71, 81, 83, 84, 85, 86, 88,
              89, 90, 94, 96, 99),
             (13, 16, 33, 43 ,44, 45, 48, 50, 55, 63,
              64, 72, 73, 78 ,79, 85, 86, 91, 92, 95,
              97, 98),
             (3,  9,  13, 17, 30, 35, 36, 43, 45, 46,
              48, 56, 64, 75, 78, 80, 82, 85, 86, 89,
              92, 94, 95, 98, 99),
             (2,  10, 13, 18, 30, 33, 43, 44, 45, 47,
              48, 57, 64, 68, 71, 73, 78, 81, 84, 88,
              92, 94, 95, 98),
             (1,  11, 13, 19, 23, 25, 29, 30, 33, 34,
              43, 44, 58, 63, 64, 72, 73, 75, 76, 77,
              79, 80, 83, 94),
             (0,  19, 22, 30, 31, 36, 37, 38, 39, 40,
              41, 42, 43, 46, 47, 48, 49, 50, 59, 61,
              63, 64, 65, 66, 69, 75, 76, 77, 79, 80,
              81, 82, 83, 85, 86, 90, 96),
             (12, 25, 26, 34, 44, 45, 59, 62, 66, 73,
              79, 80, 81, 82, 84, 85, 86, 87, 88, 90,
              91, 93, 94, 96, 97),
             (19, 22, 25, 26, 30, 51, 59, 69, 71, 72,
              73, 75, 78, 80, 81, 82, 83, 84, 85, 86,
              88, 89, 90, 91, 92, 94, 95, 96, 97, 98,
              99),
             (31, 34, 52, 60 ,61, 62, 69, 73, 80, 81,
              82, 92, 95, 98),
             (30, 32, 52, 75 ,76, 77, 84, 85, 86, 88))

    def __init__(self, tc):
        self.tc = tc            # translation code
        self.p_list = []
        self.dep_q = False     # q dependent
        self.dep_s = 1         # ts dependent
        for n in Mca.p_desc:
            if mc(tc, self.p_desc[n][5:12]):
                self.p_list.append(n)
                if self.p_desc[n][0:1] != 'x':
                    self.dep_q = True
                if self.p_desc[n][2:4] != 'xx':
                    self.dep_s = 4        
        return

    def calc(self, q, ts, tr):
        pl = {}
        for pn in self.p_list:
            pl[pn] = (mc(q,  self.p_desc[pn][0:1]) and
                      mc(ts, self.p_desc[pn][2:4]) and
                      mc(tr, self.p_desc[pn][13:21]))
        pta = 0
        for i in range(11):
            for p in self.s_pta[i]:
                x = pl.get(p)
                if x is not None and x:
                    pta |= 1 << i
                    break
        tsr = 0
        for i in range(3):
            for p in self.s_tsr[i]:
                x= pl.get(p)
                if x is not None and x:
                    tsr |= 1 << i
                    break
        lta = 0
        for p in self.s_lta:
            x = pl.get(p)
            if x is not None and x:
                lta = 1
                break
        lts = 0
        for p in self.s_lts:
            x = pl.get(p)
            if x is not None and x:
                lts = 1
                break
        return (pta, tsr, lta, lts)

    def get_x10(self, mset, mclr, x=10):
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

    def show_x10(self, mset, mclr):
        assert (mset & mclr) == 0
        s = self.get_x10(mset, mclr)
        if self.dep_s != 1:
            return s[:2] + '_' + s[2:]
        return s[2:]

    def get_stat(self):
        addr = {}
        qt = 0
        for ts in range(self.dep_s):
            for tr in range(256):
                if self.dep_q:
                    if ((tr & 0x70) == 0x70) or ((tr & 0x70) == 0x00):
                        qt = 1
                    else:
                        qt = 0
                tra = self.calc(qt, ts, tr)
                mask = tr | ts << 8
                if tra[2]:
                    pta = tra[0]
                else:
                    pta = 0     # zero address for no jump
                if pta not in addr:
                    addr[pta] = [0, 0x3FF, 0x3FF,
                                [0] * 5, [0x3FF] * 5, [0x3FF] * 5]
                addr[pta][0] += 1
                addr[pta][1] &= mask
                addr[pta][2] &= ~mask
                if tra[3]:
                    tsr = tra[1] & 0x03
                else:
                    tsr = 4
                addr[pta][3][tsr] += 1
                addr[pta][4][tsr] &= mask
                addr[pta][5][tsr] &= ~mask
        return addr

    def show_addr(self, am):
        stat = {}
        qt = 0
        nam = 0
        for ts in range(self.dep_s):
            for tr in range(256):
                if self.dep_q:
                    if ((tr & 0x70) == 0x70) or ((tr & 0x70) == 0x00):
                        qt = 1
                    else:
                        qt = 0
                tra = self.calc(qt, ts, tr)
                mask = tr | ts << 8
                if tra[2]:
                    pta = tra[0]
                else:
                    pta = 0     # zero address for no jump
                if am != pta:
                    continue
                if mask not in stat:
                    stat[mask] = 1
                    continue
                stat[mask] += 1
        if stat:
            for mask in stat:
                print('  %s:%02X' %
                      (self.show_x10(mask, ~mask), stat[mask]), end='')
                nam += 1
                if nam >= 8:
                    print('')
                    nam = 0
        if nam:
            print('')
        return

    def show_stat(self, stat, am):
        print('\nTranslation code: 0x%02X' % self.tc)
        print('P-list: ', self.p_list)
        print('S-dependency: ', self.dep_s != 1)
        print('Q-dependency: ', self.dep_q)
        if stat is None:
            return
        addr = []
        jtot = 0
        for x in stat:
            addr.append(x)
        addr.sort()
        for x in addr:
            jtot += stat[x][0]
            if am >= 0 and am != x:
                continue
            print('0x%03X: cnt: %03X, tr: %s  ' %
                  (x, stat[x][0],
                   self.show_x10(stat[x][1], stat[x][2])),
                   end = '')
            for i in range(5):
                print(' %d:%03X:%s' %
                     (i, stat[x][3][i], self.get_x10(stat[x][4][i],
                                                     stat[x][5][i], 8)),
                     end = '')
            print('')
        if am >= 0:
            self.show_addr(am)
        print('Total jump: 0x%03X' % jtot)

def createParser():
    p = argparse.ArgumentParser(
        description='Microcode Jump Analyzer for LSI-11 Microcode, '
                    'Version 20.05a, (c) 1801BM1')
    p.add_argument ('tc', nargs='*', type=lambda x: int(x,0),
                     help='translation code in hex (i.e. 0x1A)')
    p.add_argument ('-a', '--addr', type=lambda x: int(x,0), nargs='?',
                     help='optional microcode address in hex')
    return p

def main():
    parser = createParser()
    params = parser.parse_args()
    addr = params.addr
    tlist = params.tc
    if addr is None:
        addr = -1
        if not tlist:
            print('"mca --help" to get brief description')
            return 1
    # Check whether specified tcs are valid
    for tc in tlist:
        if tc not in Mca.valid_tc:
            print("Invalid tc value, not in the list (hex 0xNN):")
            for x in Mca.valid_tc:
                print(' %02X' % x, end='')
            print('\n')
            return 1
    # Show the statistics for specified tcs
    if tlist:
        for tc in tlist:
            mca = Mca(tc)
            stat = mca.get_stat()
            mca.show_stat(stat, addr)
    return 0

if __name__ == '__main__':
    status = main()
    sys.exit(status)

# todo
# tc - simple tc
# tc [tc] - tc list
# tc - -a addr - full stat tc/addr
# -a addr - analyze all tc for addr
#