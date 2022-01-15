#!/usr/bin/python3
#
# Disassembler for DEC F11 "Fonz" chipset Microcode
# Copyright 2022 Viacheslav Ovsiienko <1801BM1@gmail.com>
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
#    disf11.py rom0.mif -l rom0.lst
#
import argparse
import sys
import re
import os

# F11 registers
reg_t = {
    0x00: 'R0', 0x01: 'R1', 0x02: 'R2', 0x03: 'R3',
    0x04: 'R4', 0x05: 'R5', 0x06: 'SP', 0x07: 'PC',
    0x08: 'PSW', 0x09: 'R9', 0x0A: 'R10', 0x0B: 'R11',
    0x0C: 'Rs', 0x0D: 'Rd', 0x0E: 'R14', 0x0F: 'R15'
}

# F11 micro instruction mnemonics
map_t = {
    0x00: 'jmp', 0x01: 'jmp', 0x02: 'jmp', 0x03: 'jmp',
    0x04: 'jmp', 0x05: 'jmp', 0x06: 'jmp', 0x07: 'jmp',
    0x08: 'jna', 0x09: 'jza', 0x0A: 'jca', 0x0B: 'jva',
    0x0C: 'jn', 0x0D: 'jz', 0x0E: 'jc', 0x0F: 'jm',
    0x10: 'oq', 0x11: 'oir', 0x12: 'ops', 0x13: 'oplm',
    0x14: 'rwi', 0x15: 'rbi', 0x16: 'rw', 0x17: 'rb',
    0x18: 'wwi', 0x19: 'wbi', 0x1A: 'ww', 0x1B: 'wb',
    0x1C: 'rwwi', 0x1D: 'rwbi', 0x1E: 'rww', 0x1F: 'rwb',
    0x20: 'll', 0x21: 'll', 0x22: 'll', 0x23: 'll',
    0x24: 'll', 0x25: 'll', 0x26: 'll', 0x27: 'll',
    0x28: 'll', 0x29: 'll', 0x2A: 'll', 0x2B: 'll',
    0x2C: 'll', 0x2D: 'll', 0x2E: 'll', 0x2F: 'll',
    0x30: 'cl', 0x31: 'cl', 0x32: 'cl', 0x33: 'cl',
    0x34: 'cl', 0x35: 'cl', 0x36: 'cl', 0x37: 'cl',
    0x38: 'cl', 0x39: 'cl', 0x3A: 'cl', 0x3B: 'cl',
    0x3C: 'cl', 0x3D: 'cl', 0x3E: 'cl', 0x3F: 'cl',
    0x40: 'al', 0x41: 'al', 0x42: 'al', 0x43: 'al',
    0x44: 'al', 0x45: 'al', 0x46: 'al', 0x47: 'al',
    0x48: 'al', 0x49: 'al', 0x4A: 'al', 0x4B: 'al',
    0x4C: 'al', 0x4D: 'al', 0x4E: 'al', 0x4F: 'al',
    0x50: 'ol', 0x51: 'ol', 0x52: 'ol', 0x53: 'ol',
    0x54: 'ol', 0x55: 'ol', 0x56: 'ol', 0x57: 'ol',
    0x58: 'ol', 0x59: 'ol', 0x5A: 'ol', 0x5B: 'ol',
    0x5C: 'ol', 0x5D: 'ol', 0x5E: 'ol', 0x5F: 'ol',
    0x60: 'nl', 0x61: 'nl', 0x62: 'nl', 0x63: 'tl',
    0x64: 'nl', 0x65: 'nl', 0x66: 'nl', 0x67: 'tl',
    0x68: 'nl', 0x69: 'nl', 0x6A: 'nl', 0x6B: 'tl',
    0x6C: 'nl', 0x6D: 'nl', 0x6E: 'nl', 0x6F: 'tl',
    0x70: 'tl', 0x71: 'tl', 0x72: 'tl', 0x73: 'tl',
    0x74: 'tl', 0x75: 'tl', 0x76: 'tl', 0x77: 'tl',
    0x78: 'tl', 0x79: 'tl', 0x7A: 'tl', 0x7B: 'tl',
    0x7C: 'tl', 0x7D: 'tl', 0x7E: 'tl', 0x7F: 'tl',
    0x80: 'srws', 0x81: 'srbs', 0x82: 'srw', 0x83: 'srb',
    0x84: 'srwcs', 0x85: 'srbcs', 0x86: 'srwc', 0x87: 'srbc',
    0x88: 'slws', 0x89: 'slbs', 0x8A: 'slw', 0x8B: 'slb',
    0x8C: 'slwcs', 0x8D: 'slbcs', 0x8E: 'slwc', 0x8F: 'slbc',
    0x90: 'tcws', 0x91: 'tcbs', 0x92: 'tcw', 0x93: 'tcb',
    0x94: 'tcwcs', 0x95: 'tcbcs', 0x96: 'tcwc', 0x97: 'tcbc',
    0x98: 'cws', 0x99: 'cbs', 0x9A: 'cw', 0x9B: 'cb',
    0x9C: 'ocws', 0x9D: 'ocbs', 0x9E: 'ocw', 0x9F: 'ocb',
    0xA0: 'aws', 0xA1: 'abs', 0xA2: 'aw', 0xA3: 'ab',
    0xA4: 'awcs', 0xA5: 'abcs', 0xA6: 'awc', 0xA7: 'abc',
    0xA8: 'icws', 0xA9: 'icbs', 0xAA: 'icw', 0xAB: 'icb',
    0xAC: 'acws', 0xAD: 'acbs', 0xAE: 'acw', 0xAF: 'acb',
    0xB0: 'sws', 0xB1: 'sbs', 0xB2: 'sw', 0xB3: 'sb',
    0xB4: 'swcs', 0xB5: 'sbcs', 0xB6: 'swc', 0xB7: 'sbc',
    0xB8: 'dcws', 0xB9: 'dcbs', 0xBA: 'dcw', 0xBB: 'dcb',
    0xBC: 'scws', 0xBD: 'scbs', 0xBE: 'scw', 0xBF: 'scb',
    0xC0: 'mws', 0xC1: 'mbs', 0xC2: 'mw', 0xC3: 'mb',
    0xC4: 'sxws', 0xC5: 'sxbs', 0xC6: 'sxw', 0xC7: 'sxb',
    0xC8: 'zws', 0xC9: 'zbs', 0xCA: 'zw', 0xCB: 'zb',
    0xCC: 'bdws', 0xCD: 'bdbs', 0xCE: 'bdw', 0xCF: 'bdb',
    0xD0: 'inw', 0xD1: 'inb', 0xD2: 'inwq', 0xD3: 'inbq',
    0xD4: 'irw', 0xD5: 'irb', 0xD6: 'irwq', 0xD7: 'irbq',
    0xD8: 'isw', 0xD9: 'isb', 0xDA: 'iswq', 0xDB: 'isbq',
    0xDC: 'ivw', 0xDD: 'ivb', 0xDE: 'ivwq', 0xDF: 'ivbq',
    0xE0: 'ncws', 0xE1: 'ncbs', 0xE2: 'ncw', 0xE3: 'ncb',
    0xE4: 'orws', 0xE5: 'orbs', 0xE6: 'orw', 0xE7: 'orb',
    0xE8: 'xows', 0xE9: 'xobs', 0xEA: 'xow', 0xEB: 'xob',
    0xEC: 'xchws', 0xED: 'xchbs', 0xEE: 'xchw', 0xEF: 'xchb',
    0xF0: 'tzws', 0xF1: 'tzbs', 0xF2: 'tzw', 0xF3: 'tzb',
    0xF4: 'caws', 0xF5: 'cabs', 0xF6: 'lxw', 0xF7: 'lxb',
    0xF8: 'tws', 0xF9: 'tbs', 0xFA: 'tw', 0xFB: 'tb',
    # 0xFC: '', 0xFD: '',
    0xFE: 'cawi', 0xFF: 'nop'
}


