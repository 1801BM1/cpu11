#!/usr/bin/python3

# Disassembler for Western Digital CP16xx/WD21xx Microcode
# Copyright 2015 Eric Smith <spacewar@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import argparse
import collections
import itertools
import sys

#
# CP-1621 PLA locations and translation codes  (LSI-11)
#
pta_lsi11 = {
    0x037: 0x25, 0x040: 0x13, 0x041: 0x51, 0x048: 0x32, 0x049: 0x13,
    0x04A: 0x51, 0x050: 0x16, 0x051: 0x13, 0x052: 0x64, 0x053: 0x51,
    0x05A: 0x32, 0x05B: 0x13, 0x05C: 0x4C, 0x05F: 0x51, 0x061: 0x23,
    0x063: 0x13, 0x06C: 0x32, 0x06D: 0x13, 0x073: 0x32, 0x074: 0x13,
    0x07D: 0x32, 0x07E: 0x13, 0x07F: 0x52, 0x080: 0x68, 0x08A: 0x38,
    0x092: 0x38, 0x09C: 0x38, 0x0A4: 0x38, 0x0AE: 0x38, 0x0B5: 0x38,
    0x0BF: 0x38, 0x0C8: 0x15, 0x0D1: 0x15, 0x0D9: 0x15, 0x0E2: 0x15,
    0x0EB: 0x15, 0x0F2: 0x15, 0x0FC: 0x15, 0x100: 0x70, 0x10A: 0x58,
    0x10D: 0x2A, 0x111: 0x2C, 0x112: 0x58, 0x114: 0x58, 0x11C: 0x58,
    0x121: 0x49, 0x123: 0x58, 0x126: 0x58, 0x12E: 0x58, 0x135: 0x58,
    0x13F: 0x58, 0x140: 0x0B, 0x150: 0x4A, 0x154: 0x4A, 0x158: 0x4A,
    0x15C: 0x4A, 0x160: 0x07, 0x162: 0x26, 0x170: 0x4A, 0x174: 0x4A,
    0x178: 0x4A, 0x148: 0x4A, 0x14C: 0x4A, 0x168: 0x4A, 0x16C: 0x4A,
    0x180: 0x0E, 0x1A0: 0x0D, 0x188: 0x4A, 0x18C: 0x4A, 0x1A8: 0x4A,
    0x1AC: 0x4A, 0x1E8: 0x4A, 0x1EC: 0x4A, 0x200: 0x4A, 0x228: 0x4A,
    0x22C: 0x4A, 0x2A4: 0x54, 0x329: 0x1A, 0x342: 0x1C, 0x3B3: 0x1C,
    0x3C7: 0x1C, 0x3D1: 0x1C, 0x3E8: 0x1C, 0x41B: 0x34, 0x43B: 0x34,
    0x453: 0x19, 0x47A: 0x19, 0x4AC: 0x62, 0x4BC: 0x62, 0x490: 0x62,
    0x4D0: 0x62, 0x506: 0x62, 0x527: 0x34, 0x54E: 0x19, 0x568: 0x29,
    0x569: 0x29, 0x56A: 0x29, 0x56B: 0x29, 0x579: 0x13, 0x540: 0x34,
    0x560: 0x34, 0x592: 0x19, 0x598: 0x19, 0x584: 0x34, 0x58C: 0x34,
    0x5A4: 0x34, 0x5AC: 0x34, 0x5CC: 0x19, 0x5CF: 0x19, 0x5EC: 0x19,
    0x5C0: 0x34, 0x5C8: 0x34, 0x5E0: 0x34, 0x5E8: 0x34
}
#
# Addres is one of the TRAN targets (LSI-11)
#
org_lsi11 = {
    0x002: "[15]", 0x012: "[15]", 0x020: "[25]", 0x029: "[25]", 0x035: "[2A]",
    0x037: "[2A]", 0x03D: "[2A]", 0x040: "[25,2A]", 0x041: "[2A,64]", 0x042: "[2A]",
    0x047: "[4C]", 0x048: "[2A]", 0x04A: "[32]", 0x04B: "[2A]", 0x050: "[2A]",
    0x052: "[16]", 0x058: "[2A]", 0x05C: "[23]",0x060: "[2A]", 0x064: "[25]",
    0x068: "[2A]", 0x070: "[2A]", 0x078: "[2A]", 0x07F: "[25,2A]", 0x080: "[13]",
    0x081: "[26,4A]", 0x088: "[13]", 0x090: "[13]", 0x098: "[13]", 0x09D: "[2A]",
    0x0A0: "[13]", 0x0A8: "[13]", 0x0B0: "[13]", 0x0B6: "[2A]", 0x0B8: "[13]",
    0x0C0: "[52]", 0x0C8: "[52]", 0x0D0: "[52]", 0x0D8: "[52]", 0x0E0: "[52]",
    0x0E5: "[25]", 0x0E8: "[52]", 0x0F0: "[52]", 0x0F8: "[52]", 0x100: "[51]",
    0x108: "[51]", 0x10B: "[4A]", 0x110: "[51]", 0x113: "[2C]", 0x118: "[51]",
    0x11D: "[25]", 0x120: "[51]", 0x124: "[49]", 0x128: "[51]", 0x130: "[51]",
    0x138: "[51]", 0x140: "[68]", 0x141: "[68]", 0x144: "[68]", 0x148: "[68]",
    0x14C: "[68]", 0x150: "[68]", 0x154: "[68]", 0x158: "[68]", 0x15C: "[68]",
    0x160: "[70]", 0x161: "[70]", 0x163: "[1A]", 0x164: "[70]", 0x168: "[70]",
    0x16C: "[70]", 0x170: "[70]", 0x174: "[70]", 0x178: "[68,70]", 0x17C: "[70]",
    0x180: "[38]", 0x181: "[38]", 0x184: "[26,38,4A]", 0x188: "[38]", 0x18C: "[38]",
    0x190: "[38]", 0x194: "[38]", 0x198: "[38]", 0x19C: "[38]", 0x1A0: "[58]",
    0x1A1: "[58]", 0x1A4: "[58]", 0x1A8: "[58]", 0x1AC: "[58]", 0x1B0: "[58]",
    0x1B4: "[58]", 0x1B8: "[38,58]", 0x1BA: "[4A]", 0x1BC: "[58]", 0x1C0: "[07]",
    0x1C2: "[26,4A]", 0x1C4: "[07]", 0x1C8: "[07]", 0x1CC: "[07]", 0x1D0: "[07]",
    0x1D4: "[07]", 0x1D8: "[07]", 0x1DC: "[07]", 0x1E0: "[07]", 0x1E4: "[07]",
    0x1E8: "[07]", 0x1EC: "[07]", 0x1F0: "[07]", 0x1F4: "[07]", 0x1F8: "[07]",
    0x1FC: "[07]", 0x200: "[0B]", 0x204: "[0B]", 0x208: "[0B]", 0x20C: "[0B]",
    0x210: "[0B]", 0x214: "[0B]", 0x218: "[0B]", 0x21C: "[0B]", 0x220: "[0B]",
    0x224: "[0B]", 0x228: "[0B]", 0x22C: "[0B]", 0x230: "[0B]", 0x234: "[0B]",
    0x238: "[0B]", 0x23C: "[0B]", 0x240: "[0D]", 0x244: "[0D]", 0x248: "[0D]",
    0x24C: "[0D]", 0x250: "[0D]", 0x254: "[0D]", 0x258: "[0D]", 0x25C: "[0D]",
    0x260: "[0D]", 0x264: "[0D]", 0x268: "[0D]", 0x26C: "[0D]", 0x270: "[0D]",
    0x274: "[0D]", 0x278: "[0D]", 0x27C: "[0D]", 0x280: "[0E]", 0x284: "[0E]",
    0x288: "[0E]", 0x28C: "[0E]", 0x290: "[0E]", 0x294: "[0E]", 0x298: "[0E]",
    0x29C: "[0E]", 0x2A0: "[0E,54]", 0x2A4: "[0E]", 0x2A8: "[0E]",0x2AC: "[0E]",
    0x2B0: "[0E]", 0x2B4: "[0E]", 0x2B8: "[0E]", 0x2BC: "[0E]", 0x2C0: "[13]",
    0x2C8: "[13]", 0x2D0: "[13]", 0x2D8: "[13]", 0x2E0: "[13]", 0x2E8: "[13]",
    0x2F0: "[13]", 0x2F8: "[13]", 0x31D: "[1C,26,4A]", 0x343: "[1A]", 0x3B4: "[1A]",
    0x3C8: "[1A]", 0x3D2: "[1A]", 0x3E9: "[1A]", 0x400: "[2A]", 0x568: "[19]",
    0x569: "[19]", 0x56A: "[19]", 0x56B: "[19]", 0x579: "[2A]", 0x57C: "[68,70]",
    0x57D: "[68,70]", 0x592: "[62]", 0x5CF: "[34]", 0x5FC: "[38,58]", 0x5FD: "[38,58]",
    0x601: "[2A]"
}

