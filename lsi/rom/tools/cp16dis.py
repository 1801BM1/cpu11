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
        return '0x%x' % field_value;

class UnusedDecoder(FieldDecoder):
    def decode(self, addr, field_value, width):
        if field_value == 0:
            return None
        return '0x%x' % field_value;

class TargetDecoder(FieldDecoder):
    def decode(self, addr, field_value, width):
        if width == 8:
            field_value |= ((addr + 1) & 0xf00)

        return symtab.get_by_value(field_value, '0x%03x' % field_value)

class RegisterDecoder(FieldDecoder):
    def __init__(self, arch):
        self.arch = arch
        self.regs = { 'lsi11':   {0x2: 'rbal',
                                  0x3: 'rbah',
                                  0x4: 'rsrcl',
                                  0x5: 'rsrch',
                                  0x6: 'rdstl',
                                  0x7: 'rdsth',
                                  0x8: 'rirl',
                                  0x9: 'rirh',
                                  0xa: 'rpswl',
                                  0xb: 'rpswh',
                                  0xc: 'spl',
                                  0xd: 'sph',
                                  0xe: 'pcl',
                                  0xf: 'pch'},
                      # Pascal Microengine register definitions are tentative
                      'pascal':  {0xa: 'ipcl',
                                  0xb: 'ipch',
                                  0xc: 'spl',
                                  0xd: 'sph',
                                  0xe: 'mpl',
                                  0xf: 'mph'},
                      'default': {0x0: 'gl',
                                  0x1: 'gh'}}

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
'ub':  0x0,
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
            extras.append('lrr')
    if opcode & 0x020000:
        extras.append('rsvc')
    if opcode & 0x3c0000:
        extras.append('0x%01x' % (opcode >> 18))
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
        if extras != '':
            line += ',' + extras
        if fields != '':
            line += '\t' + fields

    return line

def pass2(code, disfile, dump=False):
    next_addr = -1
    for addr in range(2048):
        if symtab.has_value(addr) or (code[addr] is not None):
            if addr != next_addr:
                line = '\torg\t0x%03x' % addr
                if addr != 0:
                    line = '\n' + line
                print(line, file  = disfile)
            label = symtab.get_by_value(addr, '')
            opcode = code[addr]
            line = pass2_dis_inst(label, addr, opcode)
            if dump and (code[addr] is not None):
                line += '\t;%03x: %06x' % (addr, opcode)
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
            mnem, fields, extras = disassemble(opcode)
            print('%04x' % opcode, mnem, fields)

    code = read_object_file(args.objectfile)
    args.objectfile.close()

    pass1(code)
    pass2(code, args.disfile, args.dump)
