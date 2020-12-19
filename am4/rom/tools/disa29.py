#!/usr/bin/python3
#
# Disassembler for M4 processor Am2900 microcode
# Copyright 2015 Viacheslav Ovsiienko <1801BM1@gmail.com>
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
# Command line example:
#    meta29.py am29_m4.def m4.mic -l m4.lst -o m4.mif
#
import argparse
import sys
import re
import os

# concatenation patterns
CON  = '#'
CONT = '\n' + CON + '\t'
CONS = ' ' + CON + ' '

MCU = (20, 4)
NAF = (44, 12)
CC  = (25, 4)

# mnemo, addr, cond
mcu_t = (
    ('jz  ', False, False),
    ('cjs ', True, True),
    ('jmap', False, False),
    ('cjp ', True, True),
    ('push', False, True),
    ('jsrp', True, True),
    ('cjv ', True, True),
    ('jrp ', True, True),
    ('rfct', False, True),
    ('rpct', True, True),
    ('crtn', False, True),
    ('cjpp', True, True),
    ('ldct', False, False),
    ('loop', False, True),
    ('cont', False, False),
    ('jp  ', True, False),
)

# PDP-11 instruction predecoder map entries (0x11 xor correction is done)
map_t = {
    0x10: 'undef',
    0x11: 'halt',
    0x12: 'wait',
    0x13: 'rti/rtt',
    0x15: 'bpt',
    0x16: 'iot',
    0x17: 'reset',
    0x18: 'mark',
    0x19: 'sxt',
    0x1A: 'xor',
    0x1B: 'sob',
    0x1C: 'adc',
    0x1D: 'mfps',
    0x1E: 'fis',
    0x1F: 'jmp',
    0x01: 'bis',
    0x02: 'cmp',
    0x03: 'clr',
    0x04: 'ror',
    0x05: 'com',
    0x06: 'rol',
    0x07: 'inc',
    0x08: 'sub',
    0x09: 'dec',
    0x0A: 'asr',
    0x0B: 'neg',
    0x0C: 'asl',
    0x0D: 'bit',
    0x0E: 'br',
    0x0F: 'bic',
    0x30: 'bicb',
    0x31: 'bis Rs, Rd',
    0x32: 'bisb',
    0x33: 'clr Rd',
    0x34: 'clrb',
    0x35: 'com Rd',
    0x36: 'comb',
    0x37: 'inc Rd',
    0x38: 'incb',
    0x39: 'dec Rd',
    0x3A: 'decb',
    0x3B: 'neg Rd',
    0x3C: 'negb',
    0x3D: 'tst',
    0x3E: 'tstb',
    0x3F: 'mtps',
    0x20: 'mov',
    0x21: 'mov Rs, Rd',
    0x22: 'movb',
    0x23: 'movb Rd, Rs',
    0x24: 'add',
    0x25: 'add Rs, xx',
    0x26: 'jsr',
    0x27: 'rts',
    0x28: 'emt',
    0x29: 'trap',
    0x2A: 'sub Rd, Rs',
    0x2B: 'cmp Rs, Rd',
    0x2C: 'cmpb',
    0x2D: 'bit Rs, Rd',
    0x2E: 'bitb',
    0x2F: 'bic Rs, Rd',
    0x50: 'swab',
    0x51: 'clx',
    0x52: 'sex',
    0x53: 'ash',
    0x54: 'ashc',
    0x55: 'swab Rd',
    0x56: 'mul',
    0x59: 'div',
    0x5B: 'sbc Rd',
    0x5C: 'adc Rd',
    0x40: 'adcb',
    0x42: 'sbc',
    0x43: 'sbcb',
    0x44: 'ror Rd',
    0x45: 'rorb',
    0x47: 'rol Rd',
    0x48: 'rolb',
    0x4A: 'asr Rd',
    0x4B: 'asrb',
    0x4D: 'asl Rd',
    0x4E: 'aslb',
    0x65: 'add Rs, Rd',
    0x7D: 'tst Rd'
}

OR_nEN = (24, 1)
OMX = (41, 3)

omx_t = (
    'OR_MD',    # destination mode
    'OR_MS',    # source mode
    'OR_RR',    # register mode
    'OR_IV',    # interrupt vector
    'OR_LD',    # bootloader mode
    'OR_BT',    # byte exchange
    'OR_TC',    # timer/counter
    'OR_R67'    # not SP/PC
)