class SymbolTable(object):
    def __init__(self):
        self.by_name = {}
        self.by_value = {}

    def add(self, name, value):
        assert name not in self.by_name
        assert value not in self.by_value
        self.by_name[name] = value
        self.by_value[value] = name

    def has_name(self, name):
        return name in self.by_name

    def has_value(self, value):
        return value in self.by_value

    def get_by_name(self, name, default=None):
        if default is None:
            return self.by_name[name]
        else:
            return self.by_name.get(name, default)

    def get_by_value(self, value, default=None):
        if default is None:
            return self.by_value[value]
        else:
            return self.by_value.get(value, default)

symtab = SymbolTable()

Inst = collections.namedtuple('Inst', ['mnem', 'bits', 'mask', 'fields'])

class FieldDecoder(object):
    def __init__(self, table = None):
        if table is None:
            self.table = {}
        else:
            self.table = table
        
    def decode(self, addr, field_value, width):
        for name, value in self.table.items():
            if field_value == value:
                return name
        return '0x%x' % field_value

class UnusedDecoder(FieldDecoder):
    def decode(self, addr, field_value, width):
        if field_value == 0:
            return None
        return '0x%x' % field_value

class TargetDecoder(FieldDecoder):
    def decode(self, addr, field_value, width):
        if width == 8:
            field_value |= ((addr + 1) & 0xf00)

        return symtab.get_by_value(field_value, '0x%03x' % field_value)