class Bf(object):
    ''' Arbitrary records data buffer '''

    def __init__(self, size=1024):
        self.ecnt = 0           # error counter
        self.wcnt = 0           # warning counter
        self.size = size        # buffer size
        self.width = 25         # record width
        self.aradx = 16         # address radix
        self.dradx = 16         # data radix
        self.data = [None] * size
        self.flst = None
        self.label = []
        self.word = 0
        self.na = 0
        self.mc = 0

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
        re_range   = re.compile(r'\[([A-Z0-9]+)..([A-Z0-9]+)\]\s*:\s*([A-Z0-9]+)\s*;\s*$')
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
                if addr >= self.size/2:
                    raise SyntaxError('line %d addr out of range: %s' %
                                      (lnum, text))
                if data >= 1 << self.width:
                    raise SyntaxError('line %d data out of range: %s' %
                                      (lnum, text))
                # relocate instructions for AXT=1 pages
                if addr < 0x40:
                    if (addr & 0x0F) < 6:
                        continue
                    addr = ((addr >> 4) * 0x80) + 0x270 + (addr & 0x0F)
                self.data[addr] = data
                continue
            match = re_range.match(line)
            if match is not None:
                beg = int(match.group(1), self.aradx)
                end = int(match.group(2), self.aradx) + 1
                data = int(match.group(3), self.dradx)
                for addr in range(beg, end):
                    if addr >= self.size/2:
                        raise SyntaxError('line %d addr out of range: %s' %
                                          (lnum, text))
                    if data >= 1 << self.width:
                        raise SyntaxError('line %d data out of range: %s' %
                                          (lnum, text))
                    # relocate instructions for AXT=1 pages
                    if addr < 0x40:
                        if (addr & 0x0F) < 6:
                            continue
                        addr = ((addr >> 4) * 0x80) + 0x270 + (addr & 0x0F)
                    self.data[addr] = data
                continue

            match = re_skip.match(line)
            if match is not None:
                continue
            match = re_depth.match(line)
            if match is not None:
                self.size = int(match.group(1), 10)
                if self.size != 512:
                    raise SyntaxError('line %d DEPTH is not 512' % lnum)
                self.size = 1024
                self.data = [None] * 1024
                continue
            match = re_width.match(line)
            if match is not None:
                self.width = int(match.group(1), 10)
                if self.width != 25:
                    raise SyntaxError('line %d WIDTH is not 25' % lnum)
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

    def set_list(self, flst):
        self.flst = flst
        return

    def get_loc(self, addr):
        return '\n\t\t.loc\t0x%03X\n' % addr

    def get_ra(self):
        return reg_t[self.mc & 0xF]

    def get_rb(self):
        return reg_t[(self.mc >> 4) & 0xF]

    def get_mm(self):
        return '0x%X' % ((self.mc >> 4) & 0xF)

    def get_code(self, addr):
        op = map_t.get(self.mc >> 8)
        if op is None:
            op = 'unk_%02X' % (self.mc >> 8)
            self.wcnt += 1 # unknown opcode

        # jmp cs, addr: 0000 0ccc ccdd dddd - inter ROM jump
        if self.mc & 0xF800 == 0:
            op += '\tCS%d' % ((self.mc >> 6) & 0x1F)
            op += ':L%03X' % (self.mc & 0x3F)
            return op
        # jcond addr8: 0000 1ccc dddd dddd - conditional page jump
        if self.mc & 0xF800 == 0x0800:
            op += '\tL%03X' % (addr & 0x100 | self.mc & 0xFF)
            return op
        # output data/control 0001 xxxx mmmm aaaa
        if self.mc >> 8 == 0x14:
            op += '\t' + self.get_ra()
            return op
        if self.mc >> 8 < 0x14:
            op += '\t' + self.get_mm() + ', ' + self.get_ra()
            return op
        # Bus cycle start operations
        if 0x14 <= (self.mc >> 8) <= 0x1F:
            op += '\t' + self.get_mm() + ', ' + self.get_ra()
            return op
        # literal operations
        if 2 <= (self.mc >> 12) <= 7:
            lit = self.mc & 0xF0 | (self.mc >> 8) & 0x0F
            if self.mc >> 12 == 4 and lit & 0x80:
                lit |= 0xFF00
            op += '\t0x%02X, ' % lit
            op += self.get_ra()
            return op
        # data input operations: opc mmmm, Ra
        if (self.mc >> 12) == 0xD:
            op += '\t' + self.get_mm() + ', ' + self.get_ra()
            return op
        # two operand arithmetics
        op += '\t' + self.get_rb() + ', ' + self.get_ra()
        return op

    def do_disasm(self):
        gen_loc = 1
        for addr in range(self.size):
            data = self.data[addr]
            if data is None:
                gen_loc = 1
                continue
            self.word = data
            self.mc = self.word & 0xFFFF
            self.na = (self.word >> 16) & 0x1FF
            line = ''
            if gen_loc:
                line += self.get_loc(addr)
                gen_loc = 0
            #
            # Build the listing
            #
            line += '%03X %03X:%04X\t' % (addr, self.na, self.mc)
            line += self.get_code(addr)
            if self.na != ((addr & 0x1FF) + 1):
                if self.mc & 0xF800:
                    line += ', L%03X' % self.na
                gen_loc = 1
            #
            # Output result to listing file
            #
            print('%s' % line, file=self.flst)
        #
        # Final .end directive
        #
        print('\t\t.end', file=self.flst)
        #
        # Show final statistics
        #
        line = '\r\nErrors: %d\r\nWarnings: %d\r\n' % (self.ecnt, self.wcnt)
        if self.ecnt or self.wcnt:
            print(line, file=sys.stderr)
        return


def create_parser():
    p = argparse.ArgumentParser(
        description='DEC F11 Microcode Disassembler, '
                    'Version 22.01a, (c) 1801BM1')
    p.add_argument('mif', nargs=1,
                   help='input microcode file', metavar='file')
    p.add_argument('-l', '--lst', help='output listing file',
                   type=argparse.FileType('w'), nargs='?',
                   default=sys.stdout, metavar='file')
    return p


def main():
    parser = create_parser()
    params = parser.parse_args()

    try:
        code = Bf()
        #
        # Load the microcode from source file
        #
        code.load_mif(params.mif[0])
        code.set_list(params.lst)
        code.do_disasm()

    except RuntimeError as err:
        print('\r\nerror: %s' % err, file=sys.stderr)
        sys.exit(1)

    except SyntaxError as err:
        print('\r\nerror: %s' % err, file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