ALU_S = (0, 3)  # ALU source control
ALU_F = (3, 3)  # ALU function control
ALU_Q = (6, 3)  # ALU destination control
ALU_M = (0, 10)  # integrated for tst and none

ALU_TST  = 0b0001011100  # or 0, NOP, ZA
ALU_TSTD = 0b0001011111  # or 0, NOP, DZ
ALU_NOPA = 0b0001100111  # and 0, NOP, DZ
ALU_N  = (9, 11)

alus_t = ('AQ', 'AB', 'ZQ', 'ZB', 'ZA', 'DA', 'DQ', 'DZ')
aluf_t = ('add', 'subr', 'subs', 'or', 'and', 'nand', 'xor', 'xnor')
aluq_t = ('QREG', 'NOP', 'RAMA', 'RAMF', 'RAMQD', 'RAMD', 'RAMQU', 'RAMU')

ALU_CI = (9, 1)
ALU_AS = (10, 1)
ALU_BS = (11, 1)
ALU_A = (12, 4)
ALU_B = (16, 4)

porta_t = ('Ad0', 'Ad1', 'As0', 'As1')
portb_t = ('Bs0', 'Bs1', 'Bd0', 'Bd1')

cc_t = (
    'CCC',  'CCV',  'CCN',  'CCZ',	'CCT',  'CCIN', 'CCE',  'CCA',
    'CCCN',	'CCVN', 'CCNN',	'CCZN', 'CCTN',	'CCI', 'CCEN', 'CCAN'
)

D_MUX = (33, 2)
D_IMM = (40, 16)
S_MUX = (44, 12)

dmux_t = ('dpsw', 'dbus', 'dimm', 'dswp')

REG_C = (29, 4)
pswc_t = (
    'SPSW', 'WPSW', 'BPSW', 'LPSW',
    'SPSW' + CONS + 'CSAV', 'WPSW' + CONS + 'CSAV',
    'BPSW' + CONS + 'CSAV', 'LPSW' + CONS + 'CSAV'
)
TTL_M = (50, 3)
ttl_t = (
    'NONE0', 'INITC', 'REFC', 'REFS',
    'INITS', 'NONE5', 'ACLOC', 'EVENTC'
)
QIO = (35, 9)
qio_t = (
    'WAIT', 'IOEN', 'DOUT', 'SYNC',
    'WFIN', 'IAKO', 'DIN', 'RDIN', 'WTBT'
)
#
# Table scanned from documentation
#
# ASHCR	    1111 0101 0110 ->  F56, RAMQD
# RORB  	0101 X1X1 11XX -> *55C, RAMD
# ASRB	    0111 X1X1 0X00 -> *750, RAMD
# ROR   	1001 X101 11XX -> *95C, RAMD
# ASR 	    1011 X101 0110 -> *B56, RAMD
# ASHR  	1011 X101 0110 -> *B56, RAMD - dup
# ASHCL 	0011 1010 1010 ->  3AA, RAMQU
# ASLB  	0010 1X11 1001 -> *2B9, RAMU
# ROLB  	0010 1X11 1011 -> *2BB, RAMU
# ROL   	0011 1X10 1011 -> *3AB, RAMU
# ASL       0011 1X10 1001 -> *3A9, RAMU
# ASHL  	0011 1X10 1001 -> *3A9, RAMU - dup
#
ash_t = {                   # actually used in microcode
    0x2B9: ('ASLB', 'U'),   # 0010 1X11 1001    RAMU
    0x2BB: ('ROLB', 'U'),   # 0010 1X11 1011    RAMU
    0x3A9: ('ASL', 'U'),    # 0011 1X10 1001    RAMU
    0x3AA: ('ASHCL', 'U'),  # 0011 1010 1010    RAMQU
    0x3AB: ('ROL', 'U'),    # 0011 1X10 1011    RAMU
    0x55C: ('RORB', 'D'),   # 0101 X1X1 11XX    RAMD
    0x756: ('ASRB', 'D'),   # 0111 X1X1 0X?0    RAMD
    0x95C: ('ROR', 'D'),    # 1001 X101 11XX    RAMD
    0xB56: ('ASR', 'D'),    # 1011 X101 0110    RAMD
    0xF55: ('ASHXR', 'D'),  # 1111 0101 0101    RAMQD
    0xF56: ('ASHCR', 'D'),  # 1111 0101 0110    RAMQD
}