class RegisterDecoder(FieldDecoder):
    def __init__(self, arch):
        self.arch = arch
        self.regs = { 'lsi11':   {0x2: 'RBAL',
                                  0x3: 'RBAH',
                                  0x4: 'RSRCL',
                                  0x5: 'RSRCH',
                                  0x6: 'RDSTL',
                                  0x7: 'RDSTH',
                                  0x8: 'RIRL',
                                  0x9: 'RIRH',
                                  0xA: 'RPSWL',
                                  0xB: 'RPSWH',
                                  0xC: 'SPL',
                                  0xD: 'SPH',
                                  0xE: 'PCL',
                                  0xF: 'PCH'},
                      # Pascal Microengine register definitions are tentative
                      'pascal':  {0xA: 'IPCL',
                                  0xB: 'IPCH',
                                  0xC: 'SPL',
                                  0xD: 'SPH',
                                  0xE: 'MPL',
                                  0xF: 'MPH'},
                      'default': {0x0: 'GL',
                                  0x1: 'GH'}}

    def decode(self, addr, field_value, width):
        if self.arch is not None and field_value in self.regs[self.arch]:
            return self.regs[self.arch][field_value]
        elif field_value in self.regs['default']:
            return self.regs['default'][field_value]
        else:
            return 'r%x' % field_value

class BitFieldDecoder(FieldDecoder):
    def __init__(self, table = {}):
        self.table = table

    def decode(self, addr, field_value, width):
        l = []
        for name, value in self.table.items():
            if field_value & value:
                l.append(name)
            field_value &= ~value
        if field_value:
            l.append('0x%x' % field_value)
        if len(l) != 0:
            return '|'.join(l)
        else:
            return '0'

class InterruptDecoder(BitFieldDecoder):
    def __init__(self):
        super().__init__({'i4': 0x01,
                          'i5': 0x02,
                          'i6': 0x04})

class ConditionFlagsDecoder(BitFieldDecoder):
    def __init__(self):
        super().__init__({'c8': 0x01,
                          'c4': 0x02,
                          'zb': 0x04,
                          'nb': 0x08})

