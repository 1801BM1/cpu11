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
import argparse
import sys
import re
import os

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
    ('ldct', False, True),
    ('loop', False, True),
    ('cont', False, False),
    ('jump', True, False),
)

# PDP-11 instruction predecoder map
map_t = {
    0x00: 'halt',
    0x01: 'undef',
    0x02: 'rti/rtt',
    0x03: 'wait',
    0x04: 'bpt',
    0x06: 'reset',
    0x07: 'iot',
    0x08: 'sxt',
    0x09: 'mark',
    0x0A: 'sob',
    0x0B: 'xor',
    0x0C: 'mfps',
    0x0D: 'adc',
    0x0E: 'jmp',
    0x0F: 'fis',
    0x10: 'bis',
    0x12: 'clr',
    0x13: 'cmp',
    0x14: 'com',
    0x15: 'ror',
    0x16: 'inc',
    0x17: 'rol',
    0x18: 'dec',
    0x19: 'sub',
    0x1A: 'neg',
    0x1B: 'asr',
    0x1C: 'bit',
    0x1D: 'asl',
    0x1E: 'bic',
    0x1F: 'brach',
    0x20: 'bis Rs, Rd',
    0x21: 'bicb',    
    0x22: 'clr Rd',
    0x23: 'bisb',    
    0x24: 'com Rd',
    0x25: 'clrb',
    0x26: 'inc Rd',
    0x27: 'comb',
    0x28: 'dec Rd',
    0x29: 'incb',
    0x2A: 'neg Rd',
    0x2B: 'decb',
    0x2C: 'tst',
    0x2D: 'negb',
    0x2E: 'mtps',
    0x2F: 'tstb',
    0x30: 'mov Rs, Rd',
    0x31: 'mov',
    0x32: 'movb Rd, Rs',
    0x33: 'movb',
    0x34: 'add Rs, xx',
    0x35: 'add',
    0x36: 'rts',
    0x37: 'jsr',
    0x38: 'trap',
    0x39: 'emt',
    0x3A: 'cmp Rs, Rd',
    0x3B: 'sub Rd, Rs',    
    0x3C: 'bit Rs, Rd',
    0x3D: 'cmpb',
    0x3E: 'bic Rs, Rd',
    0x3F: 'bitb',
    0x40: 'clx',
    0x41: 'swab',
    0x42: 'ash',
    0x43: 'sex',
    0x44: 'swab Rd',
    0x45: 'ashc',
    0x47: 'mul',
    0x48: 'div',
    0x4D: 'adc Rd',
    0x4A: 'sbc Rd',
    0x51: 'adcb',
    0x52: 'sbcb',
    0x53: 'sbc',
    0x54: 'rorb',
    0x55: 'ror Rd',
    0x56: 'rol Rd',
    0x59: 'rolb',
    0x5A: 'asrb',
    0x5B: 'asr Rd',
    0x5C: 'asl Rd',
    0x5F: 'aslb',
    0x6C: 'tst Rd',
    0x74: 'add Rs, Rd'
}

OR_nEN = (24, 1)
OMX = (41, 3)

omx_t = (
	'OR_MD', 'OR_MS', 'OR_RR', 'OR_IV',
	'OR_ONE', 'OR_BT', 'OR_TC', 'OR_R67'
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

porta_t = ('Ad0', 'As0', 'Ad1', 'As1')
portb_t = ('As0', 'Ad0', 'Ad1', 'Ad1')

cc_t = (
	'CCC',  'CCV',  'CCZ',  'CCN',	'CCT',  'CCI',  'CCE',  'CCA',
	'CCCN',	'CCVN', 'CCZN',	'CCNN', 'CCTN',	'CCIN', 'CCEN', 'CCAN'
)

D_MUX = (33, 2)
D_IMM = (40, 16)

dmux_t = ('dpsw', 'dbus', 'dimm', 'dswp')

class Bf(object):
    ''' Arbitrary records data buffer '''

    def __init__(self, size=1024):
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
        line = '; %04X\t%s\n' % (addr, bmask)
        if addr & 0x7 == 0 and map_t.get(addr >> 3) is not None:
            line += '; "%s" opcode\n' % map_t.get(addr >> 3)
        return line

    def get_mcu(self, addr, mcu):
        line = ''
        if mcu_t[mcu][1]:
            naf = self.fiw(NAF)
            if naf >= self.size:
                line = '; Warning: next address is out of range\n'
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
        if self.fiw(OR_nEN) == 0:
            line += ' & ' + cc_t[self.fiw(CC)]
        elif self.fiw(CC) or mcu_t[mcu][2]:
            if mcu_t[mcu][1]:
                line += ', '
            else:
                line += '\t'
            line += cc_t[self.fiw(CC)]
        return line

    def get_alu(self):
        line = '\n&\t'
        alum = self.fiw(ALU_M)
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
                return line
            line += '\t'
        else:
            line += aluf_t[self.fiw(ALU_F)] + '\t'
        if (alum != ALU_TST and alum != ALU_TSTD) or \
            self.fiw(ALU_B) or self.fiw(ALU_BS):
            if self.fiw(ALU_BS):
                line += portb_t[self.fiw(ALU_B) & 3] + ' & '
            else:
                line += 'B%d' % self.fiw(ALU_B) + ' & '
        if self.fiw(ALU_AS):
            line += porta_t[self.fiw(ALU_A) & 3]
        else:
            line += 'A%d' % self.fiw(ALU_A)
        if alum == ALU_TST or alum == ALU_TSTD or alum == ALU_NOPA:
            return line
        line += ', C%d' % self.fiw(ALU_CI)
        line += ', ' + aluq_t[self.fiw(ALU_Q)]
        line += ', ' + alus_t[self.fiw(ALU_S)]
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
            line = '\n&\t' + dmux_t[dmux]
            if dmux_t[dmux] == 'dimm':
                line += '\t0x%X' % self.fiw(D_IMM)
        else:
            if dmux == 3:
                line = '\n&\tdmux'
            else:
                line = '\n&\t' + dmux_t[dmux]
                if dmux_t[dmux] == 'dimm':
                    line += '\t0x%X' % self.fiw(D_IMM)
        return line

    def do_disasm(self):
        for addr in range(self.size):
            data = self.data[addr]
            if data is None:
                continue
            self.word = data
            #
            # Gather target addresses for the label database
            #
            mcu = self.fiw(MCU)
            if mcu == 0b0000:
                if data != 0:
                    raise SyntaxError('jump zero with not zero word at %X' % addr)
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
            line = self.get_raw(addr)
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
            # Output result to listing file
            #
            print('%s' % line, file=self.flst)
            print('', file=self.flst)
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