def zhex(value, width):
    s = hex(value)[2:].upper()
    if width == 0:
        return s
    return s.rjust((width + 3) // 4, '0')


class Bf(object):
    ''' Arbitrary records data buffer '''

    def __init__(self, size=1024):
        self.ecnt = 0           # error counter
        self.wcnt = 0           # warning counter
        self.width = 8          # record width
        self.size  = size       # buffer size
        self.aradx = 16         # address radix
        self.dradx = 16         # data radix
        self.data = [None] * size
        self.npas = 0
        self.flst = None
        self.label = []
        self.word = 0

    def close_file(self, file):
        if file is not None:
            file.close()
        return

    def load_mif(self, name):
        #
        # Add the default file name extension if needed
        #
        if not os.path.splitext(name)[1]:
            name += '.mif'
        try:
            f = open(name, 'r', -1, None, None)
        except OSError as err:
            raise RuntimeError(err)
        #
        # Compiled regular expressions
        #
        re_comment = re.compile(r'(?:--)')
        re_depth   = re.compile(r'DEPTH\s*=\s*([0-9]+)\s*;\s*$')
        re_width   = re.compile(r'WIDTH\s*=\s*([0-9]+)\s*;\s*$')
        re_aradx   = re.compile(r'ADDRESS_RADIX\s*=\s*(HEX|DEC|OCT|BIN)\s*;\s*$')
        re_dradx   = re.compile(r'DATA_RADIX\s*=\s*(HEX|DEC|OCT|BIN)\s*;\s*$')
        re_skip    = re.compile(r'(BEGIN$|^END|^CONTENT)')
        re_single  = re.compile(r'([A-Z0-9]+)\s*:\s*([A-Z0-9]+)\s*;\s*$')
        re_range   = re.compile(
                r'\[([A-Z0-9]+)..([A-Z0-9]+)\]\s*:\s*([A-Z0-9]+)\s*;\s*$')
        lnum = 0
        for text in f:
            lnum += 1
            line = text.strip('\r\n \t')
            if not line:
                continue
            line = line.upper()
            match = re_comment.match(line)
            if match is not None:
                line = line[0:match.start()]
                line = line.strip('\r\n \t')
                if not line:
                    continue

            match = re_single.match(line)
            if match is not None:
                addr = int(match.group(1), self.aradx)
                data = int(match.group(2), self.dradx)
                if addr >= self.size:
                    raise SyntaxError('line %d addr out of range: %s' %
                                     (lnum, text))
                if data >= 1 << self.width:
                    raise SyntaxError('line %d data out of range: %s' %
                                     (lnum, text))
                self.data.insert(addr, data)
                continue
            match = re_range.match(line)
            if match is not None:
                beg = int(match.group(1), self.aradx)
                end = int(match.group(2), self.aradx) + 1
                data = int(match.group(3), self.dradx)
                for addr in range(beg, end):
                    if addr >= self.size:
                        raise SyntaxError('line %d addr out of range: %s' %
                                         (lnum, text))
                    if data >= 1 << self.width:
                        raise SyntaxError('line %d data out of range: %s' %
                                         (lnum, text))
                    self.data.insert(addr, data)
                continue

            match = re_skip.match(line)
            if match is not None:
                continue
            match = re_depth.match(line)
            if match is not None:
                self.size = int(match.group(1), 10)
                self.data = [None] * self.size
                continue
            match = re_width.match(line)
            if match is not None:
                self.width = int(match.group(1), 10)
                continue

            match = re_aradx.match(line)
            if match is not None:
                radix = match.group(1)
                if radix == 'HEX':
                    self.aradx = 16
                    continue
                if radix == 'DEC':
                    self.aradx = 10
                    continue
                if radix == 'OCT':
                    self.aradx = 8
                    continue
                if radix == 'BIN':
                    self.aradx = 2
                    continue
                raise SyntaxError('line %d invalid radix: %s' % (lnum, text))

            match = re_dradx.match(line)
            if match is not None:
                radix = match.group(1)
                if radix == 'HEX':
                    self.dradx = 16
                    continue
                if radix == 'DEC':
                    self.dradx = 10
                    continue
                if radix == 'OCT':
                    self.dradx = 8
                    continue
                if radix == 'BIN':
                    self.dradx = 2
                    continue
                raise SyntaxError('line %d invalid radix: %s' % (lnum, text))

            raise SyntaxError('line %d syntax error: %s' % (lnum, text))
        self.close_file(f)
        return

    def set_pass(self, npas):
        self.npas = npas
        if npas == 1:
            self.label = []
        return

    def set_list(self, flst):
        self.flst = flst
        return

    def fiw(self, field):
        start = field[0]
        width = field[1]
        assert(start >= 0)
        assert(width >= 0)
        assert(start < self.width)
        assert(start + width <= self.width)
        return (self.word >> start) & ((1 << width) - 1)

    def get_raw(self, addr):
        bmask = bin(self.word)[2:]
        bmask = bmask.rjust(self.width, '0')
        line = ''
        if addr & 0x7 == 0 and map_t.get(addr >> 3) is not None:
            line += '; "%s" opcode\n' % map_t.get(addr >> 3)
        line += '; %04X\t%s.%s.%s.%s\n' % (addr, bmask[0:16], bmask[16:32],
                                           bmask[32:47], bmask[47:])
        return line

    def get_mcu(self, addr, mcu):
        line = ''
        if mcu_t[mcu][1]:
            naf = self.fiw(NAF)
            if naf >= self.size:
                line = '; Warning: next address is out of range\n'
                self.wcnt += 1
        if addr in self.label:
            line += 'L%03X:' % addr
        line += '\t%s' % mcu_t[mcu][0]
        if mcu_t[mcu][1]:
            line += '\tL%03X' % naf
        if mcu == 0:
            return line
        if self.fiw(OR_nEN) == 0:
            if mcu_t[mcu][1]:
                line += ', '
            else:
                line += '\t'
            line += omx_t[self.fiw(OMX)]
            if self.fiw(CC) or mcu_t[mcu][2]:
                line += CONS + cc_t[self.fiw(CC)]
        elif self.fiw(CC) or mcu_t[mcu][2]:
            if mcu_t[mcu][1]:
                line += ', '
            else:
                line += '\t'
            line += cc_t[self.fiw(CC)]
        return line

    def get_alu(self):
        bshown = 0
        line = CONT
        alum = self.fiw(ALU_M)
        alus = self.fiw(ALU_S)
        aluq = self.fiw(ALU_Q)
        if alum == ALU_TST:
            line += 'tst\t'
        elif alum == ALU_TSTD:
            line += 'tstd'
            if self.fiw(ALU_N) == 0:
                return line
            line += '\t'
        elif alum == ALU_NOPA:
            line += 'nopa'
            if self.fiw(ALU_N) == 0:
                if self.fiw(D_MUX) == 3 and (self.fiw(REG_C) & 1) == 0:
                    line = ''
                return line
            line += '\t'
        else:
            line += aluf_t[self.fiw(ALU_F)] + '\t'
        if (alum != ALU_TST and alum != ALU_TSTD) or \
            self.fiw(ALU_B) or self.fiw(ALU_BS) or \
            alus == 1 or alus == 3 or aluq >= 2:
            if self.fiw(ALU_BS):
                line += portb_t[self.fiw(ALU_B) & 3]
            else:
                line += 'B%d' % self.fiw(ALU_B)
            bshown = 1
        if self.fiw(ALU_AS) or (alus & 3) <= 1 or aluq == 2:
            if bshown:
                line += CONS
            if self.fiw(ALU_AS):
                line += porta_t[self.fiw(ALU_A) & 3]
            else:
                line += 'A%d' % self.fiw(ALU_A)
        if alum == ALU_TST or alum == ALU_TSTD or alum == ALU_NOPA:
            return line
        line += ', C%d' % self.fiw(ALU_CI)
        line += ', ' + aluq_t[aluq]
        line += ', ' + alus_t[alus]
        return line

    def get_dmux(self):
        line = ''
        dmux = self.fiw(D_MUX)
        alum = self.fiw(ALU_M)
        if alum == ALU_NOPA and dmux == 3:
            return line
        if alum == ALU_TST and dmux == 3:
            return line
        if self.fiw(ALU_S) >= 5:
            line = CONT + dmux_t[dmux]
            if dmux_t[dmux] == 'dimm':
                line += '\t0x%X' % self.fiw(D_IMM)
            if self.fiw(ALU_Q) != 2 and dmux == 3:
                line += '\n; Warning: dswp combinatorial loop'
                self.wcnt += 1
        else:
            if dmux == 3:
                line = ''
            else:
                line = CONT + dmux_t[dmux]
                if dmux_t[dmux] == 'dimm':
                    line += '\t0x%X' % self.fiw(D_IMM)
        return line

    def get_shift(self):
        line = ''
        q = self.fiw(ALU_Q)
        s = self.fiw(S_MUX)
        if q < 4:
            return line
        line = CONT + 'shift\t'
        sh = ash_t.get(s)
        if sh is None:
            line += 'B#' + bin(s)[2:]
            line += '\n; Warning: unrecognized shift configuration'
            self.wcnt += 1
            return line
        line += sh[0]
        if sh[1] == 'U' and q & 2 != 2:
            line += '\n; Warning: shift configuration requires RAMU/RAMQU'
            self.wcnt += 1
            return line
        if sh[1] == 'D' and q & 2 != 0:
            line += '\n; Warning: shift configuration requires RAMD/RAMQD'
            self.wcnt += 1
            return line
        return line

    def get_rc(self):
        line = ''
        rc = self.fiw(REG_C)
        if rc == 0:
            return line
        if rc & 1:
            line = CONT + 'cpsw\t' + pswc_t[rc >> 1]
        else:
            if rc & 2:
                line += CONT + 'pl\t' + '0x%X' % self.fiw(NAF)
            if rc & 4:
                line += CONT + 'ir'
            if rc & 8:
                line += CONT + 'ttl'
                if self.fiw(TTL_M):
                    line += '\t' + ttl_t[self.fiw(TTL_M)]
        return line

    def get_io(self):
        shown = 0
        line = ''
        rc = self.fiw(QIO)
        if rc & 0x18 == 0x18:
            line = CONT + 'dreq'
        if rc & 3 == 2 and rc & 0x8:
            if self.fiw(NAF) == 0x2C and self.fiw(MCU) == 0xF:
                line += CONT + 'nqio'  # workaround for inactive silly RDIN
            return line
        line = CONT + 'qio'
        rc = rc ^ 0x88
        if rc == 0x88:
            return line + '\tRSYNC'
        rc = rc ^ 0x2
        for i in range(9):
            if rc & (1 << i):
                if shown:
                    line += CONS
                else:
                    shown = 1
                    line += '\t'
                line += qio_t[i]
        if rc & 0x80 == 0:
            if shown:
                line += CONS
            else:
                line += '\t'
            line += 'NORD'
        return line


    def get_hint(self):
        d = dmux_t[self.fiw(D_MUX)]
        d = d[1:].upper()
        if d == 'IMM':
            d = '0x' + zhex(self.fiw(D_IMM), 16)
        s = alus_t[self.fiw(ALU_S)]
        r = s[0]
        s = s[1]
        if self.fiw(ALU_AS):
            if self.fiw(ALU_A) & 2:
                a = 'Rs'
            else:
                a = 'Rd'
        else:
            a = 'R%d' % self.fiw(ALU_A)
        if self.fiw(ALU_BS):
            if self.fiw(ALU_B) & 2:
                b = 'Rd'
            else:
                b = 'Rs'
        else:
            b = 'R%d' % self.fiw(ALU_B)
        if r == 'A':
            r = a
        elif r == 'D':
            r = d
        else:
            assert(r == 'Z')
        if s == 'A':
            s = a
        elif s == 'B':
            s = b
        elif s == 'Q':
            s = 'Q'
        else:
            assert(s == 'Z')
        f = self.fiw(ALU_F)
        c = self.fiw(ALU_CI)
        if f == 0:          # add R + S
            if c:
                c = ' + 1'
            else:
                c = ''
            if r == 'Z':
                f = s + c
            elif s == 'Z':
                f = r + c
            else:
                f = r + ' + ' + s + c
        elif f == 1:        # subr S - R
            if c:
                c = ''
            else:
                c = ' - 1'
            if r == 'Z':
                f = s + c
            elif s == 'Z':
                f = '-' + r + c
            else:
                f = s + ' - ' + r + c
        elif f == 2:        # subs R - S
            if c:
                c = ''
            else:
                c = ' - 1'
            if s == 'Z':
                f = r + c
            elif r == 'Z':
                f = '-' + s + c
            else:
                f = r + ' - ' + s + c
        elif f == 3:        # or   R | S
            if r == 'Z':
                f = s
            elif s == 'Z':
                f = r
            else:
                f = r + ' | ' + s
        elif f == 4:        # and  R & S
            if r == 'Z' or s == 'Z':
                f = 'Z'
            else:
                f = r + ' & ' + s
        elif f == 5:        # nand ~R & S
                f = '~' + r + ' & ' + s
        elif f == 6:        # xor  R ^ S
                f = r + ' ^ ' + s
        else:               # nxor ~R ^ S
                f = '~' + r + ' ^ ' + s
        q = self.fiw(ALU_Q)
        if q == 2:
            y = a
        else:
            y = f
        if q == 2 or q == 3:
            ram = '='
        elif q == 4 or q == 5:
            ram = '>>='
        elif q == 6 or q == 7:
            ram = '<<='
        else:
            ram = ''
        if q == 0:
            q = '='
        elif q == 4:
            q = '>>='
        elif q == 6:
            q = '<<='
        else:
            q = ''
        if f == 'SWP':
            f += '(%s)' % y
        items = []
        if ram != '':
            items.append('%s %s %s' % (b, ram, f))
        if q != '':
            if q == '=':
                items.append('Q %s %s' % (q, f))
            else:
                items.append('Q %s Q' % q)
        rc = self.fiw(REG_C)
        if rc & 7 == 7:
            items.append('PSW = %s' % y)
        if self.fiw(ALU_CI) and self.fiw(ALU_F) & 0x4:
            items.append('SXT')
        if not items:
            return ''
        line = '; ' + items[0]
        for s in items[1:]:
            line += ', %s' % s
        return line + '\n'

    def get_loc(self, addr):
        return '\t.loc\t0x%03X\n' % addr

    def do_disasm(self):
        for addr in range(self.size):
            data = self.data[addr]
            if data is None:
                continue
            self.word = data
            #
            # Gather target addresses for the label database
            #
            line = ''
            mcu = self.fiw(MCU)
            if mcu == 0b0000 and data != 0:
                line += '\n; Warning: jump zero with not zero word at %X' % addr
            if self.npas == 1:
                if mcu_t[mcu][1]:
                    target = self.fiw(NAF)
                    if target not in self.label:
                        self.label.append(target)
                continue
            if self.npas != 2:
                continue
            #
            # Build the listing
            #
            line += self.get_raw(addr)
            #
            # Check page boundary crossing
            #
            #   if addr & 7 == 7 and   \
            #           mcu != 15 and mcu != 7 and mcu != 2 and \
            #           not (mcu == 10 and self.fiw(CC) == 14):
            #       line += '; Warning: not jp/jrp/jmap/crtn at page boundary\n'
            #       self.wcnt += 1
            #
            # Provide the hint comment
            #
            line += self.get_hint()
            #
            # Provide the location counter directive
            #
            line += self.get_loc(addr)
            #
            # Analyze microsequencer instruction
            #
            line += self.get_mcu(addr, mcu)
            #
            # Analyze ALU opcode and operands
            #
            line += self.get_alu()
            #
            # Analyze data mux
            #
            line += self.get_dmux()
            #
            # Analyze shift mux field
            #
            line += self.get_shift()
            #
            # Analyze PSW and register control
            #
            line += self.get_rc()
            #
            # Analyze IO transaction
            #
            line += self.get_io()
            #
            # Output result to listing file
            #
            print('%s\n' % line, file=self.flst)
        if self.npas == 2:
            #
            # Final .end directive
            #
            print('\t.end', file=self.flst)
            #
            # Show final statistics
            #
            line = '\r\nErrors: %d\r\nWarnings: %d\r\n' % (self.ecnt, self.wcnt)
            if self.ecnt or self.wcnt:
                print(line, file=sys.stderr)
        return


def createParser():
    p = argparse.ArgumentParser(
        description='Am2900 M4 Microcode Disassembler, '
                    'Version 20.06a, (c) 1801BM1')
    p.add_argument('mif', nargs=1,
                   help='input microcode file', metavar='file')
    p.add_argument('-l', '--lst', help='output listing file',
                   type=argparse.FileType('w'), nargs='?',
                   default = sys.stdout, metavar='file')
    return p


def main():
    parser = createParser()
    params = parser.parse_args()

    try:
        code = Bf()
        #
        # Load the microcode from source file
        #
        code.load_mif(params.mif[0])
        code.set_list(params.lst)
        code.set_pass(1)
        code.do_disasm()
        code.set_pass(2)
        code.do_disasm()

    except RuntimeError as err:
        print('\r\nerror: %s' % err, file=sys.stderr)
        sys.exit(1)

    except SyntaxError as err:
        print('\r\nerror: %s' % err, file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