class InputDecoder(FieldDecoder):
    def __init__(self):
        super().__init__({'ub':  0x0,
                          'ubc': 0x1,
                          'lb':  0x2,
                          'lbc': 0x3,
                          'rmw': 0x4})

                   

class Field(object):
    def __init__(self, arch, name, lsb, width):
        self.name = name
        self.lsb = lsb
        self.width = width
        self.default_decoder = FieldDecoder()
        self.field_decoders = { 'x': UnusedDecoder(),
                                'T': TargetDecoder(),
                                'A': RegisterDecoder(arch),
                                'B': RegisterDecoder(arch),
                                'I': InterruptDecoder() }

    def get_mask(self):
        return ((1 << self.width) - 1) << self.lsb

    def decode(self, addr, field_value):
        return self.field_decoders.get(self.name, self.default_decoder).decode(addr, field_value, self.width)


encodings = [
    ['0000 0TTT TTTT TTTT', 'jmp'],   # JuMP (unconditionally)
    ['0000 1xxx xxxx xxxx', 'rfs'],   # Return From Subroutine
    ['0001 0000 TTTT TTTT', 'jzbf'],  # Jump if ZB flag is False
    ['0001 0001 TTTT TTTT', 'jzbt'],  # Jump if ZB flag is True
    ['0001 0010 TTTT TTTT', 'jc8f'],  # Jump if C8 flag is False
    ['0001 0011 TTTT TTTT', 'jc8t'],  # Jump if C8 flag is True
    ['0001 0100 TTTT TTTT', 'jif'],   # Jump if Indirect condition code is False
    ['0001 0101 TTTT TTTT', 'jit'],   # Jump if Indirect condition code is True
    ['0001 0110 TTTT TTTT', 'jnbf'],  # Jump if NB flag False
    ['0001 0111 TTTT TTTT', 'jnbt'],  # Jump if NB flag True
    ['0001 1000 TTTT TTTT', 'jzf'],   # Jump if Z flag False
    ['0001 1001 TTTT TTTT', 'jzt'],   # Jump if Z flag True
    ['0001 1010 TTTT TTTT', 'jcf'],   # Jump if C flag False
    ['0001 1011 TTTT TTTT', 'jct'],   # Jump if C flag True
    ['0001 1100 TTTT TTTT', 'jvf'],   # Jump if V flag False
    ['0001 1101 TTTT TTTT', 'jvt'],   # Jump if V flag True
    ['0001 1110 TTTT TTTT', 'jnf'],   # Jump if N flag False
    ['0001 1111 TTTT TTTT', 'jnt'],   # Jump if N flag True
    ['0010 LLLL LLLL AAAA', 'al'],    # Add Literal
    ['0011 LLLL LLLL AAAA', 'cl'],    # Compare Literal
    ['0100 LLLL LLLL AAAA', 'nl'],    # aNd Literal
    ['0101 LLLL LLLL AAAA', 'tl'],    # Test Literal
    ['0110 LLLL LLLL AAAA', 'll'],    # Load Literal
    ['0111 0000 IIII xxxx', 'ri'],    # Reset Interrupts
    ['0111 0001 IIII xxxx', 'si'],    # Set Interrupts
    ['0111 0010 xxxx AAAA', 'ccf'],   # Copy Condition Flags
    ['0111 0011 BBBB AAAA', 'lcf'],   # Load Condition Flags
    ['0111 0100 xxxx xxxx', 'rtsr'],  # Reset Translation State Register
    ['0111 0101 xxxx AAAA', 'lgl'],   # Load G Low
    ['0111 0110 xxxx AAAA', 'cib'],   # Conditionally Increment Byte
    ['0111 0111 xxxx AAAA', 'cdb'],   # Conditionally Decrement Byte by 1
    ['1000 0000 BBBB AAAA', 'mb'],    # Move Byte 
    ['1000 0001 BBBB AAAA', 'mbf'],   # Move Byte, update condition code Flags
    ['1000 0010 BBBB AAAA', 'mw'],    # Move Word 
    ['1000 0011 BBBB AAAA', 'mwf'],   # Move Word, update condition code Flags
    ['1000 0100 BBBB AAAA', 'cmb'],   # Conditionally Move Byte
    ['1000 0101 BBBB AAAA', 'cmbf'],  # Conditionally Move Byte, update condition code Flags
    ['1000 0110 BBBB AAAA', 'cmw'],   # Conditionally Move Word
    ['1000 0111 BBBB AAAA', 'cmwf'],  # Conditionally Move Word, update condition code Flags
    ['1000 1000 BBBB AAAA', 'slbc'],  # Shift Left Byte with Carry
    ['1000 1001 BBBB AAAA', 'slbcf'], # Shift Left Byte with Carry, update condition code Flags
    ['1000 1010 BBBB AAAA', 'slwc'],  # Shift Left Word with Carry
    ['1000 1011 BBBB AAAA', 'slwcf'], # Shift Left Word with Carry, update condition code Flags
    ['1000 1100 BBBB AAAA', 'slb'],   # Shift Left Byte
    ['1000 1101 BBBB AAAA', 'slbf'],  # Shift Left Byte, update condition code Flags
    ['1000 1110 BBBB AAAA', 'slw'],   # Shift Left Word
    ['1000 1111 BBBB AAAA', 'slwf'],  # Shift Left Word, update condition code Flags
    ['1001 0000 BBBB AAAA', 'icb1'],  # Increment Byte By 1
    ['1001 0001 BBBB AAAA', 'icb1f'], # Increment Byte By 1, update condition code Flags
    ['1001 0010 BBBB AAAA', 'icw1'],  # Increment Word By 1
    ['1001 0011 BBBB AAAA', 'icw1f'], # Increment Word By 1, update condition code Flags
    ['1001 0100 BBBB AAAA', 'icb2'],  # Increment Byte By 2
    ['1001 0101 BBBB AAAA', 'icb2f'], # Increment Byte By 2, update condition code Flags
    ['1001 0110 BBBB AAAA', 'icw2'],  # Increment Word By 2
    ['1001 0111 BBBB AAAA', 'icw2f'], # Increment Word By 2, update condition code Flags
    ['1001 1000 BBBB AAAA', 'tcb'],   # Twos Complement Byte
    ['1001 1001 BBBB AAAA', 'tcbf'],  # Twos Complement Byte, update condition code Flags
    ['1001 1010 BBBB AAAA', 'tcw'],   # Twos Complement Word
    ['1001 1011 BBBB AAAA', 'tcwf'],  # Twos Complement Word, update condition code Flags
    ['1001 1100 BBBB AAAA', 'ocb'],   # Ones Complement Byte
    ['1001 1101 BBBB AAAA', 'ocbf'],  # Ones Complement Byte, update condition code Flags
    ['1001 1110 BBBB AAAA', 'ocw'],   # Ones Complement Word
    ['1001 1111 BBBB AAAA', 'ocwf'],  # Ones Complement Word, update condition code Flags
    ['1010 0000 BBBB AAAA', 'ab'],    # Add Byte
    ['1010 0001 BBBB AAAA', 'abf'],   # Add Byte, update condition code Flags
    ['1010 0010 BBBB AAAA', 'aw'],    # Add Word
    ['1010 0011 BBBB AAAA', 'awf'],   # Add Word, update condition code Flags
    ['1010 0100 BBBB AAAA', 'cab'],   # Conditionally Add Byte
    ['1010 0101 BBBB AAAA', 'cabf'],  # Conditionally Add Byte, update condition code Flags
    ['1010 0110 BBBB AAAA', 'caw'],   # Conditionally Add Word
    ['1010 0111 BBBB AAAA', 'cawf'],  # Conditionally Add Word, update condition code Flags
    ['1010 1000 BBBB AAAA', 'abc'],   # Add Byte with Carry
    ['1010 1001 BBBB AAAA', 'abcf'],  # Add Byte with Carry, update condition code Flags
    ['1010 1010 BBBB AAAA', 'awc'],   # Add Word with Carry
    ['1010 1011 BBBB AAAA', 'awcf'],  # Add Word with Carry, update condition code Flags
    ['1010 1100 BBBB AAAA', 'cad'],   # Conditionally Add Digits
    ['1010 1110 BBBB AAAA', 'cawi'],  # Conditionally Add Word on Icc
    ['1010 1111 BBBB AAAA', 'cawif'], # Conditionally Add Word on Icc, update condition code Flags
    ['1011 0000 BBBB AAAA', 'sb'],    # Subtract Byte
    ['1011 0001 BBBB AAAA', 'sbf'],   # Subtract Byte, update condition code Flags
    ['1011 0010 BBBB AAAA', 'sw'],    # Subtract Word
    ['1011 0011 BBBB AAAA', 'swf'],   # Subtract Word, update condition code Flags
    ['1011 0100 BBBB AAAA', 'cb'],    # Compare Byte
    ['1011 0101 BBBB AAAA', 'cbf'],   # Compare Byte, update condition code Flags
    ['1011 0110 BBBB AAAA', 'cw'],    # Compare Word
    ['1011 0111 BBBB AAAA', 'cwf'],   # Compare Word, update condition code Flags
    ['1011 1000 BBBB AAAA', 'sbc'],   # Subtract Byte with Carry
    ['1011 1001 BBBB AAAA', 'sbcf'],  # Subtract Byte with Carry, update condition code Flags
    ['1011 1010 BBBB AAAA', 'swc'],   # Subtract Word with Carry
    ['1011 1011 BBBB AAAA', 'swcf'],  # Subtract Word with Carry, update condition code Flags
    ['1011 1100 BBBB AAAA', 'db1'],   # Decrement Byte by 1
    ['1011 1101 BBBB AAAA', 'db1f'],  # Decrement Byte by 1, update condition code Flags
    ['1011 1110 BBBB AAAA', 'dw1'],   # Decrement Word by 1
    ['1011 1111 BBBB AAAA', 'dw1f'],  # Decrement Word by 1, update condition code Flags
    ['1100 0000 BBBB AAAA', 'nb'],    # aNd Byte
    ['1100 0001 BBBB AAAA', 'nbf'],   # aNd Byte, update condition code Flags
    ['1100 0010 BBBB AAAA', 'nw'],    # aNd Word
    ['1100 0011 BBBB AAAA', 'nwf'],   # aNd Word, update condition code Flags
    ['1100 0100 BBBB AAAA', 'tb'],    # Test Byte
    ['1100 0101 BBBB AAAA', 'tbf'],   # Test Byte, update condition code Flags
    ['1100 0110 BBBB AAAA', 'tw'],    # Test Word
    ['1100 0111 BBBB AAAA', 'twf'],   # Test Word, update condition code Flags
    ['1100 1000 BBBB AAAA', 'orb'],   # OR Byte
    ['1100 1001 BBBB AAAA', 'orbf'],  # OR Byte, update condition code Flags
    ['1100 1010 BBBB AAAA', 'orw'],   # OR Word
    ['1100 1011 BBBB AAAA', 'orwf'],  # OR Word, update condition code Flags
    ['1100 1100 BBBB AAAA', 'xb'],    # eXclusive or Byte
    ['1100 1101 BBBB AAAA', 'xbf'],   # eXclusive or Byte, update condition code Flags
    ['1100 1110 BBBB AAAA', 'xw'],    # eXclusive or Word
    ['1100 1111 BBBB AAAA', 'xwf'],   # eXclusive or Word, update condition code Flags
    ['1101 0000 BBBB AAAA', 'ncb'],   # aNd Complement Byte
    ['1101 0001 BBBB AAAA', 'ncbf'],  # aNd Complement Byte, update condition code Flags
    ['1101 0010 BBBB AAAA', 'ncw'],   # aNd Complement Word
    ['1101 0011 BBBB AAAA', 'ncwf'],  # aNd Complement Word, update condition code Flags
    ['1101 1000 BBBB AAAA', 'srbc'],  # Shift Right Byte with Carry
    ['1101 1001 BBBB AAAA', 'srbcf'], # Shift Right Byte with Carry, update condition code Flags
    ['1101 1010 BBBB AAAA', 'srwc'],  # Shift Right Word with Carry
    ['1101 1011 BBBB AAAA', 'srwcf'], # Shift Right Word with Carry, update condition code Flags
    ['1101 1100 BBBB AAAA', 'srb'],   # Shift Right Byte
    ['1101 1101 BBBB AAAA', 'srbf'],  # Shift Right Byte, update condition code Flags
    ['1101 1110 BBBB AAAA', 'srw'],   # Shift Right Word
    ['1101 1111 BBBB AAAA', 'srwf'],  # Shift Right Word, update condition code Flags
    ['1110 0000 LLLL AAAA', 'ib'],    # Input Byte
    ['1110 0001 LLLL AAAA', 'ibf'],   # Input Byte, update condition code Flags
    ['1110 0010 LLLL AAAA', 'iw'],    # Input Word
    ['1110 0011 LLLL AAAA', 'iwf'],   # Input Word, update condition code Flags
    ['1110 0100 LLLL AAAA', 'isb'],   # Input Status Byte
    ['1110 0101 LLLL AAAA', 'isbf'],  # Input Status Byte, update condition code Flags
    ['1110 0110 uuuu AAAA', 'isw'],   # Input Status Word
    ['1110 0111 uuuu AAAA', 'iswf'],  # Input Status Word, update condition code Flags
    ['1110 1100 BBBB AAAA', 'mi'],    # Modify microInstruction
    ['1110 1110 BBBB AAAA', 'ltr'],   # Load Translation Register
    ['1111 0000 BBBB AAAA', 'rib1'],  # Read and Increment Byte by 1
    ['1111 0001 BBBB AAAA', 'wib1'],  # Write and Increment Byte by 1
    ['1111 0010 BBBB AAAA', 'riw1'],  # Read and Increment Word by 1
    ['1111 0011 BBBB AAAA', 'wiw1'],  # Write and Increment Word by 1
    ['1111 0100 BBBB AAAA', 'rib2'],  # Read and Increment Byte by 2
    ['1111 0101 BBBB AAAA', 'wib2'],  # Write and Increment Byte by 2
    ['1111 0110 BBBB AAAA', 'riw2'],  # Read and Increment Word by 2
    ['1111 0111 BBBB AAAA', 'wiw2'],  # Write and Increment Word by 2
    ['1111 1000 BBBB AAAA', 'r'],     # Read
    ['1111 1001 BBBB AAAA', 'w'],     # Write
    ['1111 1010 BBBB AAAA', 'ra'],    # Read Acknowledge
    ['1111 1011 BBBB AAAA', 'wa'],    # Write Acknowledge
    ['1111 1100 BBBB AAAA', 'ob'],    # Output Byte
    ['1111 1101 BBBB AAAA', 'ow'],    # Output Word
    ['1111 1110 BBBB AAAA', 'os'],    # Output Status
    ['1111 1111 xxxx xxxx', 'nop']    # No OPeration
   ]

# binary representation on page 4-45 has bit 14 = 1, should be 0
# OCW, OCWF       117000-117377   1001 1110 0000 0000

# undefined opcodes:
# 0111 1xxx xxxx xxxx
# 1010 1101 xxxx xxxx
# 1101 01xx xxxx xxxx
# 1110 10xx xxxx xxxx
# 1110 1101 xxxx xxxx  (MI according to AM100 manual)
# 1110 1111 xxxx xxxx  (LTR according to AM100 manual)

def encoding_parse(arch, mnem, encoding):
    encoding = encoding.replace(' ', '')
    bits = 0
    mask = 0
    fields = { }
    for i in range(len(encoding)):
        char = encoding[-i-1]
        if char == '0':
            mask |= (1 << i)
        elif char == '1':
            bits |= (1 << i)
            mask |= (1 << i)
        else:
            if char not in fields:
                fields[char] = Field(arch, char, i, 0)
            assert i == fields[char].lsb + fields[char].width
            fields[char].width += 1
    return Inst(mnem, bits, mask, fields)

inst_by_mnem = {}
inst_by_opcode = [None] * 256

def opcode_init(arch):
    for encoding, mnem in encodings:
        if mnem in inst_by_mnem:
            raise Exception('duplicate mnemonic: %s' % mnem)
        inst = encoding_parse(arch, mnem, encoding)
        inst_by_mnem[mnem] = inst
        hb = inst.bits >> 8
        hm = inst.mask >> 8
        for i in range(256):
            if i & hm == hb:
                if i in inst_by_opcode:
                    raise Exception('duplicate opcode: %02x' % i)
                inst_by_opcode[i] = inst


def disassemble(addr, opcode):
    extras = ''
    inst = inst_by_opcode[(opcode >> 8) & 0xff]
    if inst is None:
        inst = Inst('illegal', 0, 0, { 'O': [opcode, 0xffff]})
    mnem = inst.mnem
    extras = []
    if opcode & 0x010000:
        if mnem == 'jmp':
            mnem = 'jsr'
        else:
            extras.append('LRR')
    if opcode & 0x020000:
        extras.append('RSVC')
    if opcode & 0x3c0000:
        extras.append('0x%01x' % ((opcode >> 18) * 4))
    extras = '|'.join(extras)

    fields = {}
    for field in inst.fields:
        field_value = (opcode & inst.fields[field].get_mask()) >> inst.fields[field].lsb
        fields[field] = field_value
    #print(fields)

    fieldlist = []
    for field in sorted(fields.keys(), reverse=True):
        decoded = inst.fields[field].decode(addr, fields[field])
        if decoded is not None:
            fieldlist.append(decoded)
    fields = ','.join(fieldlist)

    target = None
    if 'T' in inst.fields:
        width = inst.fields['T'].width
        target = field_value = (opcode & inst.fields[field].get_mask()) >> inst.fields[field].lsb

        if width == 8:
            target |= ((addr + 1) & 0xf00)

    return mnem, fields, extras, target

def pass1_dis_inst(addr, opcode):
    pass

def pass1(code):
    for addr in range(2048):
        if code[addr] is not None:
            opcode = code[addr]
            pass1_dis_inst(addr, opcode)
            mnem, fields, extras, target = disassemble(addr, opcode)
            if (target is not None) and not symtab.has_value(target):
                symtab.add('L%03x' % target, target)
            
def pass2_dis_inst(label, addr, opcode):
    line = label
    if label != '':
        line += ':'
    if opcode is not None:
        mnem, fields, extras, target = disassemble(addr, opcode)
        line += '\t' + mnem
        if fields != '':
            line += '\t' + fields
        if extras != '':
            line += ',' + extras

    return line

def pass2(code, disfile, arch, dump=False):
    next_addr = -1
    for addr in range(2048):
        if symtab.has_value(addr) or (code[addr] is not None):
            if addr != next_addr:
                line = '\t.loc\t0x%03X' % addr
                if addr != 0:
                    line = '\n' + line
                print(line, file  = disfile)
            label = symtab.get_by_value(addr, '')
            opcode = code[addr]
            line = pass2_dis_inst(label, addr, opcode)
            if dump and (code[addr] is not None):
                if arch == 'lsi11':
                    ptam = pta_lsi11.get(addr)
                    if ptam is not None:
                        if (opcode & 0x3f0000) == 0:
                            line += ','
                        line += ',<%02X>' % ptam
                align = max(0, (40 + 7 - len(line.expandtabs(8)))) // 8
                line += '\t' * align + ';%03x: %06x' % (addr, opcode)
                if arch == 'lsi11':
                    ptam = org_lsi11.get(addr)
                    if ptam is not None:
                        line = line + ' ' + ptam
            print(line, file = disfile)
        if code[addr] is not None:
            next_addr = addr + 1

def read_object_file(f):
    obj = [None] * 2048
    for line in f:
        line = line.strip()
        assert len(line) == 11
        assert line[3:5] == ': '
        addr = int(line[0:3], 16)
        data = int(line[5:11], 16)
        assert obj[addr] is None
        obj[addr] = data
    return obj

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('objectfile', type=argparse.FileType('r'))
    parser.add_argument('disfile', type=argparse.FileType('w'), nargs='?', default = sys.stdout)
    parser.add_argument('--arch', choices=['lsi11', 'pascal'], help='architecture, used for register and field definitions')
    parser.add_argument('--dump', action='store_true', help='include address and instruction word in comment field')
    args = parser.parse_args()

    opcode_init(args.arch)

    if False:
        for mnem in sorted(inst_by_mnem.keys()):
            print(mnem, inst_by_mnem[mnem])

    if False:
        for opcode in range(0, 0x10000, 0x100):
            mnem, fields, extras, target = disassemble(0, opcode)
            print('%04x' % opcode, mnem, fields, target)

    code = read_object_file(args.objectfile)
    args.objectfile.close()

    pass1(code)
    pass2(code, args.disfile, args.arch, args.dump)
